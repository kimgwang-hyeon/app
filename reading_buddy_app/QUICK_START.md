# Quick Start Guide - Reading Buddy App

Flutter 초보자를 위한 빠른 시작 가이드입니다.

## 1. 필수 준비사항

### Windows 사용자

1. **Flutter 설치**
   - https://docs.flutter.dev/get-started/install/windows 접속
   - Flutter SDK 다운로드 및 설치
   - 환경 변수 설정 (PATH에 flutter/bin 추가)

2. **Android Studio 설치**
   - https://developer.android.com/studio 에서 다운로드
   - Android SDK 자동 설치됨
   - Android Virtual Device (AVD) 생성

3. **Visual Studio Code 설치 (선택사항)**
   - https://code.visualstudio.com/
   - Flutter 확장 프로그램 설치

### macOS 사용자

1. **Flutter 설치**
   ```bash
   # Homebrew로 설치
   brew install flutter
   ```

2. **Xcode 설치** (iOS 개발용)
   - App Store에서 Xcode 설치
   - Command Line Tools 설치

3. **Android Studio 설치** (Android 개발용)

## 2. Flutter 설치 확인

터미널/명령 프롬프트에서 실행:

```bash
flutter doctor
```

모든 항목이 체크되어야 합니다. 문제가 있으면 안내에 따라 해결하세요.

## 3. 프로젝트 설정

### 3.1. 패키지 설치

```bash
cd c:\Users\kyn05\Desktop\어플\app\reading_buddy_app
flutter pub get
```

### 3.2. 코드 생성

Retrofit과 JSON Serialization을 위한 코드 생성:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

이 명령어는 다음 파일들을 자동 생성합니다:
- `*.g.dart` 파일들 (JSON Serialization)
- `api_client.g.dart` (Retrofit)

### 3.3. 서버 URL 설정

`lib/core/constants/api_constants.dart` 파일을 열고 서버 주소를 변경하세요:

```dart
static const String baseUrl = 'http://your-server-url.com';
// 예: 'http://192.168.0.100:8080' (로컬 테스트)
// 예: 'https://api.readingbuddy.com' (실제 서버)
```

## 4. 앱 실행

### 4.1. 기기/에뮬레이터 실행

**Android 에뮬레이터:**
```bash
# Android Studio에서 AVD Manager를 통해 에뮬레이터 실행
# 또는 터미널에서:
flutter emulators --launch <emulator-id>
```

**iOS 시뮬레이터 (macOS만 가능):**
```bash
open -a Simulator
```

**실제 기기:**
- Android: USB 디버깅 활성화
- iOS: Xcode에서 개발자 인증 설정

### 4.2. 연결된 기기 확인

```bash
flutter devices
```

### 4.3. 앱 실행

```bash
flutter run
```

또는 특정 기기 선택:

```bash
flutter run -d <device-id>
```

## 5. 개발 중 주의사항

### Hot Reload 활용

앱 실행 중 코드 수정 후:
- **`r`** 키: Hot Reload (빠른 새로고침)
- **`R`** 키: Hot Restart (완전 재시작)
- **`q`** 키: 앱 종료

### 자주 사용하는 명령어

```bash
# 패키지 업데이트
flutter pub upgrade

# 캐시 정리
flutter clean

# 코드 생성 (모델 수정 시)
flutter pub run build_runner build --delete-conflicting-outputs

# 로그 확인
flutter logs
```

## 6. 테스트 계정

### 서버가 준비되었을 때

개발 중 테스트용 계정을 만들어 사용하세요:

```
이메일: test@example.com
비밀번호: test1234
닉네임: 테스터
```

### VR 기기 테스트

1. VR 기기에서 "앱으로 로그인" 선택
2. 10자리 코드 표시됨
3. 앱에서 VR 기기 연결 메뉴 선택
4. 코드 입력 후 인증

## 7. 문제 해결

### 문제: Flutter command not found
**해결:** PATH 환경 변수에 Flutter SDK 경로 추가

### 문제: 패키지 설치 오류
```bash
flutter pub cache repair
flutter clean
flutter pub get
```

### 문제: Android 라이선스 동의
```bash
flutter doctor --android-licenses
```

### 문제: Xcode 설정 (macOS)
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

### 문제: 빌드 오류 (*.g.dart 관련)
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### 문제: SecureStorage 오류 (Android)
`android/app/build.gradle`에서 minSdkVersion을 18 이상으로 설정:
```gradle
minSdkVersion 18
```

## 8. 개발 팁

### VS Code 확장 프로그램
- Flutter
- Dart
- Flutter Widget Snippets
- Error Lens

### 유용한 단축키 (VS Code)
- `Ctrl/Cmd + Space`: 자동 완성
- `F2`: 이름 변경 (Refactor)
- `Ctrl/Cmd + .`: Quick Fix
- `Ctrl/Cmd + Shift + P`: Command Palette

### 디버깅
- VS Code에서 F5로 디버그 모드 실행
- Breakpoint 설정 가능
- DevTools에서 위젯 트리, 네트워크 확인

## 9. 다음 단계

1. **로그인 테스트**: 로그인 화면에서 회원가입 → 로그인 시도
2. **VR 기기 연결**: VR 기기와 연동 테스트
3. **대시보드 확인**: 메인 화면에서 각 탭 이동
4. **API 연동**: 백엔드 서버와 실제 데이터 연동

## 10. 추가 학습 자료

- **Flutter 공식 문서**: https://docs.flutter.dev/
- **Riverpod 문서**: https://riverpod.dev/
- **Dio 문서**: https://pub.dev/packages/dio
- **Flutter 커뮤니티**: https://flutter.dev/community

---

**Happy Coding! 🚀**
