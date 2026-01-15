import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileUtils {
  /// Get app documents directory
  static Future<Directory> getAppDocumentsDirectory() async {
    return getApplicationDocumentsDirectory();
  }

  /// Get app support directory
  static Future<Directory> getAppSupportDirectory() async {
    return getApplicationSupportDirectory();
  }

  /// Get app cache directory
  static Future<Directory> getAppCacheDirectory() async {
    return getTemporaryDirectory();
  }

  /// Create directory if not exists
  static Future<Directory> ensureDirectoryExists(String dirPath) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Save file to app documents
  static Future<File> saveToDocuments(
    String fileName,
    List<int> bytes,
  ) async {
    final dir = await getAppDocumentsDirectory();
    final file = File(path.join(dir.path, fileName));
    return file.writeAsBytes(bytes);
  }

  /// Read file from app documents
  static Future<List<int>?> readFromDocuments(String fileName) async {
    try {
      final dir = await getAppDocumentsDirectory();
      final file = File(path.join(dir.path, fileName));
      if (await file.exists()) {
        return file.readAsBytes();
      }
    } catch (e) {
      print('Error reading file: $e');
    }
    return null;
  }

  /// Delete file from app documents
  static Future<bool> deleteFromDocuments(String fileName) async {
    try {
      final dir = await getAppDocumentsDirectory();
      final file = File(path.join(dir.path, fileName));
      if (await file.exists()) {
        await file.delete();
        return true;
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
    return false;
  }

  /// Get file size in bytes
  static Future<int> getFileSize(File file) async {
    try {
      if (await file.exists()) {
        return file.lengthSync();
      }
    } catch (e) {
      print('Error getting file size: $e');
    }
    return 0;
  }

  /// Check if file exists
  static Future<bool> fileExists(String filePath) async {
    return File(filePath).exists();
  }

  /// Create file path
  static String createFilePath(String directory, String fileName) {
    return path.join(directory, fileName);
  }

  /// Get file extension
  static String getFileExtension(String filePath) {
    return path.extension(filePath);
  }

  /// Get file name without extension
  static String getFileNameWithoutExtension(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }
}
