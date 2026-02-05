# Tailinq App MVP - 전체 작업 목록

> 마지막 업데이트: 2026-02-05 (Show Route, Activity, 프로필 편집, 커스텀 마커, 앱 아이콘)

---

## 구현 현황 요약

| 카테고리 | 진행률 | 상태 |
|---------|--------|------|
| 프로젝트 기반 | 100% | ✅ 완료 |
| 인증 시스템 | 85% | 🔄 진행중 |
| 지도 및 위치 | 85% | 🔄 진행중 |
| 펫 관리 | 90% | 🔄 진행중 |
| 디바이스 관리 | 50% | 🔄 진행중 |
| Activity 화면 | 60% | 🔄 진행중 |
| 백엔드 연동 | 0% | ⬜ 대기 |
| 알림 시스템 | 0% | ⬜ 대기 |
| 테스트 및 품질 | 10% | 🔄 진행중 |

---

## 1. 프로젝트 기반 (Foundation)

### ✅ 완료됨
- [x] Flutter 프로젝트 초기 설정
- [x] Clean Architecture 폴더 구조
- [x] Riverpod 상태 관리 설정
- [x] GoRouter 네비게이션 (ShellRoute + Bottom Navigation)
- [x] Material Design 3 테마 (Green 기반, Light Mode)
- [x] Freezed 모델 (Device, Location, User)
- [x] Mock Repository 패턴
- [x] Storage Repository 인터페이스 및 Mock 구현 (S3 연동 준비)

---

## 2. 인증 시스템 (Authentication)

### ✅ 완료됨
- [x] AWS Cognito 연동 (Amplify Flutter)
- [x] 이메일/비밀번호 회원가입
- [x] 이메일 인증 (Confirmation Code)
- [x] 로그인/로그아웃
- [x] 비밀번호 재설정
- [x] 인증 상태 관리 (AuthProvider)
- [x] 라우터 인증 가드 (Protected Routes)
- [x] 소셜 로그인 버튼 UI (Google, Apple)

- [x] **프로필 관리**
  - 프로필 편집 화면 (`/settings/edit-profile`)
  - 이름 변경 (Cognito `updateUserAttributes`)
  - 계정 삭제 (Cognito `deleteUser`)

### ⬜ 추후 작업
- [ ] **Google 로그인 API 연결**
  - `google_sign_in` 패키지 추가
  - Google Cloud Console OAuth 설정
  - Cognito Identity Provider 연결

- [ ] **Apple 로그인 API 연결**
  - `sign_in_with_apple` 패키지 추가
  - Apple Developer 설정
  - Cognito Identity Provider 연결

- [ ] **프로필 이미지 업로드**
  - 프로필 이미지 S3 업로드
  - 이미지 압축/리사이즈

- [ ] **보안 강화**
  - MFA (Multi-Factor Authentication)
  - 생체 인증 (Face ID / Touch ID)
  - 비밀번호 변경 (로그인 상태에서)

---

## 3. 지도 및 위치 (Map & Location)

### ✅ 완료됨
- [x] 마커 표시 (펫 위치)
- [x] Live Mode 토글
- [x] 깜빡이는 LIVE 뱃지
- [x] Mock 위치 스트림 (2초 간격)
- [x] **Google Maps 연동**
  - `google_maps_flutter` 패키지 추가
  - Google Maps API 키 설정
  - Android/iOS/Web 플랫폼별 설정
  - GoogleMap 위젯으로 교체
  - Live Mode 시 카메라 자동 팔로우
  - 마커 색상 변경 (Live: 빨강, 일반: 초록)
- [x] **위치 시뮬레이션 (테스트/데모용)**
  - LocationSimulator 서비스 구현
  - 5개 시나리오: Idle, Walking, Running, Exploring, Returning
  - Waypoint 기반 랜덤 경로 생성
  - SimulationControlPanel UI (DeviceBottomSheet 내)
  - 시뮬레이션 활성화/비활성화, 시작/일시정지/정지
  - Live Mode와 독립적으로 동작
  - 마커 색상 변경 (시뮬레이션: 오렌지)
  - 수동 카메라 포커스 버튼 (my_location)
