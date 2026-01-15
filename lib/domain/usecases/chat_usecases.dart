import '../../domain/entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<ChatEntity> call(String message) async {
    final result = await repository.sendMessage(message);
    return ChatEntity(
      id: result.id,
      message: result.message,
      response: result.response,
      timestamp: result.timestamp,
      isUserMessage: result.isUserMessage,
      confidence: result.confidence,
    );
  }
}

class GetChatHistoryUseCase {
  final ChatRepository repository;

  GetChatHistoryUseCase(this.repository);

  Future<List<ChatEntity>> call() async {
    final results = await repository.getHistory();
    return results.map((message) {
      return ChatEntity(
        id: message.id,
        message: message.message,
        response: message.response,
        timestamp: message.timestamp,
        isUserMessage: message.isUserMessage,
        confidence: message.confidence,
      );
    }).toList();
  }
}

class ClearChatHistoryUseCase {
  final ChatRepository repository;

  ClearChatHistoryUseCase(this.repository);

  Future<void> call() async {
    await repository.clearHistory();
  }
}

class DeleteChatMessageUseCase {
  final ChatRepository repository;

  DeleteChatMessageUseCase(this.repository);

  Future<void> call(String messageId) async {
    await repository.deleteMessage(messageId);
  }
}
