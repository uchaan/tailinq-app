# Tailinq Pet Tracker App - Implementation Document

## Project Overview

Tailinq is a cross-platform mobile app MVP for a pet tracking device.

### Core Features
- **Real-time Location Tracking**: Location updates every 2 seconds
- **Live Mode Toggle**: Turn real-time tracking mode on/off
- **Device Status Display**: Battery level, online/offline status display
- **Bottom Navigation**: 3 tabs (Home, Activity, Settings)

---

## Tech Stack

| Category | Technology |
|------|------|
| Framework | Flutter 3.10+ |
| State Management | Riverpod 2.x |
| Navigation | GoRouter 13.x |
| Data Modeling | Freezed + JSON Serializable |
| Theme | Material Design 3 |

---

## Architecture

Clean Architecture pattern applied with separation into 3 layers.

```
┌─────────────────────────────────────────────┐
│              Presentation Layer             │
│  (Screens, Widgets, Providers, Router)      │
├─────────────────────────────────────────────┤
│                Domain Layer                 │
│         (Repository Interfaces)             │
├─────────────────────────────────────────────┤
│                 Data Layer                  │
│    (Models, Repository Impl, Sources)       │
└─────────────────────────────────────────────┘
```

### Folder Structure

```
lib/
├── main.dart                 # App entry point (ProviderScope)
├── app.dart                  # MaterialApp + Router setup
├── core/
│   ├── theme/
│   │   └── app_theme.dart    # Material 3 theme (Green-based)
│   └── constants/
│       └── app_constants.dart # Constant definitions
├── data/
│   ├── models/
│   │   ├── device.dart       # Freezed Device model
│   │   ├── device.freezed.dart
│   │   ├── device.g.dart
│   │   ├── location.dart     # Freezed Location model
│   │   ├── location.freezed.dart
│   │   └── location.g.dart
│   ├── repositories/
│   │   └── mock_device_repository.dart  # Mock implementation
│   └── sources/
│       └── mock_data_source.dart        # Mock data generation
├── domain/
│   └── repositories/
│       └── device_repository.dart       # Interface definition
└── presentation/
    ├── providers/
    │   ├── device_provider.dart    # Device state management
    │   └── location_provider.dart  # Location stream management
    ├── router/
    │   └── app_router.dart         # GoRouter + ShellRoute
    ├── screens/
    │   ├── home/
    │   │   └── home_screen.dart    # Main map screen
    │   ├── activity/
    │   │   └── activity_screen.dart # Placeholder
    │   └── settings/
    │       └── settings_screen.dart # Placeholder
    └── widgets/
        ├── blinking_live_badge.dart    # Blinking LIVE badge
        └── device_bottom_sheet.dart    # Device info sheet
```

---

## Key Implementation Details

### 1. Data Models (Freezed)

#### Device Model
```dart
@freezed
class Device with _$Device {
  const factory Device({
    required String id,
    required String name,
    required int batteryLevel,
    required DeviceStatus status,
    required bool isLiveMode,
    String? imageUrl,
    @Default(100.0) double safeZoneRadius,
    Location? lastLocation,
  }) = _Device;
}
```

#### Location Model
```dart
@freezed
class Location with _$Location {
  const factory Location({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
  }) = _Location;
}
```

### 2. State Management (Riverpod)

```dart
// Repository Provider
final deviceRepositoryProvider = Provider<MockDeviceRepository>(...);

// Device List
final devicesProvider = FutureProvider<List<Device>>(...);

// Selected Device
final selectedDeviceIdProvider = StateProvider<String?>((ref) => '1');
final selectedDeviceProvider = FutureProvider<Device?>(...);

// Live Mode Toggle
final isLiveModeProvider = StateNotifierProvider<LiveModeNotifier, bool>(...);

// Location Stream
final locationStreamProvider = StreamProvider<Location?>(...);
```

### 3. Navigation (GoRouter)

Bottom Navigation using ShellRoute:

```dart
ShellRoute(
  builder: (context, state, child) => ScaffoldWithNavBar(child: child),
  routes: [
    GoRoute(path: '/home', ...),
    GoRoute(path: '/activity', ...),
    GoRoute(path: '/settings', ...),
  ],
)
```

### 4. UI Components

#### BlinkingLiveBadge
- Blinking effect using `AnimationController`
- Red ↔ Orange color transition
- 800ms cycle repeat

#### DeviceBottomSheet
- Pet avatar (CircleAvatar)
- Name + LIVE badge
- Battery level (icon + percentage)
- Status display (Online/Offline/Low Battery)
- Live Tracking toggle switch
- Last update time

#### HomeScreen (Map Placeholder)
- Green gradient background
- Grid pattern (CustomPaint)
- Animated marker (moves in Live mode)
- DeviceBottomSheet at bottom

---

## Theme Settings

```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: Colors.white,
  ...
)
```

---

## Mock Data

`MockDataSource` provides 2 sample devices:
1. **Max**: Battery 85%, Online status
2. **Bella**: Battery 45%, Low Battery status

When Live mode is activated, location changes randomly every 2 seconds.

---

## Future Expansion Plans

1. **Google Maps Integration**: Replace current Placeholder with `google_maps_flutter`
2. **Geofencing**: Safe Zone boundary breach alerts
3. **Activity History**: Movement route recording and display
4. **Backend Integration**: Replace Mock Repository with actual API calls
5. **Push Notifications**: Add notification functionality

---

## Git Commit History

```
e046538 Add live mode with blinking badge
d0ab861 Implement navigation and screens
656ceea Implement mock repository and providers
0ddebce Add folder structure and models
8d95986 Add dependencies for MVP
8fb25af Initial Flutter project setup
```
