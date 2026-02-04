# AWS Cognito 인증 기능 - 추후 작업 목록

## 1차 구현 완료 (2026-02-04)

- [x] 이메일/비밀번호 기반 회원가입 및 로그인
- [x] 이메일 인증
- [x] 비밀번호 재설정
- [x] Google/Apple 로그인 UI (버튼만)

---

## 추후 작업

### 소셜 로그인 API 연결

- [ ] **Google 로그인 구현**
  - `google_sign_in` 패키지 추가
  - Google Cloud Console에서 OAuth 클라이언트 ID 설정
  - Cognito User Pool에 Google Identity Provider 연결
  - `CognitoAuthRepository`에 `signInWithGoogle()` 메서드 구현

- [ ] **Apple 로그인 구현**
  - `sign_in_with_apple` 패키지 추가
  - Apple Developer에서 Sign in with Apple 설정
  - Cognito User Pool에 Apple Identity Provider 연결
  - `CognitoAuthRepository`에 `signInWithApple()` 메서드 구현

### 프로필 관리

- [ ] **프로필 편집 기능**
  - 프로필 편집 화면 생성 (`lib/presentation/screens/auth/edit_profile_screen.dart`)
  - 이름 변경 기능
  - 프로필 이미지 업로드 (S3 연동 필요)

- [ ] **비밀번호 변경 기능**
  - 현재 비밀번호 확인 후 새 비밀번호 설정
  - Settings 화면에서 접근

### 계정 관리

- [ ] **계정 삭제 기능**
  - 사용자 데이터 삭제 정책 정의
  - 삭제 확인 다이얼로그
  - Cognito 사용자 삭제 API 연결

- [ ] **세션 관리**
  - 토큰 자동 갱신
  - 다중 디바이스 로그인 관리

### 보안 강화

- [ ] **MFA (Multi-Factor Authentication)**
  - SMS 또는 TOTP 기반 2단계 인증
  - Settings에서 MFA 활성화/비활성화

- [ ] **생체 인증**
  - Face ID / Touch ID 지원
  - `local_auth` 패키지 사용

### UX 개선

- [ ] **자동 로그인**
  - 앱 시작 시 저장된 세션으로 자동 로그인
  - "로그인 상태 유지" 옵션

- [ ] **로딩 상태 개선**
  - 스플래시 화면에서 인증 상태 확인
  - Skeleton UI 적용

---

## 참고 파일

| 파일 | 설명 |
|------|------|
| `lib/domain/repositories/auth_repository.dart` | 인증 저장소 인터페이스 |
| `lib/data/repositories/cognito_auth_repository.dart` | Cognito 구현체 |
| `lib/presentation/providers/auth_provider.dart` | 인증 상태 관리 |
| `lib/amplifyconfiguration.dart` | Amplify 설정 |