- [x] **커스텀 마커**
  - 펫 프로필 이미지 마커 (CircleAvatar 기반)
  - 모드별 테두리 색상 (시뮬레이션: 오렌지, 라이브: 빨강, 기본: 초록)
  - 이미지 없을 시 종별 이모지 폴백
- [x] **이동 경로 표시 (Show Route)**
  - Show Route 토글 (Bottom Sheet 내, 파란색 테마)
  - 속도 기반 색상 Polyline (Blue/Green/Yellow/Red)
  - Mock 1시간 산책 히스토리 생성기 (360 포인트, 4단계 시나리오)
  - 실시간 위치 누적 (Live/Simulation 연동)
  - 속도 범례 오버레이 (좌상단)
  - 디바이스 전환 시 경로 자동 초기화/재로드

### ⬜ 추후 작업
- [ ] **마커 클러스터링**
  - 여러 펫/디바이스 동시 표시 시 마커 클러스터링

- [ ] **카메라 컨트롤 개선**
  - 줌 인/아웃 버튼

- [ ] **Geofencing (Safe Zone)**
  - Safe Zone 원형 영역 표시
  - Safe Zone 경계 이탈 감지
  - 이탈 시 알림 트리거

- [ ] **경로 기능 고도화**
  - 경로 히스토리 재생 (타임라인 슬라이더)
  - 날짜/시간 범위 필터
  - 실제 백엔드 위치 데이터 연동 (Mock → API)
  - 경로 위 탭 시 속도/시간 정보 Tooltip

---

## 4. 펫 관리 (Pet Management)

### ✅ 완료됨
- [x] Pet 모델 생성 (id, name, imageUrl, species, breed, birthDate, deviceId)
- [x] PetMember 모델 생성 (User-Pet 다대다 관계, role: owner/family/caretaker)
- [x] Device 모델에서 펫 관련 필드 분리 (name, imageUrl → Pet으로 이동)
- [x] PetRepository 인터페이스 생성
- [x] MockPetRepository 구현
- [x] Pet Provider 생성 (PetNotifier with CRUD operations)
- [x] UI 컴포넌트 업데이트 (DeviceBottomSheet, HomeScreen)
- [x] **펫 프로필 관리**
  - 펫 목록 화면 (`/pets`)
  - 펫 추가 화면 (`/pets/add`)
  - 펫 상세 화면 (`/pets/:id`)
  - 펫 수정 화면 (`/pets/:id/edit`)
  - 펫 삭제 (확인 다이얼로그)
  - 펫 정보 편집 (이름, 종, 품종, 생년월일)
  - 펫 이미지 선택 (카메라/갤러리)
  - Mock Storage (base64 data URL) - S3 연동 준비 완료
- [x] **펫 전환**
  - 여러 펫 지원
  - 펫 선택 UI (Home Tab, Manage Pets 화면)
  - 선택된 펫 상태 관리 (selectedPetIdProvider)
  - 기본 프로필 사진 (종별 이모지: 🐕🐱🐦🐰)
- [x] Settings 화면에 "Manage Pets" 메뉴 추가

### ⬜ 추후 작업
- [ ] **AWS S3 이미지 업로드**
  - `amplify_storage_s3` 패키지 연동
  - MockStorageRepository → S3StorageRepository 교체
  - 이미지 압축/리사이즈

- [ ] **펫 공유 (가족 기능)**
  - 초대 코드 생성
  - 초대 수락/거절
  - 멤버 역할 관리 (owner, family, caretaker)
  - 멤버 목록 조회/삭제

---

## 5. 디바이스 관리 (Device Management)

