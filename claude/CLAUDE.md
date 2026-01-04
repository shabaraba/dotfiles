# CLAUDE.md

このファイルは、Claude Code（claude.ai/code）がコードを扱う際の振る舞いと指針を定義します。

## ルールの構成

詳細なルールは `rules/` ディレクトリに分割されています：

- **01-core-principles.md** - 基本原則、プロジェクト把握、品質重視
- **02-workflow.md** - 実装手順の標準フロー
- **03-code-quality.md** - テスト、品質基準、3回試行ルール
- **04-design-patterns.md** - 設計パターン、ファイル分割基準
- **05-naming-conventions.md** - 命名規則、アンチパターン
- **06-refactoring.md** - リファクタリング方針
- **07-git-and-pr.md** - Git/PRガイドライン
- **08-communication.md** - コミュニケーション方針
- **09-tool-preferences.md** - ツール優先順位

## クイックリファレンス

### 基本方針
- 日本語で応答
- 1ファイル100行程度に収める
- 不要なコメントは残さない
- ビルド・テスト後にリファクタリング

### コミットとPR
- コミットメッセージ: 英語（Semantic Commit Messages）
- PRタイトル: 英語
- PR本文: 日本語
- コミットはユーザーの明示的指示があった場合のみ

### ツール優先順位
1. MCP提供ツール（`mcp_`で始まるもの）
2. 標準ツール（`gh`, WebFetchなど）
