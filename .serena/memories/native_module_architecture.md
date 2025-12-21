# Native Module Architecture

## Sesame Native Module 概要
カスタムReact Nativeネイティブモジュール `sesame-native` でSesameスマートロックとのBLE通信を実装。

### モジュール構成
```
modules/sesame-native/
├── src/                   # TypeScript インターフェース
│   └── index.ts          # JavaScript ブリッジ定義
├── android/              # Kotlin 実装
│   └── .../sesamenative/
│       ├── SesameNativeModule.kt      # React Native ブリッジ
│       ├── SesameDeviceManager.kt     # BLE 操作
│       ├── SesameDeviceStorage.kt     # デバイス永続化
│       └── SesameQRParser.kt         # QR コード解析
└── ios/                  # Objective-C 実装（基本構造のみ）
```

## 主要API メソッド
```typescript
// 初期化
initialize()                        // 基本 SDK 初期化
initializeWithAutoConnect()         // 初期化 + 保存済みデバイス再接続

// デバイス管理
registerByQRCode(qrString)         // QR 解析・デバイス登録
connectStoredDevice(uuid)          // 保存済みデバイス接続
lock(sessionId) / unlock(sessionId) // 制御操作
listConnected()                     // アクティブ接続一覧
getStoredDevices()                  // 登録済みデバイス一覧
```

## セッション管理
- デバイス接続ごとに一意のセッションID生成
- 複数デバイス同時接続対応
- セッションIDで制御コマンド実行
- 明示的切断まで持続

## UUID マッチング戦略
デバイス発見時の複数フォールバック戦略：
1. 完全一致（大文字小文字無視）
2. ハイフンなしUUID一致
3. 特殊UUID フォーマット正規化
4. 接頭辞マッチング（最初24文字）

## セキュリティ考慮事項
- QR コードに暗号化認証データ含有
- ECDH鍵交換による安全なペアリング
- SQLite でのデバイス認証情報保存
- セッションID による不正アクセス防止
- 接続ごとのセッションID ローテーション

## Android 権限要件
```xml
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

## デバッグ・トラブルシューティング
- 全ネイティブメソッドに try-catch 実装
- JavaScript インターフェースで全呼び出しログ出力
- 接続状態の適切なリセット処理
- BLE 操作のタイムアウト処理

## 共通問題と解決策
### モジュール読み込みエラー
- 開発ビルド使用確認（Expo Go 不可）
- NativeModules で SesameNative 存在確認
- MainApplication.kt でモジュール登録確認

### BLE 接続問題
- Bluetooth 権限全て許可確認
- 位置情報サービス有効確認（Android 要件）
- デバイス範囲内（10m以内）・ペアリングモード確認
- UUID マッチングログ確認