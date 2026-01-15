import 'package:hive/hive.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 0)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final String response;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final bool isUserMessage;

  @HiveField(5)
  final double? confidence;

  ChatMessage({
    required this.id,
    required this.message,
    required this.response,
    required this.timestamp,
    required this.isUserMessage,
    this.confidence,
  });

  ChatMessage copyWith({
    String? id,
    String? message,
    String? response,
    DateTime? timestamp,
    bool? isUserMessage,
    double? confidence,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      response: response ?? this.response,
      timestamp: timestamp ?? this.timestamp,
      isUserMessage: isUserMessage ?? this.isUserMessage,
      confidence: confidence ?? this.confidence,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'response': response,
      'timestamp': timestamp.toIso8601String(),
      'isUserMessage': isUserMessage,
      'confidence': confidence,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      message: map['message'] as String,
      response: map['response'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      isUserMessage: map['isUserMessage'] as bool,
      confidence: map['confidence'] as double?,
    );
  }
}
