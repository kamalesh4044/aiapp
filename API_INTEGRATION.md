# 🔌 OpenAI Integration Guide

## Overview

This Flutter application is fully integrated with **OpenAI APIs** providing:

- **GPT-4 Turbo** - Advanced AI conversations
- **DALL-E 3** - Professional image generation
- **GPT-4 Vision** - Image understanding and analysis

## Architecture

```
┌─────────────────────────────────────────────────┐
│         Flutter UI Screens                      │
│  ┌──────────────────────────────────────────┐  │
│  │ • ChatScreenOnline                       │  │
│  │ • ImageGenerationScreenOnline            │  │
│  │ • SettingsScreenOnline                   │  │
│  └──────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│      Service Layer (Dependency Injection)       │
│  ┌──────────────────────────────────────────┐  │
│  │ • OpenAIChatService                      │  │
│  │ • OpenAIImageService                     │  │
│  │ • OpenAIVisionService                    │  │
│  └──────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│         HTTP Client Layer                       │
│  ┌──────────────────────────────────────────┐  │
│  │ • HTTP requests with interceptors        │  │
│  │ • Error handling & retry logic           │  │
│  │ • Request/response logging               │  │
│  └──────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│      OpenAI API (https://api.openai.com/v1)     │
└─────────────────────────────────────────────────┘
```

## Setup Steps

### 1. Get OpenAI API Key

```bash
# Visit: https://platform.openai.com/account/api-keys
# Create new secret key
# Copy the key (visible only once!)
```

### 2. Configure in Flutter App

**Option A: Direct Configuration (Development)**

Edit `lib/core/config/api_config.dart`:

```dart
static const String openaiApiKey = 'sk-your-key-here';
```

**Option B: Environment Variables (Recommended)**

Create `.env` file:

```env
OPENAI_API_KEY=sk-your-key-here
```

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

Update `lib/main.dart`:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  
  setupServiceLocator();
  ApiConfig.setApiKey(dotenv.env['OPENAI_API_KEY']!);
  
  runApp(const MyApp());
}
```

**Option C: Runtime Configuration (Best for Users)**

In Settings Screen:

```dart
// User pastes API key in UI
getIt<HttpClient>().setApiKey(userProvidedKey);
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run Application

```bash
flutter run
```

---

## API Endpoints

### Chat Completions

```
POST https://api.openai.com/v1/chat/completions

Request:
{
  "model": "gpt-4-turbo",
  "messages": [
    {"role": "system", "content": "You are helpful..."},
    {"role": "user", "content": "What is AI?"}
  ],
  "max_tokens": 2000,
  "temperature": 0.7
}

Response:
{
  "choices": [{
    "message": {
      "role": "assistant",
      "content": "Artificial Intelligence..."
    }
  }],
  "usage": {
    "prompt_tokens": 50,
    "completion_tokens": 200
  }
}
```

### Image Generation

```
POST https://api.openai.com/v1/images/generations

Request:
{
  "model": "dall-e-3",
  "prompt": "A serene mountain landscape",
  "n": 1,
  "size": "1024x1024",
  "quality": "hd"
}

Response:
{
  "data": [{
    "url": "https://..."
  }]
}
```

### Vision Analysis

```
POST https://api.openai.com/v1/chat/completions

Request:
{
  "model": "gpt-4-vision-preview",
  "messages": [{
    "role": "user",
    "content": [
      {
        "type": "image_url",
        "image_url": {"url": "https://..."}
      },
      {
        "type": "text",
        "text": "Describe this image"
      }
    ]
  }]
}

Response:
{
  "choices": [{
    "message": {
      "role": "assistant",
      "content": "The image shows..."
    }
  }]
}
```

---

## Service Usage

### ChatService

```dart
import 'injection/service_locator.dart';
import 'data/services/openai_service.dart';

final chatService = getIt<OpenAIChatService>();

// Single message
final response = await chatService.sendMessage(
  'What is quantum computing?',
  conversationHistory: previousMessages,
);

// Stream response (for real-time display)
await for (final chunk in chatService.sendMessageStream('Hello')) {
  print(chunk);
}
```

### ImageService

