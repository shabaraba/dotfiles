# 設計パターンとアーキテクチャ

このファイルは、新規実装・機能追加時の設計基準とパターンを定義します。

## ファイル分割の基本方針

- **1ファイル100行程度**: 最大でも200行を超えないこと
- **単一責任の原則**: 1つのクラス/モジュールは1つの責任のみを持つ
- **高凝集性**: 関連する機能は同じモジュールに、無関係な機能は別モジュールに

## 必須の設計パターン

### 1. Manager系クラスの分割

大規模なManagerクラスは以下のパターンで分割：

```typescript
// ❌ 悪い例：全機能を1つのManagerに
class GameManager {
  // 状態管理、ロジック処理、通信、UIすべて混在
}

// ✅ 良い例：責務ごとに分割
class GameManager {
  private stateManager: GameStateManager;
  private logicProcessor: GameLogicProcessor;
  private networkHandler: NetworkHandler;
}
```

### 2. Factory系の実装

オブジェクト生成は個別のCreatorに委譲：

```typescript
// ❌ 悪い例：Factoryに全ロジック
class MeshFactory {
  createTypeA() { /* 50行のロジック */ }
  createTypeB() { /* 80行のロジック */ }
}

// ✅ 良い例：個別Creatorに委譲
class MeshFactory {
  static create(type: string) {
    switch(type) {
      case 'A': return TypeACreator.create();
      case 'B': return TypeBCreator.create();
    }
  }
}
```

### 3. UI系の分割

UIコンポーネントは機能単位で分割：

```typescript
// ✅ 良い例
- UIElementManager（DOM要素管理）
- EventManager（イベント処理）
- StateUIManager（状態表示）
- ActionUIManager（操作系UI）
```

### 4. Effect/Animation系の分割

視覚効果は生成と制御を分離：

```typescript
// ✅ 良い例
- ModelCreator（3Dモデル生成）
- AnimationController（アニメーション制御）
- EffectComposer（エフェクト合成）
```

## 実装前チェックリスト

- [ ] 新規ファイルは100行程度に収まる設計か？
- [ ] 各クラスは単一の責任を持っているか？
- [ ] 依存関係は適切に管理されているか？
- [ ] 将来の拡張性を考慮した設計か？

## 具体的な実装例

### ネットワーク機能の実装

```typescript
// 接続管理、メッセージ処理、状態同期を分離
NetworkManager
├── ConnectionManager（接続確立・切断）
├── MessageHandler（メッセージ送受信）
├── StateSync（状態同期）
└── PingManager（接続維持）
```

### ゲームロジックの実装

```typescript
// ゲームの各側面を独立したモジュールに
GameLogic
├── BoardManager（盤面管理）
├── MoveValidator（手の検証）
├── TurnManager（ターン制御）
└── ScoreCalculator（スコア計算）
```

## アンチパターン

以下のパターンは避けること：

- ❌ 200行を超えるファイル
- ❌ 5つ以上の責務を持つクラス
- ❌ 深い継承階層（3階層以上）
- ❌ God Object（すべてを知っているオブジェクト）
