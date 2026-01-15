import 'dart:async';
import '../../core/config/api_config.dart';
import '../../core/network/http_client.dart';

// Models
class ChatMessage {
  final String id;
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime timestamp;
  final bool isLoading;
  final String? error;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.isLoading = false,
    this.error,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };

  ChatMessage copyWith({
    String? id,
    String? role,
    String? content,
    DateTime? timestamp,
    bool? isLoading,
    String? error,
  }) =>
      ChatMessage(
        id: id ?? this.id,
        role: role ?? this.role,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}

class ChatResponse {
  final String content;
  final String role;
  final int inputTokens;
  final int outputTokens;

  ChatResponse({
    required this.content,
    required this.role,
    required this.inputTokens,
    required this.outputTokens,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    final choice = (json['choices'] as List).first as Map<String, dynamic>;
    final usage = json['usage'] as Map<String, dynamic>;

    return ChatResponse(
      content: choice['message']['content'] ?? '',
      role: choice['message']['role'] ?? 'assistant',
      inputTokens: usage['prompt_tokens'] ?? 0,
      outputTokens: usage['completion_tokens'] ?? 0,
    );
  }
}

// OpenAI Chat Service
class OpenAIChatService {
  final HttpClient _httpClient;
  static const String _endpoint = 'chat/completions';

  OpenAIChatService(this._httpClient);

  Future<ChatResponse> sendMessage(
    String message, {
    List<ChatMessage>? conversationHistory,
    String? model,
  }) async {
    try {
      model ??= ApiConfig.gptModel;

      final messages = _buildMessages(message, conversationHistory);

      final requestBody = {
        'model': model,
        'messages': messages,
        'max_tokens': ApiConfig.gptMaxTokens,
        'temperature': ApiConfig.gptTemperature,
      };

      final response = await _httpClient.post<ChatResponse>(
        _endpoint,
        data: requestBody,
        fromJson: (json) => ChatResponse.fromJson(json),
      );

      return response;
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  Stream<String> sendMessageStream(
    String message, {
    List<ChatMessage>? conversationHistory,
    String? model,
  }) async* {
    try {
      model ??= ApiConfig.gptModel;

      final messages = _buildMessages(message, conversationHistory);

      final requestBody = {
        'model': model,
        'messages': messages,
        'max_tokens': ApiConfig.gptMaxTokens,
        'temperature': ApiConfig.gptTemperature,
        'stream': true,
      };

      // For streaming, we would need to implement SSE handling
      // This is a placeholder - implement SSE handling in actual app
      final response = await _httpClient.post<ChatResponse>(
        _endpoint,
        data: requestBody,
        fromJson: (json) => ChatResponse.fromJson(json),
      );

      yield response.content;
    } catch (e) {
      print('Error in stream: $e');
      rethrow;
    }
  }

  List<Map<String, String>> _buildMessages(
    String message,
    List<ChatMessage>? history,
  ) {
    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content':
            'You are a helpful AI assistant. Provide clear, concise, and accurate responses. '
            'Be friendly and professional.',
      },
    ];

    if (history != null && history.isNotEmpty) {
      for (final msg in history) {
        messages.add({
          'role': msg.role,
          'content': msg.content,
        });
      }
    }

    messages.add({
      'role': 'user',
      'content': message,
    });

    return messages;
  }
}

// OpenAI Image Generation Service
class OpenAIImageService {
  final HttpClient _httpClient;
  static const String _endpoint = 'images/generations';

  OpenAIImageService(this._httpClient);

  Future<String> generateImage(
    String prompt, {
    String? size,
    String? quality,
    int? numberOfImages,
  }) async {
    try {
      size ??= ApiConfig.dalleSize;
      quality ??= ApiConfig.dalleQuality;
      numberOfImages ??= ApiConfig.dalleImagesPerRequest;

      final requestBody = {
        'model': ApiConfig.dalleModel,
        'prompt': prompt,
        'n': numberOfImages,
        'size': size,
        'quality': quality,
      };

      final response = await _httpClient.post<Map<String, dynamic>>(
        _endpoint,
        data: requestBody,
        fromJson: (json) => json,
      );

      final imageUrl = (response['data'] as List).first['url'] as String;
      return imageUrl;
    } catch (e) {
      print('Error generating image: $e');
      rethrow;
    }
  }

  Future<List<String>> generateImages(
    String prompt, {
    String? size,
    String? quality,
    int? numberOfImages = 3,
  }) async {
    try {
      size ??= ApiConfig.dalleSize;
      quality ??= ApiConfig.dalleQuality;

      final requestBody = {
        'model': ApiConfig.dalleModel,
        'prompt': prompt,
        'n': numberOfImages,
        'size': size,
        'quality': quality,
      };

      final response = await _httpClient.post<Map<String, dynamic>>(
        _endpoint,
        data: requestBody,
        fromJson: (json) => json,
      );

      final images = (response['data'] as List)
          .map((item) => item['url'] as String)
          .toList();

      return images;
    } catch (e) {
      print('Error generating images: $e');
      rethrow;
    }
  }

  Future<String> editImage(
    String imagePath,
    String prompt, {
    String? maskPath,
    String? size,
  }) async {
    // Implementation for image editing endpoint
    // Requires multipart form data handling
    try {
      size ??= ApiConfig.dalleSize;

      // Placeholder implementation
      return '';
    } catch (e) {
      print('Error editing image: $e');
      rethrow;
    }
  }
}

// Vision API Service (for image analysis)
class OpenAIVisionService {
  final HttpClient _httpClient;
  static const String _endpoint = 'chat/completions';

  OpenAIVisionService(this._httpClient);

  Future<String> analyzeImage(
    String imageUrl, {
    String? prompt,
  }) async {
    try {
      prompt ??= 'What is in this image? Provide a detailed description.';

      final requestBody = {
        'model': 'gpt-4-vision-preview',
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image_url',
                'image_url': {'url': imageUrl},
              },
              {
                'type': 'text',
                'text': prompt,
              }
            ],
          }
        ],
        'max_tokens': 1024,
      };

      final response = await _httpClient.post<ChatResponse>(
        _endpoint,
        data: requestBody,
        fromJson: (json) => ChatResponse.fromJson(json),
      );

      return response.content;
    } catch (e) {
      print('Error analyzing image: $e');
      rethrow;
    }
  }
}
