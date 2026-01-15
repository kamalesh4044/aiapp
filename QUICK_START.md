# ⚡ Quick Reference Guide

## 🚀 Getting Started (5 Minutes)

### 1. Get API Key
```
Visit: https://platform.openai.com/account/api-keys
Create new key → Copy it
```

### 2. Configure App
```dart
// Option 1: In Settings UI
Open app → Settings tab → Paste key → Save → Test

// Option 2: In Code (lib/core/config/api_config.dart)
static const String openaiApiKey = 'sk-your-key-here';
```

### 3. Run App
```bash
flutter run
```

---

## 💬 Chat API

### Send Message
```dart
final response = await getIt<OpenAIChatService>().sendMessage(
  'Your question here',
  conversationHistory: previousMessages,
);
print(response.content);  // AI response
```

### Models
- `gpt-4-turbo` - Best quality (default)
- `gpt-3.5-turbo` - Fast & cheap

### Settings
```dart
// Customize in api_config.dart
gptMaxTokens: 2000,        // Response length
gptTemperature: 0.7,       // 0=precise, 2=creative
gptModel: 'gpt-4-turbo',   // Which model
```

---

## 🎨 Image API

### Generate Single Image
```dart
final url = await getIt<OpenAIImageService>().generateImage(
  'A beautiful sunset',
  size: '1024x1024',
  quality: 'hd',
);
// Use Image.network(url) to display
```

### Generate Multiple
```dart
final urls = await getIt<OpenAIImageService>().generateImages(
  'Futuristic city',
  numberOfImages: 4,
);
```

### Sizes
- `256x256` - Small, fast, cheap
- `512x512` - Medium
- `1024x1024` - Large, detailed

### Quality
- `standard` - Good, faster ($0.04)
- `hd` - Excellent, slower ($0.08)

---

## 👁️ Vision API

### Analyze Image
```dart
final description = await getIt<OpenAIVisionService>().analyzeImage(
  'https://example.com/image.jpg',
  prompt: 'Describe this image',
);
```

---

## 🏗️ File Locations

### Core Services
- Chat, Image, Vision: `lib/data/services/openai_service.dart`
- HTTP Client: `lib/core/network/http_client.dart`
- Config: `lib/core/config/api_config.dart`

### UI Screens
- Chat: `lib/features/chat/presentation/pages/chat_screen_online.dart`
- Images: `lib/features/image_generation/presentation/pages/image_generation_screen_online.dart`
- Settings: `lib/features/settings/presentation/pages/settings_screen_online.dart`

### Main App
- Entry: `lib/main.dart`
- Navigation: `lib/navigation/bottom_nav.dart`
- Injection: `lib/injection/service_locator.dart`

---

## 📊 Usage Costs

### Chat
```
GPT-4 Turbo:
  Input:  $0.01/1K tokens
  Output: $0.03/1K tokens

GPT-3.5 Turbo (cheaper):
  Input:  $0.0005/1K tokens
  Output: $0.0015/1K tokens
```

### Images
```
DALL-E 3:
  1024x1024 Standard: $0.040
  1024x1024 HD:       $0.080
```

**Check usage:** https://platform.openai.com/account/usage/overview

---

## 🔧 Common Customizations

### Use Cheaper Model
```dart
// In api_config.dart
static const String gptModel = 'gpt-3.5-turbo';
```

### Faster Responses
```dart
static const int gptMaxTokens = 500;        // Limit response size
static const double gptTemperature = 0.3;   // More predictable
```

### Update API Key at Runtime
```dart
getIt<HttpClient>().setApiKey(newKey);
```

### Enable Debug Logs
```dart
// In api_config.dart
static const bool enableDebugLogs = true;
```

---

## 🐛 Quick Fixes

### "Invalid API Key"
- Check format: must start with `sk-`
- Visit: https://platform.openai.com/account/api-keys
- Copy full key (no spaces)

### "Rate Limit Exceeded"
- Wait a minute before trying again
- Upgrade OpenAI account tier
- Or upgrade billing plan

### "Connection Timeout"
- Increase timeout in api_config.dart
- Check internet connection
- Verify OpenAI API is up: https://status.openai.com

### "Empty Response"
- Check prompt quality
- Verify model exists
- Check parameters

---

## 📱 App Navigation

```
Bottom Tabs:
├─ Chat 💬       (Talk to AI)
├─ Generate 🎨   (Create images)
└─ Settings ⚙️   (Configure)
```

---

## 🎯 Typical Usage Flow

### Chat Flow
1. User types message in chat input
2. App shows loading state
3. Sends request to OpenAI
4. Displays AI response
5. Shows in conversation history

### Image Generation Flow
1. User enters prompt
2. Selects size & quality
3. Clicks Generate
4. Shows loading spinner
5. Displays generated images
6. Can download/share (coming soon)

---

## 📚 Full Documentation

- **Setup:** [ONLINE_AI_SETUP.md](ONLINE_AI_SETUP.md)
- **Overview:** [README_ONLINE_AI.md](README_ONLINE_AI.md)
- **API Details:** [API_INTEGRATION.md](API_INTEGRATION.md)
- **Summary:** [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)

---

## ⚙️ Configuration Presets

### Development (Speed)
```dart
gptModel: 'gpt-3.5-turbo'
gptMaxTokens: 500
dalleQuality: 'standard'
enableDebugLogs: true
```

### Production (Quality)
```dart
gptModel: 'gpt-4-turbo'
gptMaxTokens: 2000
dalleQuality: 'hd'
enableDebugLogs: false
```

### Budget (Cost)
```dart
gptModel: 'gpt-3.5-turbo'
gptMaxTokens: 256
dalleSize: '512x512'
dalleQuality: 'standard'
```

---

## 🔗 Important Links

- **API Keys:** https://platform.openai.com/account/api-keys
- **Usage Dashboard:** https://platform.openai.com/account/usage/overview
- **API Docs:** https://platform.openai.com/docs
- **Status:** https://status.openai.com
- **Pricing:** https://openai.com/pricing

---

## 📝 Common Code Snippets

### Get Any Service
```dart
final chatService = getIt<OpenAIChatService>();
final imageService = getIt<OpenAIImageService>();
final visionService = getIt<OpenAIVisionService>();
```

### Error Handling
```dart
try {
  final response = await chatService.sendMessage('Hello');
} catch (e) {
  print('Error: $e');
  // Show error to user
}
```

### Create Message Object
```dart
import 'data/services/openai_service.dart';
import 'package:uuid/uuid.dart';

final message = ChatMessage(
  id: const Uuid().v4(),
  role: 'user',
  content: 'Hello',
  timestamp: DateTime.now(),
);
```

---

## ✅ Checklist

- [ ] Get OpenAI API key
- [ ] Paste key in Settings
- [ ] Click "Test Key"
- [ ] See success message
- [ ] Try chat
- [ ] Generate an image
- [ ] Check API usage dashboard
- [ ] Monitor costs

---

## 🆘 Need Help?

1. **Check error message** - Usually tells you what's wrong
2. **Review docs** - See ONLINE_AI_SETUP.md
3. **Test API key** - Use Settings tab "Test Key" button
4. **Enable debug logs** - Set `enableDebugLogs = true`
5. **Check OpenAI status** - https://status.openai.com

---

**You're all set! Happy coding! 🎉**

*For detailed info, see [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)*
