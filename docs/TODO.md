# Tailinq App MVP - Full Task List

> Last updated: 2026-02-06 (Geofence Setup & Management)

---

## Implementation Status Summary

| Category | Progress | Status |
|---------|--------|------|
| Project Foundation | 100% | ✅ Complete |
| Authentication System | 85% | 🔄 In Progress |
| Map & Location | 90% | 🔄 In Progress |
| Pet Management | 90% | 🔄 In Progress |
| Device Management | 50% | 🔄 In Progress |
| Activity Screen | 60% | 🔄 In Progress |
| Backend Integration | 0% | ⬜ Pending |
| Notification System | 0% | ⬜ Pending |
| Testing & Quality | 10% | 🔄 In Progress |

---

## 1. Project Foundation

### ✅ Completed
- [x] Flutter project initial setup
- [x] Clean Architecture folder structure
- [x] Riverpod state management setup
- [x] GoRouter navigation (ShellRoute + Bottom Navigation)
- [x] Material Design 3 theme (Green-based, Light Mode)
- [x] Freezed models (Device, Location, User)
- [x] Mock Repository pattern
- [x] Storage Repository interface and Mock implementation (S3 integration ready)

---

## 2. Authentication System

### ✅ Completed
- [x] AWS Cognito integration (Amplify Flutter)
- [x] Email/password sign-up
- [x] Email verification (Confirmation Code)
- [x] Sign-in/Sign-out
- [x] Password reset
- [x] Auth state management (AuthProvider)
- [x] Router authentication guard (Protected Routes)
- [x] Social login button UI (Google, Apple)

- [x] **Profile Management**
  - Profile edit screen (`/settings/edit-profile`)
  - Name change (Cognito `updateUserAttributes`)
  - Account deletion (Cognito `deleteUser`)

### ⬜ Future Work
- [ ] **Google Sign-In API Integration**
  - Add `google_sign_in` package
  - Google Cloud Console OAuth setup
  - Cognito Identity Provider connection

- [ ] **Apple Sign-In API Integration**
  - Add `sign_in_with_apple` package
  - Apple Developer setup
  - Cognito Identity Provider connection

- [ ] **Profile Image Upload**
  - Profile image S3 upload
  - Image compression/resizing

- [ ] **Security Enhancements**
  - MFA (Multi-Factor Authentication)
  - Biometric authentication (Face ID / Touch ID)
  - Password change (while signed in)

---

## 3. Map & Location

### ✅ Completed
- [x] Marker display (pet location)
- [x] Live Mode toggle
- [x] Blinking LIVE badge
- [x] Mock location stream (2-second interval)
- [x] **Google Maps Integration**
  - Added `google_maps_flutter` package
  - Google Maps API key setup
  - Platform-specific settings for Android/iOS/Web
  - Replaced with GoogleMap widget
  - Auto camera follow in Live Mode
  - Marker color change (Live: red, Normal: green)
- [x] **Location Simulation (for testing/demo)**
  - LocationSimulator service implementation
  - 5 scenarios: Idle, Walking, Running, Exploring, Returning
  - Waypoint-based random route generation
  - SimulationControlPanel UI (inside DeviceBottomSheet)
  - Simulation enable/disable, start/pause/stop
  - Operates independently from Live Mode
  - Marker color change (Simulation: orange)
  - Manual camera focus button (my_location)
- [x] **Custom Markers**
  - Pet profile image marker (CircleAvatar-based)
  - Mode-specific border colors (Simulation: orange, Live: red, Default: green)
  - Species emoji fallback when no image available
- [x] **Route Display (Show Route)**
  - Show Route toggle (inside Bottom Sheet, blue theme)
  - Speed-based color Polyline (Blue/Green/Yellow/Red)
  - Mock 1-hour walk history generator (360 points, 4-phase scenario)
  - Real-time location accumulation (Live/Simulation linked)
  - Speed legend overlay (top-left)
  - Auto route reset/reload on device switch

### ⬜ Future Work
- [ ] **Marker Clustering**
  - Marker clustering for simultaneous display of multiple pets/devices

- [ ] **Camera Control Improvements**
  - Zoom in/out buttons

- [x] **Geofencing (Safe Zone)**
  - Geofence model (global entity) + PetGeofence many-to-many linking model
  - GeofenceRepository interface + Mock implementation
  - Geofence Circle display on map (semi-transparent fill + stroke)
  - Show Geofences toggle (green theme)
  - Manage Geofences screen (per-pet assignment list)
  - Draw on Map screen (tap map → center point, radius slider, color picker)
  - Add from Saved screen (add unassigned geofences)
  - Per-pet geofence assignment/removal
- [ ] **Advanced Geofencing**
  - Safe Zone boundary breach detection
  - Breach notification trigger

