import 'dart:io';
import 'package:image/image.dart' as img;

class ImageUtils {
  /// Compress image to reduce file size
  static Future<File> compressImage(File imageFile, {int quality = 85}) async {
    final image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) return imageFile;

    final compressed = img.encodeJpg(image, quality: quality);
    return imageFile..writeAsBytesSync(compressed);
  }

  /// Resize image to specific dimensions
  static Future<File> resizeImage(
    File imageFile, {
    int width = 256,
    int height = 256,
  }) async {
    final image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) return imageFile;

    final resized = img.copyResize(image, width: width, height: height);
    return imageFile..writeAsBytesSync(img.encodePng(resized));
  }

  /// Convert image to grayscale
  static Future<File> toGrayscale(File imageFile) async {
    final image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) return imageFile;

    final grayscale = img.grayscale(image);
    return imageFile..writeAsBytesSync(img.encodePng(grayscale));
  }

  /// Get image dimensions
  static Future<Size> getImageDimensions(File imageFile) async {
    final image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) return const Size(0, 0);
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  /// Normalize image pixel values to 0-1 range
  static List<List<List<double>>> normalizeImage(
    List<int> imageBytes,
    int width,
    int height,
  ) {
    final normalized = <List<List<double>>>[];

    for (int i = 0; i < height; i++) {
      final row = <List<double>>[];
      for (int j = 0; j < width; j++) {
        final pixelIndex = (i * width + j) * 4;
        final r = imageBytes[pixelIndex] / 255.0;
        final g = imageBytes[pixelIndex + 1] / 255.0;
        final b = imageBytes[pixelIndex + 2] / 255.0;
        row.add([r, g, b]);
      }
      normalized.add(row);
    }

    return normalized;
  }

  /// Format file size in human readable format
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (bytes.log() / 1024.log()).floor();
    return "${(bytes / (1024 * i)).toStringAsFixed(2)} ${suffixes[i]}";
  }
}
