import 'dart:io';
import 'package:uuid/uuid.dart';
import '../models/image_model.dart';
import '../../core/utils/image_utils.dart';

abstract class ImageRepository {
  Future<GeneratedImage> generateImage(String prompt, {String? style});
  Future<List<GeneratedImage>> getGeneratedImages();
  Future<void> deleteGeneratedImage(String imageId);
  
  Future<UploadedImage> uploadImage(File imageFile, {String? description});
  Future<List<UploadedImage>> getUploadedImages();
  Future<void> deleteUploadedImage(String imageId);
}

class ImageRepositoryImpl implements ImageRepository {
  final Map<String, GeneratedImage> _generatedImages = {};
  final Map<String, UploadedImage> _uploadedImages = {};

  @override
  Future<GeneratedImage> generateImage(String prompt, {String? style}) async {
    // Placeholder - will be replaced with actual ML inference
    await Future.delayed(const Duration(seconds: 2));
    
    final generatedImage = GeneratedImage(
      id: const Uuid().v4(),
      prompt: prompt,
      imagePath: '', // Will be populated with actual generated image path
      timestamp: DateTime.now(),
      style: style ?? 'default',
      qualityScore: 0.82,
      metadata: {
        'model': 'offline_image_gen_v1',
        'inference_time_ms': 2000,
      },
    );

    _generatedImages[generatedImage.id] = generatedImage;
    return generatedImage;
  }

  @override
  Future<List<GeneratedImage>> getGeneratedImages() async {
    return _generatedImages.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<void> deleteGeneratedImage(String imageId) async {
    _generatedImages.remove(imageId);
  }

  @override
  Future<UploadedImage> uploadImage(File imageFile, {String? description}) async {
    // Compress and process image
    final compressed = await ImageUtils.compressImage(imageFile);
    final resized = await ImageUtils.resizeImage(compressed);
    
    final uploadedImage = UploadedImage(
      id: const Uuid().v4(),
      originalPath: imageFile.path,
      processedPath: resized.path,
      timestamp: DateTime.now(),
      description: description,
      analysisResult: {
        'format': 'jpeg',
        'compression_ratio': 0.65,
      },
    );

    _uploadedImages[uploadedImage.id] = uploadedImage;
    return uploadedImage;
  }

  @override
  Future<List<UploadedImage>> getUploadedImages() async {
    return _uploadedImages.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<void> deleteUploadedImage(String imageId) async {
    _uploadedImages.remove(imageId);
  }
}