- [ ] **Advanced Route Features**
  - Route history playback (timeline slider)
  - Date/time range filter
  - Real backend location data integration (Mock → API)
  - Speed/time info Tooltip on route tap

---

## 4. Pet Management

### ✅ Completed
- [x] Pet model creation (id, name, imageUrl, species, breed, birthDate, deviceId)
- [x] PetMember model creation (User-Pet many-to-many relationship, role: owner/family/caretaker)
- [x] Separated pet-related fields from Device model (name, imageUrl → moved to Pet)
- [x] PetRepository interface creation
- [x] MockPetRepository implementation
- [x] Pet Provider creation (PetNotifier with CRUD operations)
- [x] UI component updates (DeviceBottomSheet, HomeScreen)
- [x] **Pet Profile Management**
  - Pet list screen (`/pets`)
  - Pet add screen (`/pets/add`)
  - Pet detail screen (`/pets/:id`)
  - Pet edit screen (`/pets/:id/edit`)
  - Pet deletion (confirmation dialog)
  - Pet info editing (name, species, breed, birth date)
  - Pet image selection (camera/gallery)
  - Mock Storage (base64 data URL) - S3 integration ready
- [x] **Pet Switching**
  - Multiple pet support
  - Pet selection UI (Home Tab, Manage Pets screen)
  - Selected pet state management (selectedPetIdProvider)
  - Default profile photos (species emoji: 🐕🐱🐦🐰)
- [x] Added "Manage Pets" menu to Settings screen

### ⬜ Future Work
- [ ] **AWS S3 Image Upload**
  - `amplify_storage_s3` package integration
  - Replace MockStorageRepository → S3StorageRepository
  - Image compression/resizing

- [ ] **Pet Sharing (Family Feature)**
  - Invitation code generation
  - Invitation accept/reject
  - Member role management (owner, family, caretaker)
  - Member list view/delete

---

## 5. Device Management

### ✅ Completed
- [x] Device model (id, name, battery, status, location)
- [x] Device Bottom Sheet UI
- [x] Battery level display
- [x] Online/offline status display
- [x] Mock device data (Max, Bella)
- [x] Pet switching on Home Tab (DeviceBottomSheet)

### ⬜ Future Work
- [ ] **Device Registration**
  - Device registration via QR code scan
  - Device name setup
  - Pet profile linking

- [ ] **Device Settings**
  - Location update interval setting
  - Safe Zone radius setting
  - Low power mode setting

- [ ] **Multi-Device**
  - Multiple pet/device support
  - Device switching UI
  - Device list screen

- [ ] **Device Status Details**
  - Signal strength display
  - Last communication time
  - Firmware version check

---

## 6. Activity Screen (Activity History)

### ✅ Completed
- [x] Activity screen placeholder
- [x] **Health Metrics Dashboard**
  - HealthMetric model (Freezed: activity, rest, eating, drinking)
  - MockHealthRepository implementation
  - HealthProvider (data loading based on selected pet)
  - Health metric card UI (HealthMetricCard + Sparkline chart)
  - Pet switching support (AppBar pet switcher)
- [x] **Metric Detail Screen**
  - MetricDetailScreen (per-metric detail page)
  - 7-day daily line chart (DetailLineChart)
  - Per-metric icon/color/unit configuration (MetricConfig)

### ⬜ Future Work
- [ ] **Movement History**
  - Daily movement distance
  - Movement route timeline
  - Date-based filtering

- [ ] **Advanced Activity Statistics**
  - Weekly/monthly activity charts (currently 7-day only)
  - Average movement distance trends
  - Activity time zone analysis
  - Goal setting and achievement rate

- [ ] **Event Log**
  - Safe Zone breach records
  - Battery warning records
  - Connection status change records

- [ ] **Backend Integration**
  - Replace MockHealthRepository → API
  - Real-time health data collection

---

## 7. Backend Integration

### ⬜ Future Work
- [ ] **API Client Setup**
  - Dio or http package
  - Auth token interceptor
  - Error handling

- [ ] **Device API**
  - GET /devices - Device list
  - GET /devices/{id} - Device detail
  - POST /devices - Device registration
  - PUT /devices/{id} - Device update
  - DELETE /devices/{id} - Device deletion

- [ ] **Location API**
  - GET /devices/{id}/locations - Location history
  - WebSocket real-time location stream

- [ ] **User API**
  - GET /users/me - My info
  - PUT /users/me - Profile update

- [ ] **Pet API**
  - GET /pets - Pet list
  - GET /pets/{id} - Pet detail
  - POST /pets - Pet registration
  - PUT /pets/{id} - Pet update
  - DELETE /pets/{id} - Pet deletion
  - POST /pets/{id}/image - Image upload

