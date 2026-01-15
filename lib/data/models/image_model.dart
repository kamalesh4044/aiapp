import 'package:hive/hive.dart';

part 'image_model.g.dart';

@HiveType(typeId: 1)
class GeneratedImage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String prompt;

  @HiveField(2)
  final String imagePath;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String? style;

  @HiveField(5)
  final double? qualityScore;

  @HiveField(6)
  final Map<String, dynamic>? metadata;

  GeneratedImage({
    required this.id,
    required this.prompt,
    required this.imagePath,
    required this.timestamp,
    this.style,
    this.qualityScore,
    this.metadata,
  });

  GeneratedImage copyWith({
    String? id,
    String? prompt,
    String? imagePath,
    DateTime? timestamp,
    String? style,
    double? qualityScore,
    Map<String, dynamic>? metadata,
  }) {
    return GeneratedImage(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      imagePath: imagePath ?? this.imagePath,
      timestamp: timestamp ?? this.timestamp,
      style: style ?? this.style,
      qualityScore: qualityScore ?? this.qualityScore,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prompt': prompt,
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
      'style': style,
      'qualityScore': qualityScore,
      'metadata': metadata,
    };
  }

  factory GeneratedImage.fromMap(Map<String, dynamic> map) {
    return GeneratedImage(
      id: map['id'] as String,
      prompt: map['prompt'] as String,
      imagePath: map['imagePath'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      style: map['style'] as String?,
      qualityScore: map['qualityScore'] as double?,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }
}

@HiveType(typeId: 2)
class UploadedImage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String originalPath;

  @HiveField(2)
  final String? processedPath;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final Map<String, dynamic>? analysisResult;

  UploadedImage({
    required this.id,
    required this.originalPath,
    this.processedPath,
    required this.timestamp,
    this.description,
    this.analysisResult,
  });

  UploadedImage copyWith({
    String? id,
    String? originalPath,
    String? processedPath,
    DateTime? timestamp,
    String? description,
    Map<String, dynamic>? analysisResult,
  }) {
    return UploadedImage(
      id: id ?? this.id,
      originalPath: originalPath ?? this.originalPath,
      processedPath: processedPath ?? this.processedPath,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
      analysisResult: analysisResult ?? this.analysisResult,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'originalPath': originalPath,
      'processedPath': processedPath,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'analysisResult': analysisResult,
    };
  }

  factory UploadedImage.fromMap(Map<String, dynamic> map) {
    return UploadedImage(
      id: map['id'] as String,
      originalPath: map['originalPath'] as String,
      processedPath: map['processedPath'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
      description: map['description'] as String?,
      analysisResult: map['analysisResult'] as Map<String, dynamic>?,
    );
  }
}
