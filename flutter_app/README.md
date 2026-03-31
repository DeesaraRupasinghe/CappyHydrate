# CappyHydrate Flutter App

A simple water reminder app with a capybara theme, built with Flutter.

## ✨ Features

| Screen | Description |
|---|---|
| **Splash** | Fade-in animation with bouncing capybara, navigates to Home after 3 s |
| **Home** | Shows daily bottle progress, "I Drank Water!" button, next reminder time |
| **Setup** | Choose 1–8 daily bottles, set bedtime & wake-up time, saves to device |
| **Progress** | Today's progress bar, weekly bar chart, motivational message |
| **Reminder** | Full-screen notification UI with capybara image and action buttons |

## 📦 Packages

| Package | Purpose |
|---|---|
| `provider` | Lightweight state management |
| `shared_preferences` | Persist settings and daily count locally |
| `flutter_local_notifications` | Schedule water reminder notifications |

## 🚀 How to run

### Prerequisites

- [Flutter SDK ≥ 3.10](https://docs.flutter.dev/get-started/install) installed
- Android Studio or a physical Android device connected via USB

### Steps

```bash
# 1. Enter the Flutter project directory
cd flutter_app

# 2. Fetch dependencies
flutter pub get

# 3. Run on an Android device or emulator
flutter run
```

### Build a release APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

## 🗂 Project structure

```
flutter_app/
├── android/                   # Android-specific configuration
├── lib/
│   ├── main.dart              # Entry point
│   ├── models/
│   │   └── water_settings.dart
│   ├── services/
│   │   ├── app_state.dart          # ChangeNotifier — shared app state
│   │   ├── notification_service.dart
│   │   └── preferences_service.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── home_screen.dart
│   │   ├── setup_screen.dart
│   │   ├── progress_screen.dart
│   │   └── reminder_screen.dart
│   └── widgets/
│       ├── app_colors.dart
│       ├── gradient_background.dart
│       ├── primary_button.dart
│       └── water_progress_card.dart
└── pubspec.yaml
```

## 🎨 Design notes

- Colours are taken directly from the original React/Tailwind design:
  - Background gradient `#f5ebe0 → #e3d5ca → #d6ccc2`
  - Primary orange `#bc6c25`
  - Teal water `#a8dadc`
  - Blue `#457b9d`
- All Tailwind classes have been translated to Flutter `BoxDecoration`,
  `LinearGradient`, `BorderRadius`, and `BoxShadow` equivalents.
