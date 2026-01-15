class ChatEntity {
  final String id;
  final String message;
  final String response;
  final DateTime timestamp;
  final bool isUserMessage;
  final double? confidence;

  const ChatEntity({
    required this.id,
    required this.message,
    required this.response,
    required this.timestamp,
    required this.isUserMessage,
    this.confidence,
  });

  ChatEntity copyWith({
    String? id,
    String? message,
    String? response,
    DateTime? timestamp,
    bool? isUserMessage,
    double? confidence,
  }) {
    return ChatEntity(
      id: id ?? this.id,
      message: message ?? this.message,
      response: response ?? this.response,
      timestamp: timestamp ?? this.timestamp,
      isUserMessage: isUserMessage ?? this.isUserMessage,
      confidence: confidence ?? this.confidence,
    );
  }

  @override
  String toString() =>
      'ChatEntity(id: $id, message: $message, response: $response, timestamp: $timestamp, isUserMessage: $isUserMessage, confidence: $confidence)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatEntity &&
        other.id == id &&
        other.message == message &&
        other.response == response &&
        other.timestamp == timestamp &&
        other.isUserMessage == isUserMessage &&
        other.confidence == confidence;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      message.hashCode ^
      response.hashCode ^
      timestamp.hashCode ^
      isUserMessage.hashCode ^
      confidence.hashCode;
}