### ✅ 완료됨
- [x] Device 모델 (id, name, battery, status, location)
- [x] Device Bottom Sheet UI
- [x] 배터리 레벨 표시
- [x] 온라인/오프라인 상태 표시
- [x] Mock 디바이스 데이터 (Max, Bella)
- [x] Home Tab에서 펫 전환 기능 (DeviceBottomSheet)

### ⬜ 추후 작업
- [ ] **디바이스 등록**
  - QR 코드 스캔으로 디바이스 등록
  - 디바이스 이름 설정
  - 펫 프로필 연결

- [ ] **디바이스 설정**
  - 위치 업데이트 주기 설정
  - Safe Zone 반경 설정
  - 저전력 모드 설정

- [ ] **멀티 디바이스**
  - 여러 펫/디바이스 지원
  - 디바이스 전환 UI
  - 디바이스 목록 화면

- [ ] **디바이스 상태 상세**
  - 신호 강도 표시
  - 마지막 통신 시간
  - 펌웨어 버전 확인

---

## 6. Activity 화면 (Activity History)

### ✅ 완료됨
- [x] Activity 화면 Placeholder
- [x] **건강 지표 대시보드**
  - HealthMetric 모델 (Freezed: activity, rest, eating, drinking)
  - MockHealthRepository 구현
  - HealthProvider (선택된 펫 기반 데이터 로드)
  - 건강 지표 카드 UI (HealthMetricCard + Sparkline 차트)
  - 펫 전환 지원 (AppBar 펫 스위처)
- [x] **지표 상세 화면**
  - MetricDetailScreen (지표별 상세 페이지)
  - 7일간 일별 라인 차트 (DetailLineChart)
  - 지표별 아이콘/색상/단위 설정 (MetricConfig)

### ⬜ 추후 작업
- [ ] **이동 기록**
  - 일별 이동 거리
  - 이동 경로 타임라인
  - 날짜별 필터링

- [ ] **활동 통계 고도화**
  - 주/월별 활동량 차트 (현재 7일만)
  - 평균 이동 거리 트렌드
  - 활동 시간대 분석
  - 목표 설정 및 달성률

- [ ] **이벤트 로그**
  - Safe Zone 이탈 기록
  - 배터리 경고 기록
  - 연결 상태 변화 기록

- [ ] **백엔드 연동**
  - MockHealthRepository → API 교체
  - 실시간 건강 데이터 수집

---

## 7. 백엔드 연동 (Backend Integration)

### ⬜ 추후 작업
- [ ] **API 클라이언트 설정**
  - Dio 또는 http 패키지
  - 인증 토큰 인터셉터
  - 에러 핸들링

- [ ] **디바이스 API**
  - GET /devices - 디바이스 목록
  - GET /devices/{id} - 디바이스 상세
  - POST /devices - 디바이스 등록
  - PUT /devices/{id} - 디바이스 업데이트
  - DELETE /devices/{id} - 디바이스 삭제

- [ ] **위치 API**
  - GET /devices/{id}/locations - 위치 히스토리
  - WebSocket 실시간 위치 스트림

- [ ] **사용자 API**
  - GET /users/me - 내 정보
  - PUT /users/me - 프로필 업데이트

- [ ] **펫 API**
  - GET /pets - 펫 목록
  - GET /pets/{id} - 펫 상세
  - POST /pets - 펫 등록
  - PUT /pets/{id} - 펫 업데이트
  - DELETE /pets/{id} - 펫 삭제
  - POST /pets/{id}/image - 이미지 업로드

- [ ] **Repository 교체**
  - MockDeviceRepository → ApiDeviceRepository
  - MockPetRepository → ApiPetRepository
  - MockStorageRepository → S3StorageRepository
  - 환경별 설정 (dev/staging/prod)

---

## 8. 알림 시스템 (Notifications)

### ⬜ 추후 작업
- [ ] **로컬 알림**
  - `flutter_local_notifications` 패키지
  - Geofence 이탈 알림
  - 저전력 경고 알림

