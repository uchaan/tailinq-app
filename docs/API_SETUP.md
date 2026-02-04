# API 설정 가이드

> 이 문서는 Tailinq App에서 사용하는 외부 API 설정 방법을 설명합니다.
> 계정 변경 시 이 문서를 참고하여 설정하세요.

---

## 1. Google Maps API

### 1.1 API 키 발급

1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. 프로젝트 생성 또는 선택
3. **APIs & Services > Credentials** 메뉴 이동
4. **Create Credentials > API Key** 클릭
5. 생성된 API 키 복사

### 1.2 필수 API 활성화

**APIs & Services > Library**에서 다음 API들을 활성화해야 합니다:

| API 이름 | 용도 | 필수 |
|---------|------|------|
| **Maps JavaScript API** | 웹에서 Google Maps 표시 | ✅ |
| **Maps SDK for Android** | Android 앱에서 Google Maps 표시 | ✅ |
| **Maps SDK for iOS** | iOS 앱에서 Google Maps 표시 | ✅ |

### 1.3 API 키 적용 위치

API 키를 다음 파일들에 적용합니다:

#### Android
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY"/>
```

#### iOS
```swift
// ios/Runner/AppDelegate.swift
GMSServices.provideAPIKey("YOUR_API_KEY")
```

#### Web
```html
<!-- web/index.html -->
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>
```

### 1.4 흔한 에러 및 해결

| 에러 | 원인 | 해결 |
|------|------|------|
| `ApiNotActivatedMapError` | Maps JavaScript API가 비활성화됨 | Google Cloud Console에서 Maps JavaScript API 활성화 |
| `InvalidKeyMapError` | API 키가 잘못됨 | API 키 확인 및 재발급 |
| `RefererNotAllowedMapError` | 도메인이 허용되지 않음 | API 키 제한 설정에서 도메인 추가 |

### 1.5 API 키 제한 설정 (권장)

보안을 위해 API 키에 제한을 설정하세요:

1. **Application restrictions**
   - Android: 패키지명 + SHA-1 지문
   - iOS: 번들 ID
   - Web: HTTP 리퍼러 (예: `localhost/*`, `*.yourdomain.com/*`)

2. **API restrictions**
   - 사용할 API만 선택 (Maps JavaScript API, Maps SDK for Android, Maps SDK for iOS)

---

## 2. AWS Cognito

### 2.1 User Pool 생성

1. [AWS Console](https://console.aws.amazon.com/) > Cognito 서비스
2. **Create user pool** 클릭
3. 설정:
   - Sign-in options: **Email**
   - Password policy: 8자 이상, 대소문자/숫자/특수문자
   - MFA: **No MFA** (MVP용)
   - Email: **Send email with Cognito**

### 2.2 App Client 생성

1. User Pool 선택 > **App integration** 탭
2. **Create app client**
3. 설정:
   - App type: **Public client**
   - Client secret: **Don't generate**
   - Auth flows: **ALLOW_USER_SRP_AUTH**

### 2.3 설정 값 적용

```dart
// lib/amplifyconfiguration.dart
const amplifyconfig = '''{
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "YOUR_USER_POOL_ID",
                        "AppClientId": "YOUR_APP_CLIENT_ID",
                        "Region": "ap-northeast-2"
                    }
                }
            }
        }
    }
}''';
```

### 2.4 현재 설정 값

| 항목 | 값 |
|------|-----|
| Region | ap-northeast-2 (서울) |
| User Pool ID | ap-northeast-2_4cNPZ8Ppf |
| App Client ID | 227li53a3rdf98kfb7eu3i16gh |

---

## 3. 체크리스트

새 계정/프로젝트로 변경 시:

- [ ] Google Cloud 프로젝트 생성
- [ ] Google Maps API 키 발급
- [ ] Maps JavaScript API 활성화
- [ ] Maps SDK for Android 활성화
- [ ] Maps SDK for iOS 활성화
- [ ] API 키를 Android/iOS/Web 설정 파일에 적용
- [ ] AWS Cognito User Pool 생성
- [ ] AWS Cognito App Client 생성
- [ ] amplifyconfiguration.dart 업데이트

---

## 4. 현재 사용 중인 API 키

> ⚠️ **주의**: 프로덕션에서는 이 값들을 환경 변수로 관리하세요.

| 서비스 | 키 |
|--------|-----|
| Google Maps | `AIzaSyAeVc1Xm5UHxNIeCxpQ3Oa1pvGAx1TacGM` |
| Cognito User Pool | `ap-northeast-2_4cNPZ8Ppf` |
| Cognito App Client | `227li53a3rdf98kfb7eu3i16gh` |