```dart
final imageService = getIt<OpenAIImageService>();

// Single image
final url = await imageService.generateImage(
  'A futuristic city at sunset',
  size: '1024x1024',
  quality: 'hd',
);

// Multiple images
final urls = await imageService.generateImages(
  'Mountain landscape',
  numberOfImages: 4,
);
```

### VisionService

```dart
final visionService = getIt<OpenAIVisionService>();

final analysis = await visionService.analyzeImage(
  'https://example.com/image.jpg',
  prompt: 'What objects are in this image?',
);
```

---

## Error Handling

### Network Errors

```dart
import 'package:dio/dio.dart';

try {
  final response = await chatService.sendMessage('Hello');
} on DioException catch (e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      print('Connection timeout');
      break;
    case DioExceptionType.sendTimeout:
      print('Send timeout');
      break;
    case DioExceptionType.receiveTimeout:
      print('Receive timeout');
      break;
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        print('Invalid API key');
      } else if (statusCode == 429) {
        print('Rate limit exceeded');
      } else if (statusCode == 500) {
        print('OpenAI service error');
      }
      break;
    case DioExceptionType.unknown:
      print('Unknown error: ${e.message}');
      break;
    default:
      print('Error: ${e.message}');
  }
} catch (e) {
  print('Unexpected error: $e');
}
```

### Retry Logic

```dart
Future<T> retryRequest<T>(
  Future<T> Function() request,
  {int maxRetries = 3}
) async {
  for (int i = 0; i < maxRetries; i++) {
    try {
      return await request();
    } catch (e) {
      if (i == maxRetries - 1) rethrow;
      
      // Exponential backoff
      await Future.delayed(
        Duration(milliseconds: 1000 * (i + 1)),
      );
    }
  }
}

// Usage:
final response = await retryRequest(
  () => chatService.sendMessage('Hello'),
);
```

---

## Models Overview

### Chat Models

| Model | Speed | Cost | Best For |
|-------|-------|------|----------|
| gpt-4-turbo | Slower | Higher | Complex reasoning, detailed tasks |
| gpt-3.5-turbo | Fast | Lower | Simple Q&A, quick responses |

**Choose based on:** task complexity vs. budget

### Image Models

| Model | Quality | Size Options | Cost |
|-------|---------|---------------|------|
| dall-e-3 | Excellent | 1024x1024 only | Higher ($0.04-0.08) |
| dall-e-2 | Good | 256, 512, 1024 | Lower |

### Vision Models

| Model | Capability | Use Case |
|-------|-----------|----------|
| gpt-4-vision | Image understanding | Analyze images, extract info |
| gpt-4-turbo | Text from images | OCR, document analysis |

---

## Configuration Matrix

### Performance-Optimized

```dart
// For speed and cost-effectiveness
static const String gptModel = 'gpt-3.5-turbo';
static const int gptMaxTokens = 500;
static const double gptTemperature = 0.5;
static const String dalleModel = 'dall-e-2';
```

### Quality-Optimized

```dart
// For best results, higher cost
static const String gptModel = 'gpt-4-turbo';
static const int gptMaxTokens = 4000;
static const double gptTemperature = 0.7;
static const String dalleSize = '1024x1024';
static const String dalleQuality = 'hd';
```

### Cost-Optimized

```dart
// Minimum viable quality
static const String gptModel = 'gpt-3.5-turbo';
static const int gptMaxTokens = 256;
static const String dalleQuality = 'standard';
```

---

## Monitoring & Logging

### Enable Debug Logs

```dart
// In api_config.dart
static const bool enableDebugLogs = true;
```

### Example Output

```
🚀 REQUEST: POST /chat/completions
📦 DATA: {model: gpt-4-turbo, messages: [...]}
✅ RESPONSE: 200 /chat/completions
```

### Monitor Token Usage

```dart
final response = await chatService.sendMessage('Hello');
print('Input tokens: ${response.inputTokens}');
print('Output tokens: ${response.outputTokens}');
print('Total cost: \$${(response.inputTokens * 0.01 + response.outputTokens * 0.03) / 1000}');
```

---

## Best Practices

### 1. Rate Limiting

