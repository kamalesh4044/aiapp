# Quick Start Guide - AI Offline App

## 🚀 Getting Started in 5 Minutes

### Prerequisites
- Flutter SDK 3.0+
- Android Studio / Xcode
- Git

### Step 1: Setup & Installation

```bash
# Navigate to project
cd ai_offline_app

# Get dependencies
flutter pub get

# Generate code (Hive models, etc.)
flutter pub run build_runner build
```

### Step 2: Run the App

**Android:**
```bash
flutter run -d emulator
# or on physical device
flutter run
```

**iOS:**
```bash
flutter run -d iphone
```

### Step 3: Explore Features

Once running, navigate through:
- 💬 **Chat Tab** - Talk to offline AI
- 🎨 **Generate Tab** - Create images from text
- 📸 **Upload Tab** - Upload and process images
- 📚 **History Tab** - View past interactions
- ⚙️ **Settings Tab** - Configure app

## 📁 Project Structure at a Glance

```
ai_offline_app/
├── lib/                    # Main application code
│   ├── core/              # Constants, themes, utilities, widgets
│   ├── data/              # Models, repositories, local storage
│   ├── domain/            # Entities, usecases
│   ├── features/          # Feature modules (chat, image, etc)
│   ├── ml/                # ML model handling
│   ├── navigation/        # Routes and navigation
│   ├── injection/         # Dependency injection
│   └── main.dart          # App entry point
├── assets/                # Images, models, configs
├── test/                  # Unit, widget, integration tests
├── android/               # Android configuration
├── ios/                   # iOS configuration
├── pubspec.yaml           # Dependencies
└── README.md              # Documentation
```

## 🎯 Key Concepts

### Clean Architecture
- **Presentation**: UI (screens, widgets)
- **Domain**: Business logic (entities, usecases)
- **Data**: Data sources (repositories, models)
- **ML**: Model inference and processing

### State Management
- StatefulWidget for simple screens
- GetIt for dependency injection
- Provider-ready architecture

### Data Storage
- **Hive**: Fast NoSQL database (chat, images)
- **SharedPreferences**: App settings
- **Local Files**: Image storage

## 🛠️ Common Tasks

### Add a New Screen

1. Create in `lib/features/new_feature/presentation/pages/`
2. Create widgets in `lib/features/new_feature/presentation/widgets/`
3. Add navigation in `lib/navigation/bottom_nav.dart`
4. Update `lib/main.dart` screens list

### Add a Model

1. Create in `lib/data/models/`
2. Add Hive annotations for persistence
3. Run: `flutter pub run build_runner build`

### Add a Repository

1. Create in `lib/data/repositories/`
2. Implement abstract class
3. Register in `lib/injection/service_locator.dart`

### Create a Use Case

1. Create in `lib/domain/usecases/`
2. Inject repository in constructor
3. Implement call() method
4. Register in service locator

## 🐛 Troubleshooting

**Build fails?**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build
```

**Models not generating?**
```bash
flutter pub run build_runner build --verbose
```

**Device not found?**
```bash
flutter devices
# or
flutter emulators --launch Pixel_4
```

## 📦 Building for Production

### Android APK
```bash
flutter build apk --release --split-per-abi
# Output: build/app/outputs/flutter-apk/
```

### Android App Bundle (Play Store)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/
```

### iOS
```bash
flutter build ios --release
```

## 🔑 Important Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point & navigation |
| `lib/core/themes/app_theme.dart` | UI theming |
| `lib/core/constants/` | App configuration |
| `pubspec.yaml` | Dependencies & assets |
| `analysis_options.yaml` | Linting rules |
| `assets/config/model_config.json` | ML model config |

## 📱 Features Breakdown

### Chat Module
- File: `lib/features/chat/`
- Offline text-to-text AI
- Uses TFLite chat model
- Stores history in Hive

### Image Generation
- File: `lib/features/image_generation/`
- Text-to-image generation
- Style selection (Realistic, Artistic, etc.)
- Offline processing

### Image Upload
- File: `lib/features/image_upload/`
- Camera & gallery picker
- Image compression
- Optional descriptions

### History
- File: `lib/features/history/`
- Browse past conversations
- Manage storage
- Delete items

### Settings
- File: `lib/features/settings/`
- Theme toggle
- Model quality
- Offline mode
- Notifications

## 🚀 Next Steps

1. **Integrate Real Models**
   - Add `.tflite` files to `assets/models/`
   - Update model handlers in `lib/ml/models/`

2. **Implement Database**
   - Set up Hive in `lib/data/local/database/`
   - Create DAOs for chat/images

3. **Add Tests**
   - Create tests in `test/`
   - Run: `flutter test`

4. **Deploy**
   - Configure signing certificates
   - Build APK/Bundle
   - Upload to Play Store/App Store

## 📚 Resources

- [Flutter Docs](https://flutter.dev/docs)
- [Architecture Guide](./ARCHITECTURE.md)
- [FULL README](./README.md)
- [Dart Guide](https://dart.dev/guides)

## 💡 Tips & Best Practices

✅ Use proper error handling  
✅ Keep screens simple and focused  
✅ Extract reusable widgets to `core/widgets/`  
✅ Use constants from `core/constants/`  
✅ Follow naming conventions  
✅ Run linter: `flutter analyze`  
✅ Format code: `dart format lib/`  

## 🎓 Learning Path

1. ✓ Understand the folder structure
2. ✓ Explore the main.dart file
3. ✓ Check out a feature module
4. ✓ Review the data layer
5. ✓ Look at ML model handlers
6. ✓ Read ARCHITECTURE.md for deep dive

---

**Happy coding! 🎉**

For detailed documentation, see [ARCHITECTURE.md](./ARCHITECTURE.md)
