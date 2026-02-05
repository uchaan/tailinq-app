# Tailinq App 테스트 가이드

## 사전 요구사항

- Flutter SDK 3.10 이상
- Xcode (iOS/macOS 빌드용)
- Android Studio (Android 빌드용)

---

## 앱 실행 방법

### 1. 의존성 설치

```bash
cd /Users/youchanpark/Desktop/99_workspace/tailinq/tailinq_app
flutter pub get
```

### 2. Freezed 코드 생성

모델 파일을 변경했거나 처음 실행하는 경우:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. 플랫폼별 실행

#### macOS (가장 빠른 테스트 방법)
```bash
flutter run -d macos
```

#### iOS Simulator
```bash
# 사용 가능한 시뮬레이터 목록 확인
flutter devices

# 시뮬레이터 실행
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

## Unit Test 실행

```bash
# 전체 테스트 실행
flutter test

# 특정 테스트 파일 실행
flutter test test/data/services/location_simulator_test.dart
flutter test test/data/repositories/mock_device_repository_test.dart
flutter test test/data/sources/mock_data_source_test.dart
flutter test test/presentation/providers/simulation_provider_test.dart
```

### 테스트 구조

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

## 기능 테스트 체크리스트

### 1. 앱 실행 확인
- [ ] 앱이 정상적으로 시작되는가?
- [ ] "Tailinq" 타이틀이 AppBar에 표시되는가?

### 2. Bottom Navigation
- [ ] **Home** 탭 클릭 → 지도 화면으로 이동
- [ ] **Activity** 탭 클릭 → Activity 화면으로 이동 (Placeholder)
- [ ] **Settings** 탭 클릭 → Settings 화면으로 이동 (Placeholder)
- [ ] 현재 선택된 탭이 하이라이트되는가?

### 3. Home 화면 - 지도 Placeholder
- [ ] 녹색 그라데이션 배경이 표시되는가?
- [ ] 그리드 패턴이 보이는가?
- [ ] 펫 마커가 화면 중앙 근처에 표시되는가?
- [ ] 마커 위에 펫 이름("Max")이 표시되는가?

### 4. Device Bottom Sheet
- [ ] 화면 하단에 Bottom Sheet가 표시되는가?
- [ ] 펫 아이콘(CircleAvatar)이 보이는가?
- [ ] 펫 이름("Max")이 표시되는가?
- [ ] 배터리 아이콘과 퍼센트(85%)가 보이는가?
- [ ] 상태 표시(Online)가 초록색 점과 함께 보이는가?
- [ ] "Live Tracking" 라벨과 토글 스위치가 보이는가?

### 5. Live Mode 테스트
- [ ] Live Tracking 스위치를 ON으로 전환
- [ ] **LIVE 뱃지**가 펫 이름 옆에 나타나는가?
- [ ] LIVE 뱃지가 빨강↔주황색으로 깜빡이는가?
- [ ] 마커가 2초마다 약간씩 이동하는가?
- [ ] 마커 색상이 초록색에서 빨간색으로 변경되는가?

- [ ] Live Tracking 스위치를 OFF로 전환
- [ ] LIVE 뱃지가 사라지는가?
- [ ] 마커 이동이 멈추는가?
- [ ] 마커 색상이 다시 초록색으로 변경되는가?

### 6. Activity 화면
- [ ] "Activity History" 텍스트가 표시되는가?
- [ ] "Coming soon..." 텍스트가 표시되는가?
- [ ] timeline 아이콘이 보이는가?

### 7. Settings 화면
- [ ] "Settings" 텍스트가 표시되는가?
- [ ] "Coming soon..." 텍스트가 표시되는가?
- [ ] settings 아이콘이 보이는가?

---

## 수동 테스트 시나리오 (Live + Simulation 조합)

아키텍처 수정 후 Live Tracking과 Simulation이 독립적으로 동작하는지 검증합니다.

### 시나리오 1: Live OFF + Simulation OFF

**설정:** 기본 상태 (두 기능 모두 꺼짐)

**검증:**
- [ ] 마커가 정적 위치에 표시됨 (초록색)
- [ ] 마커 이동 없음
- [ ] InfoWindow: "Last known location"
- [ ] Bottom Sheet에 마지막 업데이트 시간 표시

### 시나리오 2: Live ON + Simulation OFF

**설정:** Live Tracking 토글 ON, Simulation 비활성

**검증:**
- [ ] 마커 색상: 빨강 (Live)
- [ ] LIVE 뱃지 표시 및 깜빡임
- [ ] 마커 위치 변화 없음 (좌표 변조 없으므로 정적 — Repository가 lastLocation을 그대로 emit)
- [ ] InfoWindow: "Live Tracking"
- [ ] Live OFF 시 마커가 초록색으로 복귀

### 시나리오 3: Live OFF + Simulation ON

**설정:** Simulation Mode 활성화 → Walking 시나리오 선택 → Start 버튼

**검증:**
- [ ] 마커 색상: 오렌지 (Simulation)
- [ ] 마커가 웨이포인트를 따라 이동
- [ ] 시나리오 라벨 표시: "Simulating: Walking"
- [ ] Pause 버튼으로 이동 일시정지
- [ ] Stop 버튼으로 홈 위치 복귀
- [ ] 시뮬레이션 비활성화 시 초록색 정적 마커로 복귀

### 시나리오 4: Live ON + Simulation ON

**설정:** Live Tracking ON + Simulation Walking + Start

**검증:**
- [ ] 시뮬레이션 위치가 우선 적용 (오렌지 마커)
- [ ] 마커가 웨이포인트를 따라 이동
- [ ] 시뮬레이션 Stop → 라이브 마커(빨강)로 전환
- [ ] 시뮬레이션 비활성화 → 라이브 위치 표시 (빨강)
- [ ] Live도 OFF → 정적 위치 (초록색)

### 공통 검증 항목

- [ ] 포커스 버튼(my_location 아이콘) 클릭 시 현재 마커 위치로 카메라 이동
- [ ] 카메라가 자동으로 마커를 따라가지 않음 (수동 포커스만)
- [ ] 시나리오 전환 시 마커 색상이 올바르게 변경
- [ ] 앱 성능 저하 없이 부드럽게 동작

---

## 코드 분석

```bash
# Dart 분석 실행
flutter analyze lib/

