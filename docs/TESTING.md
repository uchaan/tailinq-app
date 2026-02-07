# Tailinq App Testing Guide

## Prerequisites

- Flutter SDK 3.10 or higher
- Xcode (for iOS/macOS builds)
- Android Studio (for Android builds)

---

## Running the App

### 1. Install Dependencies

```bash
cd /Users/youchanpark/Desktop/99_workspace/tailinq/tailinq_app
flutter pub get
```

### 2. Generate Freezed Code

If model files have been changed or running for the first time:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run by Platform

#### macOS (Fastest testing method)
```bash
flutter run -d macos
```

#### iOS Simulator
```bash
# Check available simulator list
flutter devices

# Run simulator
flutter run -d <simulator-id>
```

#### Android Emulator
```bash
flutter run -d <emulator-id>
```

#### Chrome (Web)
```bash
flutter run -d chrome
```

---

## Running Unit Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/data/services/location_simulator_test.dart
flutter test test/data/repositories/mock_device_repository_test.dart
flutter test test/data/sources/mock_data_source_test.dart
flutter test test/presentation/providers/simulation_provider_test.dart
```

### Test Structure

```
test/
├── data/
│   ├── services/location_simulator_test.dart
│   ├── repositories/mock_device_repository_test.dart
│   └── sources/mock_data_source_test.dart
└── presentation/
    └── providers/
        └── simulation_provider_test.dart
```

---

## Feature Test Checklist

### 1. App Launch Verification
- [ ] Does the app start normally?
- [ ] Is the "Tailinq" title displayed in the AppBar?

### 2. Bottom Navigation
- [ ] Click **Home** tab → Navigate to map screen
- [ ] Click **Activity** tab → Navigate to Activity screen (Placeholder)
- [ ] Click **Settings** tab → Navigate to Settings screen (Placeholder)
- [ ] Is the currently selected tab highlighted?

### 3. Home Screen - Map Placeholder
- [ ] Is the green gradient background displayed?
- [ ] Is the grid pattern visible?
- [ ] Is the pet marker displayed near the center of the screen?
- [ ] Is the pet name ("Max") displayed above the marker?

### 4. Device Bottom Sheet
- [ ] Is the Bottom Sheet displayed at the bottom of the screen?
- [ ] Is the pet icon (CircleAvatar) visible?
- [ ] Is the pet name ("Max") displayed?
- [ ] Are the battery icon and percentage (85%) visible?
- [ ] Is the status display (Online) visible with a green dot?
- [ ] Are the "Live Tracking" label and toggle switch visible?

### 5. Live Mode Test
- [ ] Switch Live Tracking toggle to ON
- [ ] Does the **LIVE badge** appear next to the pet name?
- [ ] Does the LIVE badge blink red ↔ orange?
- [ ] Does the marker move slightly every 2 seconds?
- [ ] Does the marker color change from green to red?

- [ ] Switch Live Tracking toggle to OFF
- [ ] Does the LIVE badge disappear?
- [ ] Does the marker movement stop?
- [ ] Does the marker color change back to green?

### 6. Activity Screen
- [ ] Is "Activity History" text displayed?
- [ ] Is "Coming soon..." text displayed?
- [ ] Is the timeline icon visible?

### 7. Settings Screen
- [ ] Is "Settings" text displayed?
- [ ] Is "Coming soon..." text displayed?
- [ ] Is the settings icon visible?

---

## Manual Test Scenarios (Live + Simulation Combinations)

Verify that Live Tracking and Simulation operate independently after the architecture refactor.

### Scenario 1: Live OFF + Simulation OFF

**Setup:** Default state (both features disabled)

**Verification:**
- [ ] Marker displayed at static location (green)
- [ ] No marker movement
- [ ] InfoWindow: "Last known location"
- [ ] Last update time displayed in Bottom Sheet

### Scenario 2: Live ON + Simulation OFF

**Setup:** Live Tracking toggle ON, Simulation disabled

**Verification:**
- [ ] Marker color: red (Live)
- [ ] LIVE badge displayed and blinking
- [ ] No marker position change (no coordinate modification, static — Repository emits lastLocation as-is)
- [ ] InfoWindow: "Live Tracking"
- [ ] Marker returns to green when Live is turned OFF

### Scenario 3: Live OFF + Simulation ON

**Setup:** Simulation Mode enabled → Select Walking scenario → Press Start button

**Verification:**
- [ ] Marker color: orange (Simulation)
- [ ] Marker moves along waypoints
- [ ] Scenario label displayed: "Simulating: Walking"
- [ ] Pause button pauses movement
- [ ] Stop button returns to home location
- [ ] Returns to green static marker when simulation is disabled

### Scenario 4: Live ON + Simulation ON

**Setup:** Live Tracking ON + Simulation Walking + Start

**Verification:**
- [ ] Simulation location takes priority (orange marker)
- [ ] Marker moves along waypoints
- [ ] Simulation Stop → Switches to live marker (red)
- [ ] Simulation disabled → Live location displayed (red)
- [ ] Live also OFF → Static location (green)

### Common Verification Items

- [ ] Clicking focus button (my_location icon) moves camera to current marker position
- [ ] Camera does not automatically follow the marker (manual focus only)
- [ ] Marker color changes correctly when switching scenarios
- [ ] App runs smoothly without performance degradation

---

## Code Analysis

```bash
# Run Dart analysis
flutter analyze lib/

# Expected result: Only info-level warnings (no errors)
```

---

## Build Tests

### macOS Debug Build
```bash
flutter build macos --debug
# Result: build/macos/Build/Products/Debug/tailinq_app.app created
```

### iOS Debug Build (for Simulator)
```bash
flutter build ios --debug --no-codesign --simulator
```

### Android Debug Build
```bash
flutter build apk --debug
# Result: build/app/outputs/flutter-apk/app-debug.apk created
```

---

## Known Limitations

1. **iOS physical device build**: Requires iOS SDK 17.5, separate installation needed in Xcode
2. **Maps**: Only Placeholder implemented currently (Google Maps API key not configured)
3. **Backend**: Uses mock data only (no actual server integration)
4. **Activity/Settings**: Only placeholder screens implemented

---

## Troubleshooting

### "flutter: command not found"
If Flutter is not in PATH:
```bash
/Users/youchanpark/flutter/bin/flutter run
```

### Freezed Code Generation Error
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### iOS Build Failure "iOS 17.5 is not installed"
Install iOS 17.5 platform in Xcode > Settings > Components

### Simulator/Emulator Not Visible
```bash
# Check all available devices
flutter devices

# Test with macOS first
flutter run -d macos
```
