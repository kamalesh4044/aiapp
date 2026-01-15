import 'package:uuid/uuid.dart';
import '../models/chat_model.dart';

abstract class ChatRepository {
  Future<ChatMessage> sendMessage(String message);
  Future<List<ChatMessage>> getHistory();
  Future<void> saveMessage(ChatMessage message);
  Future<void> clearHistory();
  Future<void> deleteMessage(String messageId);
}

class ChatRepositoryImpl implements ChatRepository {
  // Local storage for chat messages
  final Map<String, ChatMessage> _localChat = {};

  @override
  Future<ChatMessage> sendMessage(String message) async {
    // Mock AI response - integrate with actual ML model later
    final response = await _generateResponse(message);
    
    final chatMessage = ChatMessage(
      id: const Uuid().v4(),
      message: message,
      response: response,
      timestamp: DateTime.now(),
      isUserMessage: true,
      confidence: 0.85,
    );

    _localChat[chatMessage.id] = chatMessage;
    return chatMessage;
  }

  @override
  Future<List<ChatMessage>> getHistory() async {
    return _localChat.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<void> saveMessage(ChatMessage message) async {
    _localChat[message.id] = message;
  }

  @override
  Future<void> clearHistory() async {
    _localChat.clear();
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    _localChat.remove(messageId);
  }

  Future<String> _generateResponse(String message) async {
    // Placeholder - will be replaced with actual ML inference
    await Future.delayed(const Duration(seconds: 1));
    return 'This is a response to: "$message". (Offline Mode - No real AI response yet)';
  }
}
