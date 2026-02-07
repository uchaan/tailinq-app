# Getting Started

A step-by-step guide to build and run the Tailinq app on your device.

---

## Prerequisites

Before you begin, make sure you have the following installed:

| Tool | Version | Download |
|------|---------|----------|
| Flutter SDK | 3.10+ | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| Dart SDK | 3.10+ | Included with Flutter |
| Xcode | Latest | App Store (required for iOS/macOS) |
| Android Studio | Latest | [developer.android.com/studio](https://developer.android.com/studio) |
| Git | Any | [git-scm.com](https://git-scm.com/) |

> **Tip**: Run `flutter doctor` to verify your environment is set up correctly.

### Platform Requirements

| Platform | Minimum Version |
|----------|----------------|
| Android | API 21 (Android 5.0) |
| iOS | 14.0 |
| macOS | 10.15 (Catalina) |
| Web | Any modern browser |

---

## Step 1: Clone the Repository

```bash
git clone https://github.com/uchaan/tailinq-app.git
cd tailinq-app
```

---

## Step 2: Install Dependencies

```bash
flutter pub get
```

---

## Step 3: Set Up API Keys

The app requires two external services: **Google Maps** and **AWS Cognito**. Configuration files containing API keys are not included in the repository for security reasons. You need to create them from the provided `.example` templates.

### 3-1. Google Maps API Key

You need a Google Maps API key to display maps in the app.

**How to get a key:**

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or select an existing one)
3. Go to **APIs & Services > Library** and enable these APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Maps JavaScript API** (for web)
4. Go to **APIs & Services > Credentials**
5. Click **Create Credentials > API Key**
6. Copy the generated key

> For detailed instructions, see [docs/SETUP.md](SETUP.md#1-google-maps-api).

### 3-2. AWS Cognito (Authentication)

The app uses AWS Cognito for user authentication (sign-up, sign-in, password reset).

**How to set up:**

1. Go to [AWS Console](https://console.aws.amazon.com/) > Cognito
2. Click **Create user pool**
3. Configure:
   - Sign-in: **Email**
   - Password policy: 8+ characters with uppercase, lowercase, numbers, special characters
   - MFA: **No MFA** (for development)
   - Email delivery: **Send email with Cognito**
4. Create an **App Client**:
   - Type: **Public client**
   - Client secret: **Don't generate**
   - Auth flows: **ALLOW_USER_SRP_AUTH**
5. Note down your **User Pool ID**, **App Client ID**, and **Region**

> For detailed instructions, see [docs/SETUP.md](SETUP.md#2-aws-cognito).

### 3-3. Create Configuration Files

Copy the example files and replace the placeholder values with your actual keys:

```bash
# 1. AWS Cognito configuration
cp lib/amplifyconfiguration.dart.example lib/amplifyconfiguration.dart
```

Edit `lib/amplifyconfiguration.dart` and replace:
- `YOUR_COGNITO_POOL_ID` → your User Pool ID (e.g., `ap-northeast-2_XXXXXXXXX`)
- `YOUR_APP_CLIENT_ID` → your App Client ID
- Update `Region` if needed

```bash
# 2. Android - Google Maps API key
cp android/app/src/main/AndroidManifest.xml.example android/app/src/main/AndroidManifest.xml
```

Edit `android/app/src/main/AndroidManifest.xml` and replace:
- `YOUR_GOOGLE_MAPS_API_KEY` → your Google Maps API key

```bash
# 3. iOS - Google Maps API key
cp ios/Runner/AppDelegate.swift.example ios/Runner/AppDelegate.swift
```

Edit `ios/Runner/AppDelegate.swift` and replace:
- `YOUR_GOOGLE_MAPS_API_KEY` → your Google Maps API key

### 3-4. Checklist

Make sure all three files are created and configured:

- [ ] `lib/amplifyconfiguration.dart` — Cognito Pool ID + App Client ID
- [ ] `android/app/src/main/AndroidManifest.xml` — Google Maps API key
- [ ] `ios/Runner/AppDelegate.swift` — Google Maps API key

---

## Step 4: Generate Code

The project uses [Freezed](https://pub.dev/packages/freezed) for immutable data models. You must run code generation before the first build:

```bash
dart run build_runner build --delete-conflicting-outputs
```

> You'll need to run this command again whenever you modify model files in `lib/data/models/`.

---

## Step 5: Run the App

### macOS (fastest for development)

```bash
flutter run -d macos
```

### iOS Simulator

```bash
# List available devices
flutter devices

# Run on iOS simulator
flutter run -d <simulator-id>
```

> **Note**: If you're building for a physical iOS device, you need to set up code signing in Xcode. Open `ios/Runner.xcworkspace` and configure your development team under **Signing & Capabilities**.

### Android Emulator

```bash
# Make sure an emulator is running (via Android Studio)
flutter run -d <emulator-id>
```

### Web (Chrome)

```bash
flutter run -d chrome
```

---

## Step 6: Create an Account

Once the app launches, you'll see the sign-in screen:

1. Tap **Sign Up** to create a new account
2. Enter your email and password
3. Check your email for a **verification code**
4. Enter the code to confirm your account
5. Sign in with your credentials

---

## Building for Release

### Android APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS

```bash
# Open in Xcode for archive & distribution
open ios/Runner.xcworkspace
```

Then in Xcode: **Product > Archive**

### macOS

```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/tailinq_app.app
```

---

## Troubleshooting

### `flutter: command not found`

Flutter is not in your PATH. Add it:

```bash
export PATH="$PATH:/path/to/flutter/bin"
```

Or run Flutter directly:

```bash
/path/to/flutter/bin/flutter run
```

### Freezed code generation errors

Clean and regenerate:

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### iOS build fails with "iOS 17.5 is not installed"

Open Xcode, go to **Settings > Components** (or **Platforms**), and install the required iOS version.

### `ApiNotActivatedMapError` on web

The Maps JavaScript API is not enabled in your Google Cloud project. Go to **APIs & Services > Library** and enable it.

### Android build fails with Gradle errors

Make sure you have Java 17 installed and configured:

```bash
java -version  # Should show 17.x
```

Android Studio > **Settings > Build Tools > Gradle** > set Gradle JDK to 17.

### No devices found

```bash
# Check all connected/available devices
flutter devices

# For iOS, make sure a simulator is booted
open -a Simulator

# For Android, launch an emulator from Android Studio
```

---

## What's Next?

- Read [ARCHITECTURE.md](ARCHITECTURE.md) to understand the codebase structure
- Read [TESTING.md](TESTING.md) for running tests and manual test checklists
- Read [ROADMAP.md](ROADMAP.md) for current progress and planned features
