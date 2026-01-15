# 🚀 AI Online Assistant - Complete Setup & Implementation

A production-ready Flutter application featuring **real-time AI conversations** and **image generation** powered by **OpenAI APIs**.

## ✨ Features

### 1. 💬 **Smart Chat with GPT-4 Turbo**
- Real-time conversations with advanced AI
- Full conversation history context
- Error handling and retry logic
- Typing indicators
- Message persistence

### 2. 🎨 **AI Image Generation (DALL-E 3)**
- Generate professional images from text
- Multiple image generation (1-4 images)
- Customizable sizes (256x256, 512x512, 1024x1024)
- Quality options (Standard/HD)
- Image preview and download

### 3. 👁️ **Image Analysis (GPT-4 Vision)**
- Analyze images using AI
- Get detailed descriptions
- Answer questions about images
- Extract text from images

### 4. ⚙️ **Configuration Dashboard**
- Easy API key setup
- API key validation testing
- Model configuration
- Network settings

---

## 🔧 Quick Start

### Prerequisites
- Flutter 3.0+
- Dart 3.0+
- OpenAI API Key (free $5 credit available)

### Step 1: Get OpenAI API Key

1. Visit [OpenAI Platform](https://platform.openai.com/account/api-keys)
2. Sign in or create account
3. Create new secret key
4. **Copy and save safely** (you won't see it again!)

### Step 2: Configure in App

Edit `lib/core/config/api_config.dart`:

```dart
class ApiConfig {
  static const String openaiApiKey = 'sk-your-actual-key-here';
  // ... rest of config
}
```

### Step 3: Install Dependencies

```bash
flutter pub get
```

### Step 4: Run App

```bash
flutter run
```

### Step 5: Configure API Key in App

1. Open Settings tab
2. Paste your OpenAI API key
3. Click "Save Key"
4. Click "Test Key" to verify

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart              # API configuration & settings
│   ├── network/
│   │   └── http_client.dart             # HTTP client with interceptors
│   └── themes/
│       └── app_theme.dart               # UI theming
├── data/
│   └── services/
│       └── openai_service.dart          # OpenAI API implementations
├── features/
│   ├── chat/
│   │   └── presentation/pages/
│   │       └── chat_screen_online.dart  # Chat UI
│   ├── image_generation/
│   │   └── presentation/pages/
│   │       └── image_generation_screen_online.dart  # Image generation UI
│   └── settings/
│       └── presentation/pages/
│           └── settings_screen_online.dart  # Settings & configuration
├── injection/
│   └── service_locator.dart             # Dependency injection setup
├── navigation/
│   └── bottom_nav.dart                  # Navigation bar
└── main.dart                            # App entry point
```

---

## 🔌 API Integration Guide

### Using Chat Service

```dart
import 'injection/service_locator.dart';
import 'data/services/openai_service.dart';

// Get service
final chatService = getIt<OpenAIChatService>();

// Send message
final response = await chatService.sendMessage(
  'What is Flutter?',
  conversationHistory: previousMessages,
);

print(response.content);  // AI response
print(response.outputTokens);  // Tokens used
```

### Using Image Service

```dart
final imageService = getIt<OpenAIImageService>();

// Generate single image
final imageUrl = await imageService.generateImage(
  'A serene mountain landscape at sunrise',
  size: '1024x1024',
  quality: 'hd',
);

// Generate multiple
final images = await imageService.generateImages(
  'Futuristic city',
  numberOfImages: 4,
  quality: 'standard',
);
```

### Using Vision Service

```dart
final visionService = getIt<OpenAIVisionService>();

final analysis = await visionService.analyzeImage(
  'https://example.com/image.jpg',
  prompt: 'What objects are in this image?',
);

print(analysis);  // AI description
```

---

## 📊 Configuration Options

### Chat Settings

```dart
// In api_config.dart
static const String gptModel = 'gpt-4-turbo';  // or 'gpt-3.5-turbo'
static const int gptMaxTokens = 2000;
static const double gptTemperature = 0.7;  // 0=precise, 2=creative
```

### Image Settings

```dart
static const String dalleModel = 'dall-e-3';
static const String dalleSize = '1024x1024';
static const String dalleQuality = 'standard';  // or 'hd'
static const int dalleImagesPerRequest = 1;
```

### Network Settings

```dart
static const int connectTimeout = 30;  // seconds
static const int receiveTimeout = 60;  // seconds
static const int sendTimeout = 60;     // seconds
static const int maxRetries = 3;
```

---

## 💡 Code Examples

### Example 1: Chat in Custom Widget

```dart
class ChatWidget extends StatefulWidget {
  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final chatService = getIt<OpenAIChatService>();
  final messages = <ChatMessage>[];

  Future<void> sendMessage(String text) async {
    try {
      final response = await chatService.sendMessage(
        text,
        conversationHistory: messages,
      );
      
      setState(() {
        messages.add(ChatMessage(
          id: Uuid().v4(),
          role: 'assistant',
          content: response.content,
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Chat implementation'),
    );
  }
}
```

### Example 2: Batch Image Generation

```dart
Future<void> generateImageBatch(List<String> prompts) async {
  final imageService = getIt<OpenAIImageService>();
  final results = <String>[];

  for (final prompt in prompts) {
    try {
      final url = await imageService.generateImage(prompt);
      results.add(url);
    } catch (e) {
      print('Error generating image for "$prompt": $e');
    }
  }

  return results;
}
```

### Example 3: Image Analysis for Gallery

```dart
Future<Map<String, String>> analyzeGallery(List<String> imageUrls) async {
  final visionService = getIt<OpenAIVisionService>();
  final analyses = <String, String>{};

  for (final url in imageUrls) {
    final analysis = await visionService.analyzeImage(
      url,
      prompt: 'Describe what you see in this image',
    );
    analyses[url] = analysis;
  }

  return analyses;
}
```

---

## 🛡️ Error Handling

The app includes comprehensive error handling:

```dart
try {
  final response = await chatService.sendMessage('Hello');
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    print('Invalid API key');
  } else if (e.response?.statusCode == 429) {
    print('Rate limit exceeded');
  } else if (e.type == DioExceptionType.connectionTimeout) {
    print('Connection timeout');
  } else {
    print('Error: ${e.message}');
  }
} catch (e) {
  print('Unexpected error: $e');
}
```

---

## 🚨 Troubleshooting

| Issue | Solution |
|-------|----------|
| API key not working | Verify at https://platform.openai.com/account/api-keys |
| Rate limit exceeded | Upgrade OpenAI plan or wait before retrying |
| Network timeout | Increase timeout in api_config.dart or check internet |
| Empty response | Check model name and request parameters |
| Out of credits | Add billing info to OpenAI account |

---

## 📈 Monitoring Usage

### View API Usage

1. Go to [OpenAI Usage Dashboard](https://platform.openai.com/account/usage/overview)
2. Check daily/monthly usage
3. Monitor costs

### Enable Debug Logs

```dart
// In api_config.dart
static const bool enableDebugLogs = true;
```

This will print all requests and responses to console.

---

## 💰 Pricing

### Chat (GPT-4 Turbo)
```
Input:  $0.01 per 1K tokens
Output: $0.03 per 1K tokens
```

### Chat (GPT-3.5 Turbo) - Cheaper
```
Input:  $0.0005 per 1K tokens
Output: $0.0015 per 1K tokens
```

### Images (DALL-E 3)
```
1024x1024 Standard: $0.040 per image
1024x1024 HD:       $0.080 per image
512x512:            $0.018 per image
256x256:            $0.010 per image
```

---

## 🔐 Security Best Practices

### ✅ DO:
- Use environment variables for API keys
- Validate user input before sending to API
- Implement rate limiting
- Cache responses when possible
- Use HTTPS only
- Rotate keys regularly

### ❌ DON'T:
- Commit API keys to git
- Display full API key to users
- Send user data without consent
- Skip error handling
- Use without authentication

---

## 🌟 Advanced Features

### Streaming Responses (Coming Soon)

```dart
Stream<String> getStreamResponse(String prompt) {
  return chatService.sendMessageStream(
    prompt,
    conversationHistory: messages,
  );
}
```

### Conversation Management

```dart
// Save conversations locally
Future<void> saveConversation(List<ChatMessage> messages) async {
  // Implementation
}

// Load previous conversation
Future<List<ChatMessage>> loadConversation(String id) async {
  // Implementation
}
```

### Custom Models

```dart
// Use cheaper GPT-3.5 for simple tasks
final response = await chatService.sendMessage(
  'Simple question',
  model: 'gpt-3.5-turbo',
);

// Use GPT-4 for complex tasks
final response = await chatService.sendMessage(
  'Complex analysis',
  model: 'gpt-4-turbo',
);
```

---

## 📚 Resources

- [OpenAI Documentation](https://platform.openai.com/docs)
- [Chat Completions API](https://platform.openai.com/docs/api-reference/chat)
- [Images API](https://platform.openai.com/docs/api-reference/images)
- [Vision API](https://platform.openai.com/docs/guides/vision)
- [Flutter Documentation](https://flutter.dev/docs)
- [Dio HTTP Client](https://pub.dev/packages/dio)

---

## 🤝 Support & Issues

### Common Issues:

1. **"Invalid API Key"**
   - Check key format starts with `sk-`
   - Verify key is active in OpenAI dashboard
   - Test with curl: `curl https://api.openai.com/v1/models -H "Authorization: Bearer YOUR_KEY"`

2. **"Rate Limit Exceeded"**
   - Implement request throttling
   - Use cheaper models (GPT-3.5)
   - Check billing limits

3. **"Network Timeout"**
   - Increase timeout values
   - Check internet connection
   - Verify OpenAI API is accessible

---

## 📝 License

This implementation is provided as-is for educational and commercial use.

---

## 🎉 Ready to Build Amazing AI Apps!

Start creating intelligent applications with:
- ✅ Real-time chat
- ✅ Image generation
- ✅ Image analysis
- ✅ Production-ready code
- ✅ Full error handling

**Happy coding! 🚀**
