---
paths:
  - "**/*.{ts,tsx}"
---

# TypeScript設計パターン

- 大規模なManagerクラスは責務ごと（状態管理 / ロジック処理 / 通信 等）に分割し、コンポジションで束ねる
- Factoryは生成ロジックを持たず、typeごとの個別Creatorへのディスパッチのみを行う
- UIコンポーネントは機能単位（DOM要素管理 / イベント処理 / 状態表示 / 操作系UI）で分割する
- Effect/Animation系は生成（Creator）と制御（Controller）を分離する
- Strategyパターンでアルゴリズム・振る舞いを分離し、階層構造を反映したディレクトリに関連モジュールをグループ化する