```dart
class RateLimiter {
  final int requestsPerMinute;
  final Queue<DateTime> _timestamps = Queue();

  RateLimiter({this.requestsPerMinute = 60});

  Future<void> checkAndWait() async {
    final now = DateTime.now();
    _timestamps.removeWhere(
      (t) => now.difference(t).inMinutes > 1,
    );

    if (_timestamps.length >= requestsPerMinute) {
      final oldestTime = _timestamps.first;
      final waitDuration = Duration(minutes: 1) -
          now.difference(oldestTime);
      await Future.delayed(waitDuration);
    }

    _timestamps.add(now);
  }
}
```

### 2. Caching Responses

```dart
class CachedChatService {
  final OpenAIChatService _service;
  final Map<String, ChatResponse> _cache = {};

  Future<ChatResponse> sendMessage(String message) async {
    if (_cache.containsKey(message)) {
      return _cache[message]!;
    }

    final response = await _service.sendMessage(message);
    _cache[message] = response;
    return response;
  }

  void clearCache() => _cache.clear();
}
```

### 3. Token Management

```dart
class TokenTracker {
  int totalInputTokens = 0;
  int totalOutputTokens = 0;

  void addUsage(ChatResponse response) {
    totalInputTokens += response.inputTokens;
    totalOutputTokens += response.outputTokens;
  }

  double get estimatedCost {
    return (totalInputTokens * 0.01 + totalOutputTokens * 0.03) / 1000;
  }

  void printSummary() {
    print('Total tokens: ${totalInputTokens + totalOutputTokens}');
    print('Estimated cost: \$${estimatedCost.toStringAsFixed(4)}');
  }
}
```

### 4. Input Validation

```dart
bool validateChatPrompt(String prompt) {
  if (prompt.isEmpty || prompt.trim().isEmpty) {
    return false;
  }
  if (prompt.length > 4000) {
    return false;
  }
  return true;
}

bool validateImagePrompt(String prompt) {
  if (prompt.isEmpty || prompt.trim().isEmpty) {
    return false;
  }
  if (prompt.length > 1000) {
    return false;
  }
  // Avoid potentially problematic content
  final forbidden = ['weapon', 'violence', 'explicit'];
  return !forbidden.any(prompt.toLowerCase().contains);
}
```

---

## Troubleshooting

### Issue: 401 Unauthorized

**Cause:** Invalid or missing API key

**Solution:**
```dart
// Check API key format
if (!apiKey.startsWith('sk-')) {
  print('Invalid API key format');
  return;
}

// Verify API key is active
// Visit: https://platform.openai.com/account/api-keys
```

### Issue: 429 Rate Limited

**Cause:** Too many requests

**Solution:**
```dart
// Implement exponential backoff
// Or use ChatGPT Plus for higher limits
// Or upgrade API usage tier
```

### Issue: 500 Internal Server Error

**Cause:** OpenAI service issue

**Solution:**
```dart
// Check OpenAI status: https://status.openai.com
// Retry after a delay
// Contact OpenAI support if persistent
```

### Issue: Timeout

**Cause:** Slow connection or large request

**Solution:**
```dart
// Increase timeout in api_config.dart
static const int receiveTimeout = 120; // 2 minutes

// Or reduce request size
static const int gptMaxTokens = 1000; // Instead of 2000
```

---

## API Reference

### Request Headers

```dart
headers: {
  'Authorization': 'Bearer sk-...',
  'Content-Type': 'application/json',
  'User-Agent': 'ai-offline-app/1.0',
}
```

### Rate Limits (Free Tier)

- **Requests:** 3 per minute
- **Tokens:** 90,000 per day
- **Images:** $5 free credit

### Models Available

```dart
// Chat
'gpt-4-turbo'
'gpt-4'
'gpt-3.5-turbo'

// Images
'dall-e-3'
'dall-e-2'

// Vision
'gpt-4-vision-preview'
'gpt-4-turbo-with-vision'
```

---

## Next Steps

1. ✅ Set up API key
2. ✅ Run application
3. ✅ Test chat feature
4. ✅ Generate test images
5. ✅ Monitor API usage
6. ✅ Optimize based on costs
7. ✅ Deploy to production

---

**For more information, visit [OpenAI Documentation](https://platform.openai.com/docs)**
