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

See **[docs/GETTING_STARTED.md](docs/GETTING_STARTED.md)** for the full setup guide.

**Quick start:**

```bash
git clone https://github.com/uchaan/tailinq-app.git
cd tailinq-app
flutter pub get

# Copy and configure API keys (see GETTING_STARTED.md for details)
cp lib/amplifyconfiguration.dart.example lib/amplifyconfiguration.dart
cp android/app/src/main/AndroidManifest.xml.example android/app/src/main/AndroidManifest.xml
cp ios/Runner/AppDelegate.swift.example ios/Runner/AppDelegate.swift

dart run build_runner build --delete-conflicting-outputs
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

- [GETTING_STARTED.md](docs/GETTING_STARTED.md) - Build & run guide for new users
- [SETUP.md](docs/SETUP.md) - External API setup guide (Google Maps, AWS Cognito)
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - Architecture & technical details
- [TESTING.md](docs/TESTING.md) - Testing guide & checklists
- [ROADMAP.md](docs/ROADMAP.md) - Development roadmap and progress
- [REQUIREMENTS.md](docs/REQUIREMENTS.md) - MVP requirements & specification
- [CLAUDE.md](CLAUDE.md) - AI assistant guidance

## License

This project is private and not licensed for public use.
