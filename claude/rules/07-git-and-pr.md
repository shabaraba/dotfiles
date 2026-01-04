# Git & PR ガイドライン

このファイルは、Gitコミット、プルリクエストに関する規約を定義します。

## コミットメッセージ

### Semantic Commit Messages を使用

**言語**: 英語で記述

### 種類

- `feat:` 新機能
- `fix:` バグ修正
- `docs:` ドキュメント更新
- `style:` コード整形（動作に影響しない変更）
- `refactor:` リファクタリング
- `test:` テスト追加/修正
- `chore:` ビルドプロセスやツールの変更

### 例

```
feat: add user authentication
fix: resolve memory leak in game loop
docs: update README with installation steps
refactor: extract validation logic to separate module
```

## プルリクエスト

### PRタイトル
- 英語でSemantic Commit Messages形式
- 例: `feat: implement dark mode toggle`

### PR本文
- 日本語で詳細を記載
- 変更内容の要約
- テスト方法
- スクリーンショット（UI変更の場合）

### issue関連付け
- 対応するissueがある場合は`fixes #<issue番号>`を含める
- 例: `fixes #123`

## コミットのタイミング

**重要**: コミットはユーザーが明示的に指示しない限りしてはならない

- ユーザーから「コミットして」と指示があった場合のみコミット
- 自動的にコミットしない
- 実装完了後もコミット指示を待つ
