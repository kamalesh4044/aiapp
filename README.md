# AI Offline - Mobile AI Assistant App

A lightweight, offline-first Flutter app featuring AI chatbot and image generation capabilities optimized for Android and iOS.

## Features

- 🤖 **AI Chatbot** - Offline conversational AI using TensorFlow Lite
- 🎨 **Image Generation** - Generate images from text prompts offline
- 📸 **Image Upload** - Process and analyze uploaded images
- 📚 **History** - Keep track of all conversations and generated content
- ⚙️ **Settings** - Customize app behavior and model quality
- 🔋 **Offline First** - Works completely without internet connection
- 📱 **Lightweight** - Optimized for mobile devices with limited resources

## Project Structure

```
lib/
├── core/                 # Core functionality (themes, constants, utilities)
├── data/                 # Data layer (models, repositories)
├── domain/               # Business logic (entities, usecases)
├── features/             # Feature modules (chat, image generation, etc)
├── ml/                   # Machine learning models and inference
├── navigation/           # App routing and navigation
└── injection/            # Dependency injection setup
```

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android SDK (for Android development)
- Xcode (for iOS development)

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd ai_offline_app
```

2. Get dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Building

#### Android APK
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### Android App Bundle
```bash
flutter build appbundle --release
```

## Dependencies

- **State Management**: Provider, Riverpod
- **Local Storage**: Hive, SharedPreferences, SQLite
- **ML**: TensorFlow Lite Flutter
- **Image Processing**: image, image_picker
- **UI**: Flutter Material Design 3
- **Others**: GetIt (DI), UUID, Intl

## Architecture

The app follows Clean Architecture principles:

- **Presentation Layer**: UI screens and widgets
- **Domain Layer**: Business logic and entities
- **Data Layer**: Repositories and data sources
- **ML Layer**: Model handlers and inference

## Performance Optimization

- Models are quantized to reduce size
- Images are compressed before processing
- Lazy loading for history and assets
- Efficient memory management for ML inference
- Optimized Gradle configuration for Android

## Configuration

Edit `assets/config/model_config.json` to:
- Configure model paths
- Set quality levels
- Enable/disable features
- Adjust API levels for Android

## Contributing

1. Follow the project structure
2. Maintain clean code standards
3. Add tests for new features
4. Update documentation

## License

MIT License - see LICENSE file

## Support

For issues and feature requests, please open an issue on the repository.

---

Built with ❤️ for offline AI experiences


---
<div align="center">
  <img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fkamalesh4044%2Faiapp&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=views&edge_flat=false" alt="Views"/>
</div>

