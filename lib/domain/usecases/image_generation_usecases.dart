import 'dart:io';
import '../../domain/entities/image_entity.dart';
import '../repositories/image_repository.dart';

class GenerateImageUseCase {
  final ImageRepository repository;

  GenerateImageUseCase(this.repository);

  Future<ImageEntity> call(String prompt, {String? style}) async {
    final result = await repository.generateImage(prompt, style: style);
    return ImageEntity(
      id: result.id,
      prompt: result.prompt,
      imagePath: result.imagePath,
      timestamp: result.timestamp,
      style: result.style,
      qualityScore: result.qualityScore,
    );
  }
}

class GetGeneratedImagesUseCase {
  final ImageRepository repository;

  GetGeneratedImagesUseCase(this.repository);

  Future<List<ImageEntity>> call() async {
    final results = await repository.getGeneratedImages();
    return results.map((image) {
      return ImageEntity(
        id: image.id,
        prompt: image.prompt,
        imagePath: image.imagePath,
        timestamp: image.timestamp,
        style: image.style,
        qualityScore: image.qualityScore,
      );
    }).toList();
  }
}

class DeleteGeneratedImageUseCase {
  final ImageRepository repository;

  DeleteGeneratedImageUseCase(this.repository);

  Future<void> call(String imageId) async {
    await repository.deleteGeneratedImage(imageId);
  }
}

class UploadImageUseCase {
  final ImageRepository repository;

  UploadImageUseCase(this.repository);

  Future<void> call(File imageFile, {String? description}) async {
    await repository.uploadImage(imageFile, description: description);
  }
}

class GetUploadedImagesUseCase {
  final ImageRepository repository;

  GetUploadedImagesUseCase(this.repository);

  Future<List<ImageEntity>> call() async {
    final results = await repository.getUploadedImages();
    return results.map((image) {
      return ImageEntity(
        id: image.id,
        prompt: image.description ?? 'Uploaded Image',
        imagePath: image.originalPath,
        timestamp: image.timestamp,
      );
    }).toList();
  }
}
