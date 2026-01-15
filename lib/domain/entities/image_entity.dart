class ImageEntity {
  final String id;
  final String prompt;
  final String imagePath;
  final DateTime timestamp;
  final String? style;
  final double? qualityScore;

  const ImageEntity({
    required this.id,
    required this.prompt,
    required this.imagePath,
    required this.timestamp,
    this.style,
    this.qualityScore,
  });

  ImageEntity copyWith({
    String? id,
    String? prompt,
    String? imagePath,
    DateTime? timestamp,
    String? style,
    double? qualityScore,
  }) {
    return ImageEntity(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      imagePath: imagePath ?? this.imagePath,
      timestamp: timestamp ?? this.timestamp,
      style: style ?? this.style,
      qualityScore: qualityScore ?? this.qualityScore,
    );
  }

  @override
  String toString() =>
      'ImageEntity(id: $id, prompt: $prompt, imagePath: $imagePath, timestamp: $timestamp, style: $style, qualityScore: $qualityScore)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageEntity &&
        other.id == id &&
        other.prompt == prompt &&
        other.imagePath == imagePath &&
        other.timestamp == timestamp &&
        other.style == style &&
        other.qualityScore == qualityScore;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      prompt.hashCode ^
      imagePath.hashCode ^
      timestamp.hashCode ^
      style.hashCode ^
      qualityScore.hashCode;
}
