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
# 결과: build/macos/Build/Products/Debug/tailinq_mobile.app 생성
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
