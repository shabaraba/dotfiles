# Git / GitHub操作ルール

## コミット実行の条件

- ユーザーが明示的に「コミットして」「commit」等と指示した場合のみコミットを実行する
- 自動的・予防的なコミットは一切行わない

## コミットメッセージ

- Semantic Commit Messages形式（feat / fix / docs / style / refactor / test / chore）
- 英語で簡潔に記述する
- 「🤖 Generated with Claude Code」等の自動追加フッターは含めない
- 「Co-Authored-By: Claude」等のメタデータも含めない

## Pull Request

- タイトル: 英語・Semantic Commit Messages形式
- 本文: 日本語で詳細を記載
- 対応するissueがある場合は `fixes #<issue番号>` を含める

## BREAKING CHANGEの使用基準

ユーザーに実質的な影響を与える破壊的変更の場合のみ使用する。

- 使う: API互換性を破る変更（シグネチャ・引数・戻り値）/ 手動対応が必要な設定ファイル形式の変更 / CLIの変更 / 代替手段が必要な機能削除
- 使わない: 外部から見た動作が同じ内部実装の変更 / ドキュメント・コメント更新 / 外部インターフェース不変のリファクタリング / 非公開APIの変更 / バグ修正
