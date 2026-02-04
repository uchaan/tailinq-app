# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
# Install dependencies
flutter pub get

# Generate Freezed/JSON serializable code (required after model changes)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Analyze code
flutter analyze lib/

# Build for specific platform
flutter build macos --debug
flutter build ios --debug --no-codesign
flutter build android --debug
```

## Architecture

This is a **Pet Tracker** Flutter app using Clean Architecture with Riverpod for state management.

### Layer Structure

```
lib/
├── core/           # Shared utilities (theme, constants)
├── data/           # Data layer (models, repositories impl, data sources)
├── domain/         # Business logic (repository interfaces)
└── presentation/   # UI layer (screens, widgets, providers, router)
```

### Key Technologies

- **State Management**: Riverpod (with `ProviderScope` wrapping the app)
- **Routing**: GoRouter with `ShellRoute` for bottom navigation
- **Models**: Freezed for immutable data classes with JSON serialization
- **Theme**: Material Design 3, light mode only, primary color green

### Data Flow

1. `MockDeviceRepository` implements `DeviceRepository` interface
2. Riverpod providers in `presentation/providers/` expose repository data to UI
3. `isLiveModeProvider` controls real-time location streaming (2-second intervals)
4. Screens consume providers via `ConsumerWidget`

### Navigation

GoRouter with 3 tabs via `ShellRoute`:
- `/home` - Map view with device marker
- `/activity` - Activity history (placeholder)
- `/settings` - Settings (placeholder)

### Models (Freezed)

- `Device`: id, name, batteryLevel, status, isLiveMode, safeZoneRadius, lastLocation
- `Location`: latitude, longitude, timestamp

After modifying models, always run `dart run build_runner build --delete-conflicting-outputs`.

### Current State

- Mock data only (no real backend)
- Map is a placeholder (green gradient with grid) - designed for easy Google Maps integration later
- Live mode simulates marker movement with random offsets
