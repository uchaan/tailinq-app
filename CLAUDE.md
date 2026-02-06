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

# Run tests
flutter test

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
├── core/           # Shared utilities (theme, constants, errors)
├── data/           # Data layer (models, repositories impl, services, data sources)
├── domain/         # Business logic (repository interfaces)
└── presentation/   # UI layer (screens, widgets, providers, router)
```

### Key Technologies

- **State Management**: Riverpod (with `ProviderScope` wrapping the app)
- **Routing**: GoRouter with `ShellRoute` for bottom navigation
- **Models**: Freezed for immutable data classes with JSON serialization
- **Maps**: Google Maps Flutter with custom markers, polylines, circles
- **Auth**: AWS Amplify (Cognito)
- **Theme**: Material Design 3, light mode only, primary color green

### Data Flow

1. Repository interfaces defined in `domain/repositories/`
2. Mock implementations in `data/repositories/` (prefixed with `mock_`)
3. Riverpod providers in `presentation/providers/` expose repository data to UI
4. Screens consume providers via `ConsumerWidget` or `ConsumerStatefulWidget`

### Navigation

GoRouter with authentication guard:
- Auth routes: `/sign-in`, `/sign-up`, `/confirm-email`, `/forgot-password`, `/reset-password`
- Protected routes via `ShellRoute`:
  - `/home` - Map view with pet marker, geofence circles
  - `/home/geofences` - Manage geofences for selected pet
  - `/home/geofences/draw` - Draw new geofence on map
  - `/home/geofences/saved` - Add from saved geofences
  - `/activity` - Health metrics dashboard
  - `/activity/:metricType` - Metric detail with 7-day chart
  - `/settings` - Settings with logout
  - `/settings/edit-profile` - Edit user profile
  - `/pets` - Pet list
  - `/pets/add` - Add new pet
  - `/pets/:id` - Pet detail
  - `/pets/:id/edit` - Edit pet

### Models (Freezed)

- `Pet`: id, name, imageUrl, species, breed, birthDate, deviceId
- `PetMember`: id, petId, userId, role (owner/family/caretaker), joinedAt
- `Device`: id, batteryLevel, status, isLiveMode, petId, safeZoneRadius, lastLocation
- `Location`: latitude, longitude, timestamp
- `User`: id, email, name, emailVerified
- `Geofence`: id, name, latitude, longitude, radiusMeters, color
- `PetGeofence`: id, petId, geofenceId, assignedAt (many-to-many)
- `HealthMetric`: petId, type, value, unit, timestamp

After modifying models, always run `dart run build_runner build --delete-conflicting-outputs`.

### Key Providers

- `selectedPetIdProvider` - Currently selected pet ID
- `selectedPetProvider` - Selected pet model
- `selectedDeviceProvider` - Device linked to selected pet
- `isLiveModeProvider` - Live tracking toggle
- `simulationProvider` - Location simulation state
- `showRouteProvider` - Route polyline toggle
- `showGeofencesProvider` - Geofence circles toggle
- `selectedPetGeofencesProvider` - Geofences assigned to selected pet
- `geofenceCirclesProvider` - Circle overlays for map

### Current State

- AWS Cognito authentication (email/password)
- Google Maps integration with live tracking
- Mock data for devices, pets, health metrics (no real backend yet)
- Location simulation with 5 scenarios (idle, walking, running, exploring, returning)
- Route history with speed-based coloring
- Geofencing with map drawing and per-pet assignment

## API Keys

Sensitive files are gitignored. Copy `.example` files and add your keys:
- `lib/amplifyconfiguration.dart` - Cognito config
- `android/app/src/main/AndroidManifest.xml` - Google Maps API key
- `ios/Runner/AppDelegate.swift` - Google Maps API key
