# Online AI Assistant - Setup Guide

## Overview

This Flutter application now features a **fully online AI system** with both **ChatBot** and **Image Generation** capabilities powered by **OpenAI's latest APIs**:

- **GPT-4 Turbo** for intelligent conversations
- **DALL-E 3** for high-quality image generation
- **GPT-4 Vision** for image analysis (included)

## API Keys Setup

### Get Your OpenAI API Key

1. Go to [OpenAI Platform](https://platform.openai.com)
2. Sign in or create an account
3. Navigate to **API Keys** section
4. Click **Create new secret key**
5. Copy the key safely

### Configure API Key in App

#### Option 1: Direct Configuration (Development)

Edit [lib/core/config/api_config.dart](lib/core/config/api_config.dart):

```dart
static const String openaiApiKey = 'sk-your-api-key-here';
```

⚠️ **WARNING**: Never commit API keys to version control!

#### Option 2: Runtime Configuration (Recommended)

```dart
// In your settings or onboarding screen
import 'injection/service_locator.dart';

getIt<HttpClient>().setApiKey(userProvidedApiKey);
```

#### Option 3: Environment Variables (Best Practice)

Create `.env` file in project root:
```env
OPENAI_API_KEY=sk-your-api-key-here
```

Load in main.dart:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final apiKey = dotenv.env['OPENAI_API_KEY']!;
  getIt<HttpClient>().setApiKey(apiKey);
  
  runApp(const MyApp());
}
```

## Features

### 1. **Chat Screen** (Chat with GPT-4)

- Real-time conversation with GPT-4 Turbo
- Message history within conversation
- Automatic scrolling to latest message
- Error handling with user feedback
- Typing indicator while AI responds

**Location**: [lib/features/chat/presentation/pages/chat_screen_online.dart](lib/features/chat/presentation/pages/chat_screen_online.dart)

### 2. **Image Generation** (DALL-E 3)

- Generate images from text prompts
- Customize image size (256x256, 512x512, 1024x1024)
- Quality options (standard, HD)
- Generate 1-4 images per request
- Display generated images in grid
- Download/share functionality (coming soon)

**Location**: [lib/features/image_generation/presentation/pages/image_generation_screen_online.dart](lib/features/image_generation/presentation/pages/image_generation_screen_online.dart)

### 3. **Image Analysis** (GPT-4 Vision)

Analyze any image using AI:

```dart
import 'injection/service_locator.dart';

final analysis = await getIt<OpenAIVisionService>().analyzeImage(
  'https://example.com/image.jpg',
  prompt: 'What objects are in this image?'
);
```

## API Services

### OpenAIChatService

**Send a single message:**
```dart
final response = await chatService.sendMessage(
  'What is quantum computing?',
  conversationHistory: previousMessages,
);
print(response.content); // AI's response
```

**Key Methods:**
- `sendMessage()` - Send and get response
- `sendMessageStream()` - Stream response (for real-time output)

### OpenAIImageService

**Generate single image:**
```dart
final imageUrl = await imageService.generateImage(
  'A futuristic city at sunset',
  size: '1024x1024',
  quality: 'hd',
);
```

**Generate multiple images:**
```dart
final images = await imageService.generateImages(
  'Space exploration',
  numberOfImages: 4,
);
```

### OpenAIVisionService

**Analyze image:**
```dart
final description = await visionService.analyzeImage(
  'https://example.com/image.jpg',
  prompt: 'Describe this image in detail',
);
```

## Configuration Options

Edit [lib/core/config/api_config.dart](lib/core/config/api_config.dart):

```dart
// GPT Model Settings
static const String gptModel = 'gpt-4-turbo'; // or 'gpt-3.5-turbo'
static const int gptMaxTokens = 2000;
static const double gptTemperature = 0.7; // 0-2, higher = more creative

// DALL-E Settings
static const String dalleModel = 'dall-e-3';
static const String dalleSize = '1024x1024';
static const String dalleQuality = 'standard'; // or 'hd'
static const int dalleImagesPerRequest = 1;

