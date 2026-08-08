---
paths:
  - "**/*.{kt,kts}"
  - "**/*.gradle"
  - "**/AndroidManifest.xml"
---

# Android開発環境

Android SDKのパス: `~/Library/Android/sdk`

## エミュレータ操作

```bash
~/Library/Android/sdk/emulator/emulator -avd test_device &   # 起動
~/Library/Android/sdk/emulator/emulator -list-avds           # AVD一覧
adb devices                                                  # デバイス確認
pkill -f emulator                                            # 停止
```

AVD作成が必要な場合:

```bash
$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager create avd \
  -n device_name \
  -k "system-images;android-34;google_apis;arm64-v8a"
```

## APK

```bash
adb install your-app.apk
adb uninstall com.example.package
```

## Gradle

```bash
./gradlew build
./gradlew assembleDebug                      # デバッグAPK
./gradlew assembleRelease                    # リリースAPK
./gradlew :apps:<module>:assembleDebug       # 特定モジュール
```