- [ ] **푸시 알림**
  - Firebase Cloud Messaging (FCM)
  - AWS SNS / Pinpoint
  - 알림 권한 요청

- [ ] **알림 설정**
  - 알림 유형별 ON/OFF
  - 방해 금지 시간대 설정
  - 알림 히스토리

---

## 9. 테스트 및 품질 (Testing & Quality)

### ✅ 완료됨
- [x] **단위 테스트**
  - [x] LocationSimulator 단위 테스트
  - [x] MockDeviceRepository 단위 테스트
  - [x] MockDataSource 단위 테스트
  - [x] SimulationProvider 단위 테스트

### ⬜ 추후 작업
- [ ] **단위 테스트 추가**
  - PetRepository 테스트
  - PetProvider 테스트
  - AuthProvider 테스트
  - Model 직렬화 테스트

- [ ] **위젯 테스트**
  - 화면별 위젯 테스트
  - 인터랙션 테스트

- [ ] **통합 테스트**
  - E2E 테스트 시나리오
  - 인증 플로우 테스트

- [ ] **코드 품질**
  - Lint 규칙 강화
  - 코드 커버리지 측정

---

## 우선순위 작업 순서 (권장)

### Phase 1: 핵심 기능 완성
1. ~~Google Maps 연동~~ ✅
2. ~~펫 프로필 관리~~ ✅
3. ~~펫 전환 기능~~ ✅
4. ~~위치 시뮬레이션~~ ✅
5. ~~커스텀 마커~~ ✅
6. ~~이동 경로 표시~~ ✅
7. ~~Activity 건강 지표~~ ✅
8. ~~프로필 편집~~ ✅
9. Geofencing 구현

### Phase 2: 백엔드 연동
6. API 클라이언트 설정
7. 디바이스/위치/펫 API 연동
8. Mock Repository 교체
9. S3 이미지 업로드 연동

### Phase 3: 사용자 경험 향상
10. Activity 화면 구현
11. 알림 시스템 구현
12. 소셜 로그인 연동

### Phase 4: 완성도 향상
13. 사용자 프로필 관리
14. 디바이스 설정
15. 펫 공유 (가족 기능)
16. ~~테스트 코드 작성~~ 🔄 진행중

---

## 최근 완료된 작업 (2026-02-05 #2)

### 이동 경로 표시 (Show Route) 기능
- Show Route 토글: Bottom Sheet의 Live Tracking 아래에 추가 (파란색 테마)
- 속도 기반 색상 Polyline: 4단계 (< 0.5 Blue, 0.5–1.5 Green, 1.5–3.0 Yellow, > 3.0 Red)
- Mock 1시간 산책 히스토리 생성기: 360 포인트, 4단계 시나리오 (대기→산책→달리기→귀가)
- 실시간 위치 누적: Live/Simulation 중 새 포인트 자동 추가
- 속도 범례 오버레이: 지도 좌상단

**새로 생성된 파일:**
- `lib/domain/models/route_point.dart` — RoutePoint 모델 (location + speedMps)
- `lib/data/services/route_history_generator.dart` — Mock 경로 생성기
- `lib/presentation/utils/polyline_builder.dart` — 속도 기반 Polyline 배칭 유틸리티
- `lib/presentation/providers/route_provider.dart` — showRoute, routePoints, routePolylines Provider
- `lib/presentation/widgets/route_toggle.dart` — Show Route 토글 위젯
- `lib/presentation/widgets/speed_legend_overlay.dart` — 속도 범례 오버레이

**수정된 파일:**
- `lib/core/constants/app_constants.dart` — 속도 임계값, 경로 히스토리 설정 추가
- `lib/presentation/widgets/device_bottom_sheet.dart` — RouteToggle 삽입
- `lib/presentation/screens/home/home_screen.dart` — Polyline + SpeedLegend 연동

