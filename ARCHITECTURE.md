# AI Offline App - Developer Guide

## Overview

AI Offline is a sophisticated Flutter application designed for offline AI capabilities including chatbot and image generation. The app is optimized for Android and iOS with a focus on performance, lightweight deployment, and clean architecture.

## Architecture Overview

### Clean Architecture Layers

```
Presentation Layer
├── Pages (Screens)
└── Widgets

Domain Layer
├── Entities
└── Use Cases

Data Layer
├── Repositories
├── Models
└── Local Storage

ML Layer
├── Model Handlers
├── Inference
└── Utilities
```

## Project Structure Deep Dive

### Core Module (`lib/core/`)

**Constants**
- `app_constants.dart` - Application-wide constants
- `model_constants.dart` - ML model configurations
- `theme_constants.dart` - UI theme values

**Themes**
- `app_theme.dart` - Light/Dark theme definitions with Material 3

**Utils**
- `file_utils.dart` - File I/O operations
- `image_utils.dart` - Image processing and compression
- `model_utils.dart` - ML model utility functions
- `storage_utils.dart` - SharedPreferences wrapper

**Widgets**
- `custom_app_bar.dart` - Reusable app bar component
- `loading_indicator.dart` - Loading animations
- `error_widget.dart` - Error display component
- `custom_text_field.dart` - Custom text input field

### Data Layer (`lib/data/`)

**Models**
- `chat_model.dart` - Chat message data model with Hive annotations
- `image_model.dart` - Generated and uploaded image models
- `settings_model.dart` - App settings data model

**Repositories**
- `chat_repository.dart` - Chat data abstraction
- `image_repository.dart` - Image data abstraction
- `settings_repository.dart` - Settings data abstraction

**Local Storage**
- `database/` - Hive database setup (coming soon)
- `preferences/` - SharedPreferences management

### Domain Layer (`lib/domain/`)

**Entities**
- `chat_entity.dart` - Business entity for chat
- `image_entity.dart` - Business entity for images

**Use Cases**
- `chat_usecases.dart` - Chat operations (send, history, clear, delete)
- `image_generation_usecases.dart` - Image operations (generate, upload, delete)

### Features (`lib/features/`)

Each feature module follows this structure:

```
feature_name/
├── presentation/
│   ├── pages/
│   │   └── *_screen.dart
│   └── widgets/
│       └── custom_widgets.dart
└── providers/
    └── *_provider.dart
```

**Implemented Features**
1. **Chat** - Real-time AI conversation interface
2. **Image Generation** - Text-to-image generation with style selection
3. **Image Upload** - Image capture and processing
4. **History** - Browse past conversations and generated content
5. **Settings** - App configuration and preferences

### ML Module (`lib/ml/`)

**Models**
- `chat_model_handler.dart` - Chat model initialization and inference
- `image_model_handler.dart` - Image generation model handler
- `model_downloader.dart` - Model download and cache management

**Inference**
- Handles TensorFlow Lite model execution
- Processes input and output tensors

**Utils**
- Tensor manipulation
- Model quantization helpers
- Image preprocessing

### Navigation (`lib/navigation/`)

- `app_router.dart` - Route definitions
- `bottom_nav.dart` - Bottom navigation bar component

### Injection (`lib/injection/`)

- `service_locator.dart` - GetIt dependency injection setup

## Key Features Explained

### Offline AI Capabilities

The app uses TensorFlow Lite models that are bundled with the app, allowing complete functionality without internet:

1. **Chat Model** - Quantized language model for conversational AI
2. **Image Gen Model** - Generative model for image creation

### Performance Optimizations

1. **Model Quantization** - Reduced precision (INT8) for faster inference
2. **Image Compression** - Automatic compression of uploaded images
3. **Lazy Loading** - Load features on demand
4. **Memory Management** - Efficient tensor handling

### Data Persistence

- **Hive** - NoSQL database for chat history and images
- **SharedPreferences** - Simple key-value storage for settings
- **Local File System** - Image file storage

## State Management

The app uses multiple state management approaches:

1. **StatefulWidget** - For simple screen state
2. **Provider** - For complex business logic (can be integrated)
3. **GetIt** - Service locator for dependency injection

## UI/UX

- **Material Design 3** - Modern UI components
- **Responsive Design** - Adapts to different screen sizes
- **Dark Mode Support** - Full dark theme implementation
- **Custom Themes** - Easy theme customization

## Building and Deployment

### Android Optimization

**Gradle Configuration** (`android/app/build.gradle`)
- API 21+ support for wide compatibility
- ProGuard/R8 minification
- Split APKs by architecture (arm64-v8a, armeabi-v7a)

**Build Commands**
```bash
# Debug
flutter run

# Release APK
flutter build apk --release --split-per-abi

# App Bundle (Play Store)
flutter build appbundle --release
```

### iOS Optimization

**Deployment Target**: iOS 11.0+
**Build Commands**
```bash
flutter build ios --release
```

## Configuration

### Model Config (`assets/config/model_config.json`)

```json
{
  "models": [
    {
      "name": "chat_model",
      "quantized": true,
      "size_mb": 50
    }
  ]
}
```

### App Constants (`lib/core/constants/app_constants.dart`)

Adjust cache duration, file size limits, timeouts, and other parameters.

## Development Workflow

### Adding a New Feature

1. Create feature folder structure in `lib/features/`
2. Create presentation layer (pages, widgets)
3. Create domain layer (entities, usecases)
4. Create data layer (models, repository)
5. Register providers/state management
6. Add navigation route
7. Add tests

### Code Generation

Generate Hive models:
```bash
flutter pub run build_runner build
```

## Testing

### Test Structure
```
test/
├── unit_test/
├── widget_test/
└── integration_test/
```

### Running Tests
```bash
flutter test
```

## Performance Metrics

Target metrics for release build:
- **App Size**: < 100MB (with models)
- **Startup Time**: < 2 seconds
- **Chat Response**: < 1 second (offline)
- **Image Generation**: < 3 seconds (offline)
- **Memory Usage**: < 200MB during inference

## Troubleshooting

### Common Issues

**Models not loading**
- Check `assets/models/` contains model files
- Verify `pubspec.yaml` has assets configured

**App crashes on startup**
- Run `flutter clean && flutter pub get`
- Check Android API level compatibility

**Image processing slow**
- Reduce image resolution
- Lower quality settings in settings screen

## Future Enhancements

- [ ] Real TFLite model integration
- [ ] Advanced image filtering
- [ ] Multi-language support
- [ ] Cloud sync option
- [ ] Voice input/output
- [ ] Offline map support

## Contributing Guidelines

1. Follow Dart/Flutter best practices
2. Maintain folder structure consistency
3. Write tests for new features
4. Update documentation
5. Use meaningful commit messages

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Clean Architecture](https://resocoder.com/flutter-clean-architecture)
- [TensorFlow Lite Flutter](https://www.tensorflow.org/lite/guide/flutter)
- [Material Design 3](https://m3.material.io/)

## Support

For issues or questions:
1. Check existing issues
2. Create detailed bug reports
3. Include logs and reproduction steps

---

Happy coding! 🚀