- [ ] **Repository Replacement**
  - MockDeviceRepository → ApiDeviceRepository
  - MockPetRepository → ApiPetRepository
  - MockStorageRepository → S3StorageRepository
  - Environment-specific configuration (dev/staging/prod)

---

## 8. Notification System

### ⬜ Future Work
- [ ] **Local Notifications**
  - `flutter_local_notifications` package
  - Geofence breach notification
  - Low battery warning notification

- [ ] **Push Notifications**
  - Firebase Cloud Messaging (FCM)
  - AWS SNS / Pinpoint
  - Notification permission request

- [ ] **Notification Settings**
  - Per-type notification ON/OFF
  - Do Not Disturb time period setting
  - Notification history

---

## 9. Testing & Quality

### ✅ Completed
- [x] **Unit Tests**
  - [x] LocationSimulator unit test
  - [x] MockDeviceRepository unit test
  - [x] MockDataSource unit test
  - [x] SimulationProvider unit test

### ⬜ Future Work
- [ ] **Additional Unit Tests**
  - PetRepository test
  - PetProvider test
  - AuthProvider test
  - Model serialization test

- [ ] **Widget Tests**
  - Per-screen widget tests
  - Interaction tests

- [ ] **Integration Tests**
  - E2E test scenarios
  - Authentication flow test

- [ ] **Code Quality**
  - Stricter lint rules
  - Code coverage measurement

---

## Recommended Priority Order

### Phase 1: Core Feature Completion
1. ~~Google Maps integration~~ ✅
2. ~~Pet profile management~~ ✅
3. ~~Pet switching~~ ✅
4. ~~Location simulation~~ ✅
5. ~~Custom markers~~ ✅
6. ~~Route display~~ ✅
7. ~~Activity health metrics~~ ✅
8. ~~Profile editing~~ ✅
9. ~~Geofencing implementation~~ ✅

### Phase 2: Backend Integration
6. API client setup
7. Device/Location/Pet API integration
8. Mock Repository replacement
9. S3 image upload integration

### Phase 3: User Experience Improvement
10. Activity screen implementation
11. Notification system implementation
12. Social login integration

### Phase 4: Polish
13. User profile management
14. Device settings
15. Pet sharing (Family feature)
16. ~~Test code writing~~ 🔄 In Progress

---

## Recently Completed Tasks (2026-02-06)

### Geofence Setup & Management
- Geofence model (Freezed) + PetGeofence many-to-many linking model
- GeofenceRepository interface + MockGeofenceRepository implementation
- Geofence Provider (toggle, per-pet list, Circle overlay, unassigned list)
- Geofence Circle display on map (Show Geofences toggle)
- Manage Geofences screen (per-pet assignment list + FAB)
- Draw on Map screen (tap map for center point, radius slider 25–1000m, 8 color picker)
- Add from Saved screen (add unassigned geofences)

**Newly Created Files:**
- `lib/data/models/geofence.dart` — Geofence Freezed model
- `lib/data/models/pet_geofence.dart` — PetGeofence many-to-many Freezed model
- `lib/domain/repositories/geofence_repository.dart` — Repository interface
- `lib/data/repositories/mock_geofence_repository.dart` — Mock implementation
- `lib/presentation/providers/geofence_provider.dart` — Full Provider structure
- `lib/presentation/widgets/geofence/geofence_list_item.dart` — Reusable widget
- `lib/presentation/widgets/geofence/geofence_toggle.dart` — Toggle + navigation button
- `lib/presentation/screens/geofence/geofence_list_screen.dart` — Per-pet geofence list
- `lib/presentation/screens/geofence/geofence_draw_screen.dart` — Draw on map
- `lib/presentation/screens/geofence/geofence_saved_screen.dart` — Add existing geofence

**Modified Files:**
- `lib/core/constants/app_constants.dart` — Added geofence radius/color constants
- `lib/presentation/screens/home/home_screen.dart` — Circle display integration
- `lib/presentation/widgets/device_bottom_sheet.dart` — GeofenceToggle insertion
- `lib/presentation/router/app_router.dart` — Geofence route registration

---

## Recently Completed Tasks (2026-02-05 #2)

### Route Display (Show Route) Feature
- Show Route toggle: Added below Live Tracking in Bottom Sheet (blue theme)
- Speed-based color Polyline: 4 levels (< 0.5 Blue, 0.5–1.5 Green, 1.5–3.0 Yellow, > 3.0 Red)
- Mock 1-hour walk history generator: 360 points, 4-phase scenario (idle → walking → running → returning)
- Real-time location accumulation: Auto-add new points during Live/Simulation
- Speed legend overlay: Top-left of map

