# Tailinq App

Pet Tracker Flutter application - Track your pets in real-time with GPS devices.

## Features

- **Real-time Location Tracking**: Live GPS tracking with Google Maps
- **Pet Management**: Multiple pets with profiles (name, species, breed, photo)
- **Geofencing**: Draw safe zones on the map, assign to pets, get alerts when they leave
- **Activity Dashboard**: Health metrics (activity, rest, eating, drinking) with sparkline charts
- **Route History**: View past movements with speed-based color coding
- **Location Simulation**: Test/demo mode with realistic movement patterns
- **Authentication**: AWS Cognito (email/password)

## Screenshots

| Home Map | Geofence Draw | Activity |
|----------|---------------|----------|
| Live tracking with custom pet markers | Draw safe zones with radius slider | Health metrics dashboard |

## Getting Started

### Prerequisites

- Flutter SDK 3.10+
- Dart SDK 3.10+
- Google Maps API Key
- AWS Cognito User Pool (for authentication)

### Setup

1. Clone the repository
```bash
git clone https://github.com/uchaan/tailinq-app.git
cd tailinq-app
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure API Keys

Copy the example files and add your API keys:

```bash
# Amplify (Cognito)
cp lib/amplifyconfiguration.dart.example lib/amplifyconfiguration.dart
# Edit with your Cognito Pool ID and App Client ID

# Android
cp android/app/src/main/AndroidManifest.xml.example android/app/src/main/AndroidManifest.xml
# Edit with your Google Maps API Key

# iOS
cp ios/Runner/AppDelegate.swift.example ios/Runner/AppDelegate.swift
# Edit with your Google Maps API Key
```

4. Generate Freezed code
```bash
dart run build_runner build --delete-conflicting-outputs
```

5. Run the app
```bash
flutter run
```

## Architecture

Clean Architecture with Riverpod for state management.

```
lib/
├── core/           # Theme, constants, errors
├── data/           # Models (Freezed), repositories, services
├── domain/         # Repository interfaces
└── presentation/   # Screens, widgets, providers, router
```

### Key Technologies

- **State Management**: Riverpod
- **Routing**: GoRouter with ShellRoute
- **Models**: Freezed + json_serializable
- **Maps**: google_maps_flutter
- **Auth**: AWS Amplify (Cognito)

## Documentation

- [TODO.md](docs/TODO.md) - Development roadmap and progress
- [CLAUDE.md](CLAUDE.md) - AI assistant guidance

## License

This project is private and not licensed for public use.
