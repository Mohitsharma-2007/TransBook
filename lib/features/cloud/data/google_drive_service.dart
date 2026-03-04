import 'dart:typed_data';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:googleapis/drive/v3.dart' as drive;

import '../../../core/database/database.dart';
import '../../../core/di/database_provider.dart';
import 'google_auth_service.dart';

// part 'google_drive_service.g.dart';

class GoogleDriveService {
  final AppDatabase _db;
  final GoogleAuthService _authService;

  GoogleDriveService(this._db, this._authService);

  bool get isAuthenticated => _authService.currentUser != null;

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
    final client = await _authService.getAuthenticatedClient();
    if (client == null) return false;

    final driveApi = drive.DriveApi(client);

    try {
      // 1. Ensure folder hierarchy exists
      // If a target folder ID is provided, use it as the root; otherwise use 'root'
      String currentParentId = _authService.targetFolderId ?? 'root';
      
      // If targetFolderId is default, we still want to ensure a 'TransBook' folder exists
      if (_authService.targetFolderId == null) {
        currentParentId = await _ensureFolder(driveApi, 'TransBook', parentId: 'root');
      }

      final fyFolderId = await _ensureFolder(driveApi, 'FY-$financialYear', parentId: currentParentId);
      final companyFolderId = await _ensureFolder(driveApi, companyName, parentId: fyFolderId);

      // 2. Upload PDF
      await _uploadFile(driveApi, fileName, pdfBytes, companyFolderId);
      return true;
    } catch (_) {
      return false;
    } finally {
      client.close();
    }
  }

  /// Process pending items from the sync queue.
  Future<void> processQueue() async {
    final client = await _authService.getAuthenticatedClient();
    if (client == null) return;
    client.close(); // Need further integration for batch loops

    final pending = await (_db.select(_db.syncQueue)
          ..where((tbl) => tbl.attempts.isSmallerThanValue(5))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .get();

    for (final entry in pending) {
      try {
        await (_db.update(_db.syncQueue)..where((tbl) => tbl.id.equals(entry.id))).write(
          SyncQueueCompanion(
            attempts: Value(entry.attempts + 1),
            lastAttempt: Value(DateTime.now().toIso8601String()),
          ),
        );
      } catch (_) {}
    }
  }

  Future<String> _ensureFolder(drive.DriveApi driveApi, String name, {required String parentId}) async {
    final query = "name='$name' and '$parentId' in parents and mimeType='application/vnd.google-apps.folder' and trashed=false";
    
    final searchResponse = await driveApi.files.list(q: query, $fields: 'files(id,name)');

    if (searchResponse.files != null && searchResponse.files!.isNotEmpty) {
      return searchResponse.files!.first.id!;
    }

    final folderMeta = drive.File()
      ..name = name
      ..mimeType = 'application/vnd.google-apps.folder'
      ..parents = [parentId];

    final createResponse = await driveApi.files.create(folderMeta);
    return createResponse.id!;
  }

  Future<void> _uploadFile(drive.DriveApi driveApi, String name, Uint8List bytes, String folderId) async {
    final fileMeta = drive.File()
      ..name = name
      ..parents = [folderId];

    final media = drive.Media(Stream.value(bytes.toList()), bytes.length);

    await driveApi.files.create(
      fileMeta,
      uploadMedia: media,
    );
  }
}

final googleDriveServiceProvider = Provider((ref) {
  final db = ref.watch(appDatabaseProvider);
  final authService = ref.watch(googleAuthServiceProvider);
  return GoogleDriveService(db, authService);
});

