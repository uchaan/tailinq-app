# Tailinq Pet Tracker App - 구현 결과 문서

## 프로젝트 개요

Tailinq는 반려동물 추적 디바이스용 크로스 플랫폼 모바일 앱 MVP입니다.

### 핵심 기능
- **Real-time Location Tracking**: 2초 간격으로 위치 업데이트
- **Live Mode Toggle**: 실시간 추적 모드 켜기/끄기
- **Device Status Display**: 배터리 레벨, 온라인/오프라인 상태 표시
- **Bottom Navigation**: 3개 탭 (Home, Activity, Settings)

---

## 기술 스택

| 분류 | 기술 |
|------|------|
| Framework | Flutter 3.10+ |
| State Management | Riverpod 2.x |
| Navigation | GoRouter 13.x |
| Data Modeling | Freezed + JSON Serializable |
| Theme | Material Design 3 |

---

## 아키텍처

Clean Architecture 패턴을 적용하여 3개 레이어로 분리했습니다.

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

### 폴더 구조

```
lib/
├── main.dart                 # 앱 진입점 (ProviderScope)
├── app.dart                  # MaterialApp + Router 설정
├── core/
│   ├── theme/
│   │   └── app_theme.dart    # Material 3 테마 (Green 기반)
│   └── constants/
│       └── app_constants.dart # 상수 정의
├── data/
│   ├── models/
│   │   ├── device.dart       # Freezed Device 모델
│   │   ├── device.freezed.dart
│   │   ├── device.g.dart
│   │   ├── location.dart     # Freezed Location 모델
│   │   ├── location.freezed.dart
│   │   └── location.g.dart
│   ├── repositories/
│   │   └── mock_device_repository.dart  # Mock 구현체
│   └── sources/
│       └── mock_data_source.dart        # Mock 데이터 생성
├── domain/
│   └── repositories/
│       └── device_repository.dart       # 인터페이스 정의
└── presentation/
    ├── providers/
    │   ├── device_provider.dart    # 디바이스 상태 관리
    │   └── location_provider.dart  # 위치 스트림 관리
    ├── router/
    │   └── app_router.dart         # GoRouter + ShellRoute
    ├── screens/
    │   ├── home/
    │   │   └── home_screen.dart    # 메인 지도 화면
    │   ├── activity/
    │   │   └── activity_screen.dart # Placeholder
    │   └── settings/
    │       └── settings_screen.dart # Placeholder
    └── widgets/
        ├── blinking_live_badge.dart    # 깜빡이는 LIVE 뱃지
        └── device_bottom_sheet.dart    # 디바이스 정보 시트
```

---

## 주요 구현 상세

### 1. 데이터 모델 (Freezed)

#### Device 모델
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

#### Location 모델
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

ShellRoute를 사용한 Bottom Navigation:

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

### 4. UI 컴포넌트

#### BlinkingLiveBadge
- `AnimationController`를 사용한 깜빡임 효과
- Red ↔ Orange 색상 전환
- 800ms 주기 반복

#### DeviceBottomSheet
- 펫 아바타 (CircleAvatar)
- 이름 + LIVE 뱃지
- 배터리 레벨 (아이콘 + 퍼센트)
- 상태 표시 (Online/Offline/Low Battery)
- Live Tracking 토글 스위치
- 마지막 업데이트 시간

#### HomeScreen (지도 Placeholder)
- 녹색 그라데이션 배경
- 그리드 패턴 (CustomPaint)
- 애니메이션 마커 (Live 모드 시 이동)
- 하단 DeviceBottomSheet

---

## 테마 설정

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

## Mock 데이터

`MockDataSource`에서 2개의 샘플 디바이스 제공:
1. **Max**: 배터리 85%, Online 상태
2. **Bella**: 배터리 45%, Low Battery 상태

Live 모드 활성화 시 2초마다 위치가 랜덤하게 변경됩니다.

---

## 향후 확장 계획

1. **Google Maps 통합**: 현재 Placeholder를 `google_maps_flutter`로 교체
2. **Geofencing**: Safe Zone 경계 이탈 알림
3. **Activity History**: 이동 경로 기록 및 표시
4. **Backend 연동**: Mock Repository를 실제 API 호출로 교체
5. **Push Notifications**: 알림 기능 추가

---

## Git 커밋 히스토리

```
e046538 Add live mode with blinking badge
d0ab861 Implement navigation and screens
656ceea Implement mock repository and providers
0ddebce Add folder structure and models
8d95986 Add dependencies for MVP
8fb25af Initial Flutter project setup
```
