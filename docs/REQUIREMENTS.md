### 📋 [Engineering Prompt] Flutter MVP: Pet Tracker App

**Project Context:**
Develop a cross-platform mobile app (MVP) for tracking a pet using a wearable edge device. The focus is on **Real-time Location Tracking** and **Geofencing**.

**1. Tech Stack & Environment**

* **Framework:** Flutter 3.x (Latest Stable)
* **Language:** Dart 3.x
* **State Management:** `flutter_riverpod` (Riverpod Generator preferred)
* **Architecture:** MVVM + Repository Pattern (Clean Architecture)
* **Navigation:** `go_router` (Use `ShellRoute` for Bottom Navigation)
* **Code Generation:** `freezed`, `json_serializable`, `build_runner`
* **Maps:** `Maps_flutter` (Use placeholder API key)
* **UI Style:** Material Design 3 (Use `useMaterial3: true`)

**2. Visual Design & Theme**

* **Color Palette:**
* **Primary:** Green (Nature-friendly, e.g., `Colors.green`)
* **Background:** White (Clean, Modern)
* **Live Mode Indicator:** A blinking Red/Orange badge or icon.


* **Theme Mode:** **Light Mode Only** (Force `ThemeMode.light`).
* **Typography:** Default Material 3 (Roboto/San Francisco).

**3. Folder Structure (Strictly Follow This)**

```text
lib/
├── main.dart
├── app.dart (Theme & Router setup)
├── core/
│   ├── theme/ (AppTheme, ColorSchemes)
│   └── constants/ (Asset paths, API endpoints)
├── data/
│   ├── models/ (Freezed models: Device, Location)
│   ├── repositories/ (MockDeviceRepository implementation)
│   └── sources/ (MockDataSource)
├── domain/
│   ├── entities/ (Optional if separating strict clean arch, but can merge with models for MVP)
│   └── repositories/ (Repository Interface)
├── presentation/
│   ├── providers/ (Riverpod Providers: deviceProvider, locationStreamProvider)
│   ├── router/ (GoRouter configuration)
│   ├── widgets/ (Common widgets: BlinkingLiveBadge, BottomSheet)
│   └── screens/
│       ├── home/ (MapScreen, DeviceStatusWidget)
│       ├── activity/ (ActivityScreen - Placeholder)
│       └── settings/ (SettingsScreen - Placeholder)

```

**4. Data Models (Use Freezed)**

* **Device:**
* `id` (String), `name` (String), `batteryLevel` (int), `status` (Enum: online, offline), `isLiveMode` (bool), `imageUrl` (String), `safeZoneRadius` (double).


* **Location:**
* `latitude` (double), `longitude` (double), `timestamp` (DateTime).



**5. Feature Specifications**

**A. Navigation (Bottom Bar)**

* **Tab 1: Home (Map)** - Main feature.
* **Tab 2: Activity** - Placeholder text for now.
* **Tab 3: Settings** - Placeholder text for now.

**B. Home Screen (Map & Control)**

* **Map View:** Full screen Google Map. Show a custom marker for the pet.
* **Bottom Sheet (Persistent):**
* Shows Pet Name, Battery %, Connection Status.
* **Action:** A "Live Mode" Toggle Button.


* **Live Mode Logic:**
* **Off:** Map shows static last known location.
* **On:**
* Trigger a Mock Stream in Repository that updates `Location` every 2 seconds (simulate movement).
* Map camera should follow the marker.
* **Visual:** Show a **"LIVE" Badge** at the top-center of the screen. This badge must have a **blinking/pulsing animation** to indicate active tracking.
* Bottom Bar remains visible (In-place update).





**C. Mock Data Implementation**

* Create a `MockDeviceRepository` class.
* Implement a method `Stream<Location> getLiveLocationStream()` that yields a new coordinate (slightly moved from the previous one) every 2 seconds when Live Mode is active.

**6. Implementation Steps for AI**

1. Setup project structure and dependencies.
2. Define Freezed models (`Device`, `Location`).
3. Implement `MockDeviceRepository` with a location stream simulation.
4. Setup Riverpod providers for `deviceStatus` and `location`.
5. Implement `GoRouter` with `ScaffoldWithNavBar`.
6. Build `HomeScreen` with Google Maps and the "Blinking Live Badge".

---
