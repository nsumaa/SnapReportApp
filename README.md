# SnapReport App (Flutter)

A Flutter app that lets users:
- Register/Login using Firebase Authentication.
- Capture multiple images with the camera.
- Add descriptions for each image.
- Generate a PDF report (images + descriptions).
- View, delete, and share older reports.

---

## Setup

1. Install Flutter SDK.
2. Clone this repository:
   ```bash
   git clone https://github.com/nsumaa/report-app.git
   cd report-app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Configure Firebase:
   - Go to Firebase Console, create a project.
   - Add an Android app with the same package name as your app.
   - Download **google-services.json** and place it in `android/app/`.
   - (For iOS) Download **GoogleService-Info.plist** and place it in `ios/Runner/`.
   - Update `android/build.gradle` and `android/app/build.gradle` with Firebase configs.

---

## Run the App
```bash
flutter run
```

---

## Build APK

To generate a release APK:

```bash
flutter build apk --release
```

The APK will be located at:

```
build/app/outputs/flutter-apk/app-release.apk
```