// Network Timeouts
static const int connectTimeout = 30;
static const int receiveTimeout = 60;
```

## Error Handling

The app includes comprehensive error handling:

- Network failures with retry logic
- API quota exceeded errors
- Invalid API key detection
- User-friendly error messages

**Enable debug logs:**
```dart
// In api_config.dart
static const bool enableDebugLogs = true;
```

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart          # API configuration
│   └── network/
│       └── http_client.dart         # HTTP client with interceptors
├── data/
│   └── services/
│       └── openai_service.dart      # OpenAI API services
├── features/
│   ├── chat/
│   │   └── presentation/pages/
│   │       └── chat_screen_online.dart
│   ├── image_generation/
│   │   └── presentation/pages/
│   │       └── image_generation_screen_online.dart
│   └── settings/
│       └── presentation/pages/
│           └── settings_screen.dart
├── injection/
│   └── service_locator.dart         # Dependency injection
├── navigation/
│   └── bottom_nav.dart              # Bottom navigation
└── main.dart                        # App entry point
```

## Dependencies

```yaml
dio: ^5.3.0                          # HTTP client
http: ^1.1.0                         # Networking
uuid: ^4.0.0                         # Unique IDs
provider: ^6.0.0                     # State management
get_it: ^7.6.0                       # Service locator
google_fonts: ^6.1.0                 # Typography
```

## Usage Examples

### Example 1: Chat in a Widget

```dart
class MyChatWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatService = getIt<OpenAIChatService>();
    
    return ChatScreenOnline(chatService: chatService);
  }
}
```

### Example 2: Generate Images in Background

```dart
final imageService = getIt<OpenAIImageService>();

try {
  final imageUrl = await imageService.generateImage(
    'A beautiful sunset over the ocean',
  );
  // Use imageUrl to display or save
} catch (e) {
  print('Error: $e');
}
```

### Example 3: Custom Chat Integration

```dart
final chatService = getIt<OpenAIChatService>();

final response = await chatService.sendMessage(
  'Explain machine learning',
  conversationHistory: [
    ChatMessage(
      id: '1',
      role: 'user',
      content: 'What is AI?',
      timestamp: DateTime.now(),
    ),
    ChatMessage(
      id: '2',
      role: 'assistant',
      content: 'AI is Artificial Intelligence...',
      timestamp: DateTime.now(),
    ),
  ],
);

print(response.content);
print('Tokens used: ${response.outputTokens}');
```

## API Pricing

### Chat (GPT-4 Turbo)
- Input: $0.01 per 1K tokens
- Output: $0.03 per 1K tokens

### Images (DALL-E 3)
- Standard (1024x1024): $0.040 per image
- HD (1024x1024): $0.080 per image

**Monitor usage**: [OpenAI Usage Dashboard](https://platform.openai.com/account/usage/overview)

## Troubleshooting

### Issue: "Invalid API Key"
- Verify key in [api_config.dart](lib/core/config/api_config.dart)
- Check key is active in OpenAI dashboard
- Ensure no extra spaces in key

### Issue: "Rate limit exceeded"
- Implement request throttling
- Check pricing tier on OpenAI account
- Wait before retrying

### Issue: "Network timeout"
- Increase timeout in [api_config.dart](lib/core/config/api_config.dart)
- Check internet connection
- Verify OpenAI API is accessible

### Issue: "Empty API response"
- Check prompt quality
- Ensure model is available (`gpt-4-turbo`, `dall-e-3`)
- Review request parameters

## Best Practices

1. ✅ **Never hardcode API keys** - Use environment variables
2. ✅ **Implement request caching** - Reduce API calls
3. ✅ **Add rate limiting** - Prevent quota exhaustion
4. ✅ **Handle errors gracefully** - Show user-friendly messages
5. ✅ **Monitor token usage** - Track costs
6. ✅ **Use appropriate models** - GPT-3.5 is cheaper, GPT-4 is smarter
7. ✅ **Validate user input** - Prevent malicious prompts
8. ✅ **Implement conversation management** - Store chat history locally

## Next Steps

1. Get OpenAI API key
2. Add key to [api_config.dart](lib/core/config/api_config.dart)
3. Run: `flutter pub get`
4. Run: `flutter run`
5. Start chatting and generating images!

## Resources

- [OpenAI Documentation](https://platform.openai.com/docs)
- [GPT-4 API Reference](https://platform.openai.com/docs/api-reference/chat)
- [DALL-E 3 Guide](https://platform.openai.com/docs/guides/images)
- [GPT-4 Vision](https://platform.openai.com/docs/guides/vision)
- [API Pricing](https://openai.com/pricing)

## Support

For issues or questions:
1. Check OpenAI API status
2. Review error messages in debug logs
3. Verify API key and configuration
4. Check network connectivity
5. Review API documentation

---

**Ready to build powerful AI applications! 🚀**