### Activity 건강 지표 대시보드
- HealthMetric Freezed 모델 (activity, rest, eating, drinking)
- MockHealthRepository + HealthProvider
- 건강 지표 카드 (Sparkline 차트 포함)
- 지표 상세 화면 (7일간 라인 차트)

### 커스텀 마커
- 펫 이미지/이모지 CircleAvatar 마커
- 모드별 테두리 색상 (시뮬레이션: 오렌지, 라이브: 빨강, 기본: 초록)

### 프로필 편집 & 계정 관리
- EditProfileScreen (이름 변경)
- Cognito updateUserAttributes / deleteUser 연동

### 앱 아이콘 교체
- Android/iOS/macOS 플랫폼별 새 앱 아이콘 적용

---

## 최근 완료된 작업 (2026-02-05 #1)

### 위치 시뮬레이션 / 라이브 트래킹 아키텍처 수정
- 순환 참조 제거 (`simulationLocationStreamProvider`)
- 역할 분리 (시뮬레이션 ↔ 라이브 트래킹)
- Repository에서 simulator 통합 제거
- Live Mode가 좌표를 변조하지 않도록 수정
- 디버그 print 제거

**수정된 파일:**
- `lib/data/repositories/mock_device_repository.dart` — 좌표 변조 제거, 순수 lastLocation emit
- `lib/presentation/providers/simulation_provider.dart` — 순환 참조 없는 스트림 구조
- `lib/presentation/providers/location_provider.dart` — 시뮬레이션/라이브 스트림 분리
- `lib/presentation/providers/device_provider.dart` — simulator 참조 제거
- `lib/presentation/screens/home/home_screen.dart` — 마커 색상/위치 우선순위 로직

### Unit Test 작성
- `test/data/services/location_simulator_test.dart` — 시뮬레이터 핵심 로직 검증
- `test/data/repositories/mock_device_repository_test.dart` — Repository 동작 검증
- `test/data/sources/mock_data_source_test.dart` — Mock 데이터 검증
- `test/presentation/providers/simulation_provider_test.dart` — Provider 상태 관리 검증

---

## 최근 완료된 작업 (2026-02-04)

### 위치 시뮬레이션 기능 구현
- **새로 생성된 파일:**
  - `lib/data/services/location_simulator.dart` - 시뮬레이션 엔진
  - `lib/presentation/providers/simulation_provider.dart` - 시뮬레이션 상태 관리
  - `lib/presentation/widgets/simulation_control_panel.dart` - 시뮬레이션 UI

- **수정된 파일:**
  - `lib/presentation/screens/home/home_screen.dart` - 시뮬레이션 마커 표시, 수동 포커스 버튼
  - `lib/presentation/providers/location_provider.dart` - 시뮬레이션 스트림 연동
  - `lib/presentation/providers/device_provider.dart` - 시뮬레이터 연결
  - `lib/data/repositories/mock_device_repository.dart` - 시뮬레이터 통합
  - `lib/presentation/widgets/device_bottom_sheet.dart` - SimulationControlPanel 추가

### 펫 프로필 관리 기능 구현
- **새로 생성된 파일:**
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

- **수정된 파일:**
  - `pubspec.yaml` - image_picker, uuid 패키지 추가
  - `lib/presentation/router/app_router.dart` - Pet 라우트 추가
  - `lib/presentation/providers/pet_provider.dart` - PetNotifier 추가
  - `lib/presentation/screens/settings/settings_screen.dart` - Manage Pets 메뉴
  - `lib/presentation/widgets/device_bottom_sheet.dart` - 기본 아바타, 펫 전환

---

## 참고 문서

| 문서 | 설명 |
|------|------|
| `docs/tailinq_app_mvp.md` | MVP 요구사항 정의 |
| `docs/IMPLEMENTATION.md` | 구현 상세 문서 |
| `docs/TESTING.md` | 테스트 가이드 |
| `docs/API_SETUP.md` | API 키 설정 가이드 |
| `CLAUDE.md` | Claude Code 가이드 |
