import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static Future<void> saveReport(String path) async {
    // saved already to app doc dir; no extra action needed for now
  }

  static Future<List<String>> listReports() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync().where((f) => f.path.toLowerCase().endsWith('.pdf')).map((f) => f.path).toList();
    files.sort((a, b) => b.compareTo(a)); // newest first
    return files;
  }

  static Future<void> deleteReport(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
  }
}