# 결과: info 레벨 경고만 있어야 함 (에러 없음)
```

---

## 빌드 테스트

### macOS Debug Build
```bash
flutter build macos --debug
# 결과: build/macos/Build/Products/Debug/tailinq_app.app 생성
```

### iOS Debug Build (Simulator용)
```bash
flutter build ios --debug --no-codesign --simulator
```

### Android Debug Build
```bash
flutter build apk --debug
# 결과: build/app/outputs/flutter-apk/app-debug.apk 생성
```

---

## 알려진 제한사항

1. **iOS 실제 기기 빌드**: iOS SDK 17.5가 필요하며 Xcode에서 별도 설치 필요
2. **지도**: 현재 Placeholder만 구현 (Google Maps API 키 미설정)
3. **Backend**: Mock 데이터만 사용 (실제 서버 연동 없음)
4. **Activity/Settings**: Placeholder 화면만 구현

---

## 문제 해결

### "flutter: command not found"
Flutter가 PATH에 없는 경우:
```bash
/Users/youchanpark/flutter/bin/flutter run
```

### Freezed 코드 생성 오류
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### iOS 빌드 실패 "iOS 17.5 is not installed"
Xcode > Settings > Components에서 iOS 17.5 플랫폼 설치

### 시뮬레이터/에뮬레이터가 보이지 않음
```bash
# 사용 가능한 모든 디바이스 확인
flutter devices

# macOS로 먼저 테스트
flutter run -d macos
```
