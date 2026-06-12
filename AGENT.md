# Project Overview: project1

This is a standard Flutter application project, initialized with the default counter application template. It is designed to run on multiple platforms including Android, iOS, Windows, and Web.

## Main Technologies
- **Language:** Dart (SDK ^3.9.2)
- **Framework:** Flutter
- **Design System:** Material Design (enabled via `uses-material-design: true` in `pubspec.yaml`)
- **Icons:** `cupertino_icons` for iOS-style icons.

## Architecture
- **Entry Point:** `lib/main.dart`
- **Root Widget:** `MyApp` (StatelessWidget), which sets up the `MaterialApp` and theme.
- **Home Page:** `MyHomePage` (StatefulWidget), which manages the counter state.
- **Platform Support:** 
  - `android/`: Android-specific configuration and code.
  - `ios/`: iOS-specific configuration and code.
  - `web/`: Web-specific assets and configuration.
  - `windows/`: Windows-specific runner and configuration.

## Building and Running

The following commands are standard for Flutter development:

- **Run the app:**
  ```bash
  flutter run
  ```
- **Run tests:**
  ```bash
  flutter test
  ```
- **Static Analysis:**
  ```bash
  flutter analyze
  ```
- **Get dependencies:**
  ```bash
  flutter pub get
  ```
- **Build for production:**
  ```bash
  flutter build apk   # For Android
  flutter build ios   # For iOS
  flutter build web   # For Web
  flutter build windows # For Windows
  ```

## Development Conventions

- **Linting:** The project uses `package:flutter_lints/flutter.yaml` as defined in `analysis_options.yaml`. Adhere to these rules to ensure code quality.
- **Formatting:** Use the standard Dart formatter.
  ```bash
  dart format .
  ```
- **Testing:**
  - Widget tests are located in the `test/` directory.
  - Follow the pattern established in `test/widget_test.dart` for UI testing.
- **State Management:** Currently uses basic `setState`. For larger features, consider established patterns like Provider, Riverpod, or Bloc if required.
- **Assets:** Add assets to the `assets/` directory (create if needed) and register them in `pubspec.yaml` under the `flutter: assets:` section.

## Key Files
- `pubspec.yaml`: Project metadata, dependencies, and Flutter-specific configuration.
- `lib/main.dart`: The main application code.
- `analysis_options.yaml`: Static analysis rules and lint configurations.
- `test/widget_test.dart`: Example smoke test for the counter functionality.
