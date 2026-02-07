# API Setup Guide

> This document explains how to set up the external APIs used in the Tailinq App.
> Refer to this document when changing accounts.

---

## 1. Google Maps API

### 1.1 Obtaining an API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create or select a project
3. Navigate to **APIs & Services > Credentials**
4. Click **Create Credentials > API Key**
5. Copy the generated API key

### 1.2 Required API Activation

The following APIs must be enabled under **APIs & Services > Library**:

| API Name | Purpose | Required |
|---------|------|------|
| **Maps JavaScript API** | Display Google Maps on web | ✅ |
| **Maps SDK for Android** | Display Google Maps in Android app | ✅ |
| **Maps SDK for iOS** | Display Google Maps in iOS app | ✅ |

### 1.3 API Key Application Locations

Apply the API key to the following files:

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

### 1.4 Common Errors and Solutions

| Error | Cause | Solution |
|------|------|------|
| `ApiNotActivatedMapError` | Maps JavaScript API is disabled | Enable Maps JavaScript API in Google Cloud Console |
| `InvalidKeyMapError` | API key is invalid | Verify API key and reissue if needed |
| `RefererNotAllowedMapError` | Domain is not allowed | Add domain in API key restriction settings |

### 1.5 API Key Restriction Settings (Recommended)

For security, set restrictions on your API key:

1. **Application restrictions**
   - Android: Package name + SHA-1 fingerprint
   - iOS: Bundle ID
   - Web: HTTP referrers (e.g., `localhost/*`, `*.yourdomain.com/*`)

2. **API restrictions**
   - Select only the APIs you use (Maps JavaScript API, Maps SDK for Android, Maps SDK for iOS)

---

## 2. AWS Cognito

### 2.1 Creating a User Pool

1. Go to [AWS Console](https://console.aws.amazon.com/) > Cognito service
2. Click **Create user pool**
3. Settings:
   - Sign-in options: **Email**
   - Password policy: 8+ characters, uppercase/lowercase/numbers/special characters
   - MFA: **No MFA** (for MVP)
   - Email: **Send email with Cognito**

### 2.2 Creating an App Client

1. Select User Pool > **App integration** tab
2. **Create app client**
3. Settings:
   - App type: **Public client**
   - Client secret: **Don't generate**
   - Auth flows: **ALLOW_USER_SRP_AUTH**

### 2.3 Applying Configuration Values

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

### 2.4 Current Configuration Values

| Item | Value |
|------|-----|
| Region | ap-northeast-2 (Seoul) |
| User Pool ID | ap-northeast-2_4cNPZ8Ppf |
| App Client ID | 227li53a3rdf98kfb7eu3i16gh |

---

## 3. Checklist

When changing to a new account/project:

- [ ] Create Google Cloud project
- [ ] Issue Google Maps API key
- [ ] Enable Maps JavaScript API
- [ ] Enable Maps SDK for Android
- [ ] Enable Maps SDK for iOS
- [ ] Apply API key to Android/iOS/Web configuration files
- [ ] Create AWS Cognito User Pool
- [ ] Create AWS Cognito App Client
- [ ] Update amplifyconfiguration.dart

---

## 4. Currently Used API Keys

> ⚠️ **Warning**: In production, manage these values with environment variables.

| Service | Key |
|--------|-----|
| Google Maps | `AIzaSyAeVc1Xm5UHxNIeCxpQ3Oa1pvGAx1TacGM` |
| Cognito User Pool | `ap-northeast-2_4cNPZ8Ppf` |
| Cognito App Client | `227li53a3rdf98kfb7eu3i16gh` |
