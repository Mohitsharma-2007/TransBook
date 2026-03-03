import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database.dart';
import '../../../core/di/database_provider.dart';

part 'google_drive_service.g.dart';

class GoogleDriveService {
  final AppDatabase _db;
  final Dio _dio;
  String? _accessToken;
  bool _isAuthenticated = false;

  GoogleDriveService(this._db, {Dio? dio}) : _dio = dio ?? Dio();

  bool get isAuthenticated => _isAuthenticated;

  void setAccessToken(String token) {
    _accessToken = token;
    _isAuthenticated = true;
  }

  /// Queue an invoice for upload to Google Drive.
  Future<void> enqueueSync(int entityId, String entityType) async {
    await _db.into(_db.syncQueue).insert(SyncQueueCompanion(
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: const Value('UPLOAD'),
      createdAt: Value(DateTime.now().toIso8601String()),
    ));
  }

  /// Sync a PDF to Google Drive under TransBook/FY-{year}/CompanyName/ folder.
  Future<bool> syncInvoice({
    required String fileName,
    required Uint8List pdfBytes,
    required String companyName,
    required String financialYear,
  }) async {
    if (!_isAuthenticated || _accessToken == null) return false;

    try {
      // 1. Ensure folder hierarchy exists
      final rootFolderId = await _ensureFolder('TransBook', parentId: 'root');
      final fyFolderId = await _ensureFolder('FY-$financialYear', parentId: rootFolderId);
      final companyFolderId = await _ensureFolder(companyName, parentId: fyFolderId);

      // 2. Upload PDF
      await _uploadFile(fileName, pdfBytes, companyFolderId);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Process pending items from the sync queue.
  Future<void> processQueue() async {
    if (!_isAuthenticated) return;

    final pending = await (_db.select(_db.syncQueue)
          ..where((tbl) => tbl.attempts.isSmallerThanValue(5))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .get();

    for (final entry in pending) {
      try {
        // In a full implementation, fetch the entity, generate PDF, and upload.
        // For now, mark as attempted.
        await (_db.update(_db.syncQueue)..where((tbl) => tbl.id.equals(entry.id))).write(
          SyncQueueCompanion(
            attempts: Value(entry.attempts + 1),
            lastAttempt: Value(DateTime.now().toIso8601String()),
          ),
        );
      } catch (_) {
        // Silently retry on next cycle
      }
    }
  }

  Future<String> _ensureFolder(String name, {required String parentId}) async {
    // Search for existing folder
    final searchResponse = await _dio.get(
      'https://www.googleapis.com/drive/v3/files',
      queryParameters: {
        'q': "name='$name' and '$parentId' in parents and mimeType='application/vnd.google-apps.folder' and trashed=false",
        'fields': 'files(id,name)',
      },
      options: Options(headers: {'Authorization': 'Bearer $_accessToken'}),
    );

    final files = searchResponse.data['files'] as List?;
    if (files != null && files.isNotEmpty) {
      return files[0]['id'] as String;
    }

    // Create folder
    final createResponse = await _dio.post(
      'https://www.googleapis.com/drive/v3/files',
      data: {
        'name': name,
        'mimeType': 'application/vnd.google-apps.folder',
        'parents': [parentId],
      },
      options: Options(headers: {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      }),
    );
    return createResponse.data['id'] as String;
  }

  Future<void> _uploadFile(String name, Uint8List bytes, String folderId) async {
    final metadata = {
      'name': name,
      'parents': [folderId],
    };

    final formData = FormData.fromMap({
      'metadata': MultipartFile.fromString(
        '${metadata}',
        contentType: DioMediaType.parse('application/json'),
      ),
      'file': MultipartFile.fromBytes(bytes, filename: name, contentType: DioMediaType.parse('application/pdf')),
    });

    await _dio.post(
      'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $_accessToken'}),
    );
  }
}

@riverpod
GoogleDriveService googleDriveService(GoogleDriveServiceRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return GoogleDriveService(db);
}
