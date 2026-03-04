import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:open_filex/open_filex.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileStorageService {
  Future<String> getBaseDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final transBookDir = Directory(p.join(docsDir.path, 'TransBook'));
    if (!await transBookDir.exists()) {
      await transBookDir.create(recursive: true);
    }
    return transBookDir.path;
  }

  Future<String> getInvoiceDirectory(String dateStr) async {
    final baseDir = await getBaseDirectory();
    
    // Parse year and month from dateStr (assuming YYYY-MM-DD or similar)
    String year = DateTime.now().year.toString();
    String month = DateTime.now().month.toString().padLeft(2, '0');
    
    try {
      final date = DateTime.parse(dateStr);
      year = date.year.toString();
      month = date.month.toString().padLeft(2, '0');
    } catch (_) {}

    final path = p.join(baseDir, 'Invoices', year, month);
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  Future<File> saveInvoiceFile({
    required String fileName,
    required List<int> bytes,
    required String dateStr,
    String? extension = 'pdf',
  }) async {
    final dirPath = await getInvoiceDirectory(dateStr);
    final filePath = p.join(dirPath, '$fileName.$extension');
    final file = File(filePath);
    return await file.writeAsBytes(bytes);
  }

  Future<void> openFolder(String dateStr) async {
    final dirPath = await getInvoiceDirectory(dateStr);
    await OpenFilex.open(dirPath);
  }

  Future<void> openFile(String filePath) async {
    await OpenFilex.open(filePath);
  }
}

final fileStorageServiceProvider = Provider((ref) => FileStorageService());