**Newly Created Files:**
- `lib/domain/models/route_point.dart` — RoutePoint model (location + speedMps)
- `lib/data/services/route_history_generator.dart` — Mock route generator
- `lib/presentation/utils/polyline_builder.dart` — Speed-based Polyline batching utility
- `lib/presentation/providers/route_provider.dart` — showRoute, routePoints, routePolylines Provider
- `lib/presentation/widgets/route_toggle.dart` — Show Route toggle widget
- `lib/presentation/widgets/speed_legend_overlay.dart` — Speed legend overlay

**Modified Files:**
- `lib/core/constants/app_constants.dart` — Added speed thresholds, route history settings
- `lib/presentation/widgets/device_bottom_sheet.dart` — RouteToggle insertion
- `lib/presentation/screens/home/home_screen.dart` — Polyline + SpeedLegend integration

### Activity Health Metrics Dashboard
- HealthMetric Freezed model (activity, rest, eating, drinking)
- MockHealthRepository + HealthProvider
- Health metric cards (with Sparkline chart)
- Metric detail screen (7-day line chart)

### Custom Markers
- Pet image/emoji CircleAvatar marker
- Mode-specific border colors (Simulation: orange, Live: red, Default: green)

### Profile Editing & Account Management
- EditProfileScreen (name change)
- Cognito updateUserAttributes / deleteUser integration

### App Icon Replacement
- New app icon applied for Android/iOS/macOS platforms

---

## Recently Completed Tasks (2026-02-05 #1)

### Location Simulation / Live Tracking Architecture Refactor
- Removed circular references (`simulationLocationStreamProvider`)
- Separated responsibilities (Simulation ↔ Live Tracking)
- Removed simulator integration from Repository
- Fixed Live Mode to not modify coordinates
- Removed debug prints

**Modified Files:**
- `lib/data/repositories/mock_device_repository.dart` — Removed coordinate modification, pure lastLocation emit
- `lib/presentation/providers/simulation_provider.dart` — Stream structure without circular references
- `lib/presentation/providers/location_provider.dart` — Separated simulation/live streams
- `lib/presentation/providers/device_provider.dart` — Removed simulator reference
- `lib/presentation/screens/home/home_screen.dart` — Marker color/location priority logic

### Unit Test Writing
- `test/data/services/location_simulator_test.dart` — Simulator core logic verification
- `test/data/repositories/mock_device_repository_test.dart` — Repository behavior verification
- `test/data/sources/mock_data_source_test.dart` — Mock data verification
- `test/presentation/providers/simulation_provider_test.dart` — Provider state management verification

---

## Recently Completed Tasks (2026-02-04)

### Location Simulation Feature Implementation
- **Newly Created Files:**
  - `lib/data/services/location_simulator.dart` - Simulation engine
  - `lib/presentation/providers/simulation_provider.dart` - Simulation state management
  - `lib/presentation/widgets/simulation_control_panel.dart` - Simulation UI

- **Modified Files:**
  - `lib/presentation/screens/home/home_screen.dart` - Simulation marker display, manual focus button
  - `lib/presentation/providers/location_provider.dart` - Simulation stream integration
  - `lib/presentation/providers/device_provider.dart` - Simulator connection
  - `lib/data/repositories/mock_device_repository.dart` - Simulator integration
  - `lib/presentation/widgets/device_bottom_sheet.dart` - Added SimulationControlPanel

### Pet Profile Management Feature Implementation
- **Newly Created Files:**
  - `lib/domain/repositories/storage_repository.dart`
  - `lib/data/repositories/mock_storage_repository.dart`
  - `lib/presentation/providers/storage_provider.dart`
  - `lib/presentation/screens/pet/pet_list_screen.dart`
  - `lib/presentation/screens/pet/pet_add_screen.dart`
  - `lib/presentation/screens/pet/pet_detail_screen.dart`
  - `lib/presentation/screens/pet/pet_edit_screen.dart`
  - `lib/presentation/widgets/pet/pet_form.dart`
  - `lib/presentation/widgets/pet/pet_image_picker.dart`
  - `lib/presentation/widgets/pet/pet_list_item.dart`
  - `lib/presentation/widgets/pet/species_selector.dart`

- **Modified Files:**
  - `pubspec.yaml` - Added image_picker, uuid packages
  - `lib/presentation/router/app_router.dart` - Added Pet routes
  - `lib/presentation/providers/pet_provider.dart` - Added PetNotifier
  - `lib/presentation/screens/settings/settings_screen.dart` - Manage Pets menu
  - `lib/presentation/widgets/device_bottom_sheet.dart` - Default avatar, pet switching

---

## Reference Documents

| Document | Description |
|------|------|
| `docs/tailinq_app_mvp.md` | MVP requirements definition |
| `docs/IMPLEMENTATION.md` | Implementation details document |
| `docs/TESTING.md` | Testing guide |
| `docs/API_SETUP.md` | API key setup guide |
| `CLAUDE.md` | Claude Code guide |
