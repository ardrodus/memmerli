# Memmerli

Memmerli is a Flutter application designed to help users remember loved ones who have passed away. The app allows users to create and manage memories with photos, videos, and descriptions.

## Features

- User authentication (mock implementation for now)
- Memory listing with card UI
- Memory creation and editing
- Support for adding photos and videos to memories
- Cross-platform (Android, iOS, and web)

## Getting Started

### Prerequisites

- Flutter SDK (2.17.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / VS Code with Flutter plugins

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Replace placeholder assets:
   - Replace `assets/images/pattern.png.txt` with an actual pattern.png image for the login screen
   - Add sample images/videos to the assets folders if needed

### Running the App

Run the app in debug mode:
```
flutter run
```

For a specific platform:
```
flutter run -d chrome  # For web
flutter run -d android  # For Android
flutter run -d ios  # For iOS
```

## App Structure

- `lib/main.dart` - Entry point of the application
- `lib/screens/` - Screen/page widgets
- `lib/widgets/` - Reusable UI components
- `lib/models/` - Data models
- `lib/services/` - Business logic and data handling
- `lib/theme/` - App theme and styling

## Mock Authentication

For testing, use the following credentials:
- Username: Test
- Password: Test

## License

This project is for demonstration purposes only.

## Acknowledgments

- Design inspiration: [Add credits/inspirations here]