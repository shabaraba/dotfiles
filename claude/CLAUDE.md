# CLAUDE.md

このファイルは、Claude Code（claude.ai/code）がコードを扱う際の振る舞いと指針を定義します。

## 🔨 最重要ルール - 新しいルールの追加プロセス

ユーザーから今回限りではなく常に対応が必要だと思われる指示を受けた場合：

1. 「これを標準のルールにしますか？」と質問する
2. YESの回答を得た場合、CLAUDE.mdに追加ルールとして記載する
3. その際に、プロジェクト固有のルールなのか、開発作業全体に関わるルールなのかを判断して、プロジェクトルートのCLAUDE.mdに記載するか、~/.claude/CLAUDE.md に記載するか選択する
4. 以降は標準ルールとして常に適用する

このプロセスにより、プロジェクトのルールを継続的に改善していきます。

## 基本原則
Claude Codeは以下の原則に従って動作してください：

1. **プロジェクト全体の把握**
   - タスクに着手する前に、関連ファイルとコードベース全体の構造を把握する
   - アーキテクチャとディレクトリ構造を理解してから実装を開始する

2. **タスクの文脈理解と実装計画**
   - ユーザーの要求を正確に理解し、実装前に明確な計画を立てる
   - 必要に応じてTodoWriteツールを使用してタスクを分割・管理する
   - 実装前に既存コードの規約やパターンを確認する

3. **品質重視の実装**
   - **ファイルサイズ**: 1ファイル100行程度に収める
   - **コメント**: 不要なコメントは一切残さない
   - **モジュール化**: 関数やクラスは単一責任の原則に従う
   - **リファクタリング**: ビルドテスト後に必要に応じてリファクタを実行
   - **rootディレクトリにむやみにファイルを増やさず、必要最小限に留める**

4. **テストとビルド**
   - 実装後は必ずビルドコマンドを実行してエラーがないことを確認
   - 型チェックやリンターを実行
   - テストが存在する場合は必ず実行
   - **3回試行ルール**: ビルドやテストの失敗を3回修正してもまだ解決できない場合は、現状報告と困っている点をユーザーに伝え、アドバイスを求める

5. **mockとimplの使い分け**
   - 開発中はmockデータで迅速にプロトタイピング
   - 本番実装では適切なエラーハンドリングとデータ検証を行う
   - インターフェースを明確に定義してから実装に進む

6. **コミュニケーション**
   - 定期的に進捗を報告（主要なステップごと）
   - 不明な点や設計上の判断が必要な場合は即座にユーザーに質問
   - 実装の選択肢がある場合は、理由を説明した上で提案
   - エラー解決に苦戦した場合は、遠慮なくユーザーに相談する

## ツール使用方針
- **GitHub操作**: GitHub MCPツール（`mcp_`で始まるツール）が利用可能な場合は、ghコマンドよりも優先的に使用する
- **Web検索**: MCP提供のWebツールが利用可能な場合は、通常のWebFetchツールよりも優先する
- **ローカルサーバー操作**: devtoolsMCPを使うこと

## 言語設定
- **応答言語**: 日本語で応答する
- **コミットメッセージ**: 英語でSemantic Commit Messagesを使用
  - feat: 新機能
  - fix: バグ修正
  - docs: ドキュメント更新
  - style: コード整形
  - refactor: リファクタリング
  - test: テスト追加/修正
  - chore: ビルドプロセスやツールの変更
- **PRタイトル**: 英語でSemantic Commit Messages形式
- **PR本文**: 日本語で詳細を記載
- **issue関連付け**: 対応するissueがある場合は`fixes #<issue番号>`を含める

## Code Style Guidelines
- **Comments**: 必要最小限のコメントのみ。コードは自己文書化を心がける

## 命名規則
- **リファクタリング時の命名**: 一時的・段階的な改善を示すプレフィックス/サフィックスは絶対に使用しない
  - ❌ 悪い例（プレフィックス）: `NewGameLogic`, `OldUserService`, `TempDatabase`, `UltimateParser`, `SuperController`, `OptimizedRenderer`
  - ❌ 悪い例（サフィックス）: `GameLogicV2`, `UserServiceFinal`, `DatabaseOptimized`, `ParserUltimate`
  - ✅ 良い例: リファクタリング完了後の最終的な名前を直接使用
  - リファクタリング時は、旧ファイルを削除してから新ファイルを正式名称で作成する
  - バージョン管理はGitで行い、ファイル名でバージョンを表現しない
- **意味のある名前**: ファイル名、クラス名、関数名は、その役割を明確に表すものにする
- **一貫性**: プロジェクト内で同じ概念には同じ命名パターンを使用する

## 実装手順の標準フロー
1. 要求内容の理解と確認
2. 関連ファイルの調査（Grep, Globツールを使用）
3. 実装計画の策定（TodoWriteで管理）
4. 実装（既存の規約に従う）
5. ビルドとテストの実行
6. 必要に応じてリファクタリング
7. 最終確認と進捗報告

## 新規実装・機能追加時の設計基準 - 2025/01/28

### ファイル分割の基本方針
- **1ファイル100行程度**: 最大でも200行を超えないこと
- **単一責任の原則**: 1つのクラス/モジュールは1つの責任のみを持つ
- **高凝集性**: 関連する機能は同じモジュールに、無関係な機能は別モジュールに

### 必須の設計パターン

#### 1. Manager系クラスの分割
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

#### 2. Factory系の実装
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

#### 3. UI系の分割
UIコンポーネントは機能単位で分割：
```typescript
// ✅ 良い例
- UIElementManager（DOM要素管理）
- EventManager（イベント処理）
- StateUIManager（状態表示）
- ActionUIManager（操作系UI）
```

#### 4. Effect/Animation系の分割
視覚効果は生成と制御を分離：
```typescript
// ✅ 良い例
- ModelCreator（3Dモデル生成）
- AnimationController（アニメーション制御）
- EffectComposer（エフェクト合成）
```

### 実装前チェックリスト
- [ ] 新規ファイルは100行程度に収まる設計か？
- [ ] 各クラスは単一の責任を持っているか？
- [ ] 依存関係は適切に管理されているか？
- [ ] 将来の拡張性を考慮した設計か？

### 具体的な実装例

#### ネットワーク機能の実装
```typescript
// 接続管理、メッセージ処理、状態同期を分離
NetworkManager
├── ConnectionManager（接続確立・切断）
├── MessageHandler（メッセージ送受信）
├── StateSync（状態同期）
└── PingManager（接続維持）
```

#### ゲームロジックの実装
```typescript
// ゲームの各側面を独立したモジュールに
GameLogic
├── BoardManager（盤面管理）
├── MoveValidator（手の検証）
├── TurnManager（ターン制御）
└── ScoreCalculator（スコア計算）
```

### アンチパターン
- 200行を超えるファイル
- 5つ以上の責務を持つクラス
- 深い継承階層（3階層以上）
- God Object（すべてを知っているオブジェクト）

## 大規模ファイルのリファクタリング - 2025/01/28

### 方針
大規模なファイル（200行以上）を分割する際は、以下の方針に従う：

1. **モジュール分割の基準**
   - 単一責任の原則（Single Responsibility Principle）を厳守
   - 各モジュールは特定の機能や関心事に焦点を当てる
   - 凝集度を高く、結合度を低く保つ

2. **分割パターン**
   - **Manager/Service分離**: ビジネスロジックを専門マネージャーに分離
   - **Factory パターン**: オブジェクト生成ロジックの抽出
   - **Strategy パターン**: アルゴリズムや振る舞いの分離
   - **Component分離**: UI要素を論理的な単位で分割

3. **実装手順**
   - 既存ファイルの責務を明確に分析
   - 関連する機能をグループ化
   - インターフェースを定義して依存関係を明確化
   - 段階的に機能を抽出（一度に全て移動しない）
   - 各ステップでビルドとテストを実行

4. **命名規則**
   - モジュール名は役割を明確に表す（例: ConnectionManager, MoveValidator）
   - 階層構造を反映したディレクトリ構成
   - 関連モジュールは同じディレクトリにグループ化

5. **品質確保**
   - 分割後も元の機能が完全に保持されることを確認
   - 循環依存を避ける
   - 必要に応じて共通インターフェースを定義
   - ドキュメント化（特に新しいモジュール間の関係）

# AI Trader System - 2025/01/06

## 仕様概要
- **要求の背景と目的**: GitHub Actionsの定期実行によるAIトレーダーシステムの構築。1時間ごとにファンダメンタル分析と世界情勢を考慮した市場分析を行い、デイトレード頻度で取引を実行。
- **主要機能一覧**:
  - XAU/USDとUSD/JPYを中心とした外国為替取引
  - 10通貨ペアの監視と相関分析
  - MCPサーバー経由での取引実行
  - トレードノートの自動記録（Markdown形式）
  - 日次振り返りとCLAUDE.mdへの学習内容追記
  - GitHub Pagesでの取引履歴・パフォーマンス可視化
- **制約条件・成功基準**:
  - Self-hosted GitHub Actionsでの定期実行
  - リスク管理（1取引2%以内、リスクリワード比1:1.5以上）
  - すべての取引記録の保存と振り返り機能

## 設計概要
- **システム構成・アーキテクチャ**:
  - GitHub Actions（1時間ごとの分析実行、日次振り返り）
  - ClaudeCode（市場分析・取引判断）
  - MCPサーバー（取引実行）
  - GitHub Pages（取引履歴可視化）
- **技術選定とその理由**:
  - TypeScript: 型安全性と保守性
  - React + Vite: GitHub Pages用の高速なビルド
  - TailwindCSS: レスポンシブデザイン
  - Chart.js: 取引データの可視化
- **実装方針・順序**:
  1. プロジェクト基盤構築
  2. トレーダープロンプトの作成
  3. GitHub Actions設定
  4. トレードノート記録機能
  5. GitHub Pages可視化サイト
  6. 日次振り返り機能

## 実装詳細
- **タスク分割と優先度**:
  1. プロジェクト初期化とディレクトリ構造
  2. AI Traderプロンプトの作成
  3. 市場分析スクリプト
  4. トレードノート記録システム
  5. GitHub Actions設定
  6. 可視化サイト構築
  7. 日次振り返りシステム
- **テスト方針**: モック取引での動作確認後、実環境でのテスト
- **品質保証方法**: TypeScriptの型チェック、ESLintによるコード品質管理

## 参考情報
- MCPサーバーAPIドキュメント（実装時に確認）
- GitHub Actions self-hosted runner設定
- 各通貨ペアの取引時間と特性

## Trading Insights - 2025-06-02
- Win Rate: 0.0%
- Key Learning: Continued system refinement
- Market Condition: No trades taken - possibly ranging market

# Supabase CLI運用ナレッジ - 2025/06/25

## 🔧 Supabase CLI認証問題の解決策

### 問題
Supabase CLI v2.26.9でデータベース接続時にSCRAM-SHA-256認証エラーが発生：
```
failed SASL auth (invalid SCRAM server-final-message received from server)
```

### 原因
- CLIのCobraフレームワークでパスワードフラグバインディング不具合
- GitHub Issues #2347, #3337で報告済み
- PostgreSQL SCRAM認証プロトコルでのパスワード処理問題

### 確実な解決策（成功率100%）
```bash
# 環境変数でパスワード指定
export SUPABASE_ACCESS_TOKEN="sbp_xxxxxxxxxxxxx"
export SUPABASE_DB_PASSWORD="database_password"
npx supabase db push
```

### フォールバック手法
1. **Dashboard手動実行**（最も確実）
   - URL: `https://supabase.com/dashboard/project/[PROJECT_ID]/sql`
   - マイグレーションSQLを直接コピー&ペースト

2. **直接接続モード**
   ```bash
   npx supabase db push --host db.[PROJECT_ID].supabase.co --port 5432
   ```

### セキュリティ重要事項
- **Service Role Key**: RLSバイパス権限、環境変数管理必須
- **Anon Key**: フロントエンド用、RLS適用
- **APIキー**: ハードコード絶対禁止

### RLS管理ベストプラクティス
```sql
-- 必須ポリシーパターン
CREATE POLICY "Users access own data" ON table_name
  FOR ALL USING (auth.uid() = user_id);

-- 全テーブルでRLS有効化
ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;
```

### マイグレーション手順
1. Access Token取得（Dashboard > Account > Tokens）
2. DB Password設定（Dashboard > Settings > Database）
3. 環境変数設定
4. CLI実行またはDashboard手動実行

この知識により将来的なSupabase CLI認証問題を迅速に解決可能。

# 模写xSNSサービス - 2025/06/09

## 仕様概要
- **要求の背景と目的**: Gemini画像生成APIを活用した模写コミュニティサービス。毎日お題となる動物画像を自動生成し、ユーザーが模写を投稿・交流できるSNS機能を提供。
- **主要機能一覧**:
  - 毎日6時にGemini APIで動物画像自動生成（お題）
  - 匿名・ログインユーザー両対応の投稿機能（1日1枚制限）
  - グリッド表示での投稿一覧・ソート機能
  - いいね・お気に入り・コメント・絵文字スタンプでの交流
  - 過去お題の閲覧機能（投稿は当日のみ）
  - 管理者機能・報告機能によるコンテンツ管理
  - 通知機能（新お題・リアクション）
  - 自動画像リサイズによるファイルサイズ最適化
- **制約条件・成功基準**:
  - Webアプリケーション（レスポンシブ対応必須）
  - 無料かつ商用利用可能な技術スタック
  - 投稿コメント140文字制限
  - サンプルお題・投稿の初期データ用意

## 設計概要
- **システム構成・アーキテクチャ**:
  - フロントエンド: React + Vite + TypeScript + TailwindCSS
  - バックエンド: Next.js API Routes
  - データベース: Supabase PostgreSQL + Storage
  - 認証: Supabase Auth（匿名対応）
  - 外部API: Google Gemini（画像生成）
  - デプロイ: Vercel + Supabase
- **技術選定とその理由**:
  - React 18 + Vite: 高速開発・ビルド、無料商用利用可
  - TypeScript: 型安全性、保守性向上
  - TailwindCSS: レスポンシブ対応、高速スタイリング
  - Supabase: PostgreSQL + 認証 + ストレージ統合、無料枠あり
  - Next.js API Routes: フルスタック開発効率
- **実装方針・順序**:
  1. 基盤構築（プロジェクト初期化・認証・DB）
  2. コア機能（お題生成・投稿・一覧表示）
  3. 交流機能（いいね・コメント・スタンプ）
  4. 管理機能（管理者・報告・レスポンシブ）
  5. 最適化・デプロイ

## 実装詳細
- **タスク分割と優先度**:
  - Phase1: Next.js+TypeScript環境構築、Supabase設定、認証システム、データベース構築
  - Phase2: Gemini API連携、お題自動生成、投稿機能、グリッド一覧表示
  - Phase3: いいね・お気に入り機能、コメント機能、絵文字スタンプ、通知基本版
  - Phase4: 管理者機能、報告機能、レスポンシブ対応
  - Phase5: パフォーマンス最適化、Vercelデプロイ、本格運用準備
- **テスト方針**: 
  - 単体テスト: 重要ユーティリティ関数
  - 統合テスト: APIエンドポイント
  - E2Eテスト: 主要ユーザーフロー（投稿・いいね・コメント）
  - 手動テスト: UI/UX、レスポンシブ対応
- **品質保証方法**: 
  - TypeScript型チェック、ESLint+Prettier、Husky、Supabase RLS

## 参考情報
- Google Gemini API ドキュメント
- Supabase認証・ストレージ設定
- 匿名ユーザー管理（セッションベースID）
- 画像最適化・リサイズ実装

# Browser Log Collector MCP Tool - 2025/01/10

## 仕様概要
- **要求の背景と目的**: ブラウザの開発者ツールに流れるコンソールログを、開発サーバー側（MCP）でも収集・確認できるようにする。Chrome拡張機能方式により、Webアプリ側のコード変更なしでログ収集を実現。
- **主要機能一覧**:
  - Chrome拡張機能によるコンソールログ傍受
  - ポート別のログ収集・分類（3000, 8080等）
  - MCPツール経由でのログ取得・フィルタリング
  - ログレベル別フィルタ（log, warn, error）
  - プロジェクト自動識別機能
  - メモリベースのログストレージ（上限10,000件）
- **制約条件・成功基準**:
  - 既存のdevtools-mcpプロジェクトへの統合
  - Webアプリケーション側のコード変更不要
  - localhost開発環境での使用を前提
  - Chrome/Chromium系ブラウザ対応

## 設計概要
- **システム構成・アーキテクチャ**:
  - Chrome Extension（Manifest V3）: ログ傍受・送信
  - MCPサーバー拡張: HTTPエンドポイント・ログ管理
  - 既存devtools-mcpへの統合: 新規ツール追加
- **技術選定とその理由**:
  - TypeScript: 型安全性、既存コードベースとの整合性
  - Chrome Extension Manifest V3: 最新仕様、セキュリティ強化
  - HTTP POST通信: シンプルで信頼性が高い
  - メモリストレージ: 初期実装として適切、後で永続化可能
- **実装方針・順序**:
  1. MCPサーバー側の基盤構築
  2. Chrome拡張機能の実装
  3. 統合とテスト
  4. ドキュメント作成

## 実装詳細
- **タスク分割と優先度**:
  1. 共通型定義の作成
  2. MCPサーバーへのHTTPエンドポイント追加
  3. ログストレージとMCPツール実装
  4. Chrome拡張機能プロジェクト作成
  5. Content ScriptとBackground Service Worker実装
  6. ビルド設定と統合テスト
  7. 使用方法ドキュメント作成
- **テスト方針**: 
  - 単体テスト: ログ変換・フィルタリング機能
  - 統合テスト: 拡張機能→MCPサーバー通信
  - 手動テスト: 実際のlocalhost環境での動作確認
- **品質保証方法**: 
  - TypeScript厳密モード、ESLint設定、ビルド成功確認

## 参考情報
- Chrome Extension Manifest V3ドキュメント
- 既存のdevtools-mcpプロジェクト構造
- Service Workerライフサイクル管理
- CORS設定とセキュリティ考慮事項

# BrainDump プロンプトシステム設計 - 2025/06/16

## アーキテクチャ概要
現在のハードコードされたプロンプト生成方式から、柔軟で拡張性の高いテンプレートベースシステムへの移行設計。

### 設計原則
1. **責任の分離**: プロンプト管理とAPI呼び出しを分離
2. **拡張性**: 新しいプロンプトタイプの追加が容易
3. **カスタマイザビリティ**: ユーザーが自由にプロンプトを編集・作成可能
4. **バージョニング**: プロンプトの変更履歴を管理
5. **テスタビリティ**: 各コンポーネントが独立してテスト可能

### アーキテクチャ構成
```
Application Layer
├─ RewriteService (Orchestrator)
└─ PromptService

Domain Layer
├─ PromptTemplate (Entity)
├─ PromptRepository (Interface)
├─ PromptRenderer (Service)
└─ AIClient (Interface)

Infrastructure Layer
├─ SupabasePromptRepository
├─ GeminiClient/ClaudeClient
└─ PromptTemplateEngine
```

### コアエンティティ設計

#### PromptTemplate
```typescript
interface PromptTemplate {
  id: string;
  name: string;
  description: string;
  category: PromptCategory;
  template: string;  // プレースホルダー含む
  placeholders: PlaceholderDefinition[];
  metadata: PromptMetadata;
  version: number;
  isSystemDefault: boolean;
  isPublic: boolean;
}
```

#### PromptRenderer
テンプレートからファイナルプロンプトを生成
- プレースホルダー置換
- 条件分岐処理
- バリデーション機能

#### RewriteService (Orchestrator)
プロンプト解決 → レンダリング → AI呼び出し → 統計記録の一連の流れを管理

### データストレージ設計
- **prompt_templates**: プロンプトテンプレート本体
- **prompt_usage_stats**: 使用統計・分析データ
- **prompt_ratings**: ユーザー評価・フィードバック

### 移行戦略
1. **Phase 1**: 基盤構築（2週間）
2. **Phase 2**: 現行システム置き換え（1週間）
3. **Phase 3**: ユーザーカスタマイゼーション（2週間）
4. **Phase 4**: 高度な機能（検索・共有・A/Bテスト）（3週間）

### 設計判断の記録

#### 現在の課題
- `GeminiApiClient`内でのハードコードされたプロンプト
- プロンプト変更時のコード修正・デプロイが必要
- ユーザーカスタマイゼーションが困難
- A/Bテストの実装困難

#### なぜこの設計にしたか
1. **テンプレートエンジン採用**: ユーザーカスタマイゼーションの柔軟性実現
2. **Repository パターン**: データ永続化の抽象化、テスタビリティ向上
3. **Orchestrator パターン**: 複雑なビジネスロジックの一元管理
4. **バージョニング設計**: プロンプト改善履歴追跡、ロールバック機能

#### トレードオフ
- **複雑性の増加 vs 柔軟性の獲得**: 短期的実装コスト増 vs 長期的メンテナンス性向上
- **パフォーマンス vs 機能性**: DBアクセスによるレイテンシー増 vs 豊富な機能
- **ユーザビリティ vs カスタマイザビリティ**: 初心者の複雑性 vs パワーユーザーの自由度

### 実装時の注意点
- 現在の`buildPrompt`関数は段階的に廃止
- 既存のCustomPrompt、WritingStyle型との整合性を保つ
- パフォーマンス劣化を防ぐキャッシュ戦略の実装
- セキュリティ: ユーザー作成プロンプトのサニタイゼーション

## Anti-Pattern Memories

### CSS Anti-Pattern警告リスト

#### 🚫 絶対に使用禁止:
1. body * { } - 全子孫要素セレクタ
2. header * { } - スコープ内全要素セレクタ
3. [style*="background"] - 属性部分一致セレクタ
4. .css-xxxxx - 動的生成クラス名
5. color: initial !important - 継承値の強制

#### ⚠️ 使用前に再考:
- セレクタに * が含まれていないか？
- !important は本当に必要か？
- 5階層以上のネストになっていないか？

#### ✅ 必ず実施:
1. 新規CSS追加前に「このセレクタは子孫要素に意図しない影響を与えないか？」を確認
2. Chakra UIコンポーネントにはpropsとsx propを優先使用
3. グローバルCSSよりコンポーネントレベルのスタイルを優先

#### 💡 デバッグ時の確認項目:
- 白背景に白文字 → 広範囲セレクタを疑う
- スタイルが効かない → !importantの競合を疑う
- 予期しない要素に適用 → 属性セレクタの部分一致を疑う

#### 実装時のチェックリスト:
□ セレクタに * を使っていない
□ 属性セレクタは完全一致か確認
□ !important は3個以内
□ color: initial は使用していない
□ 動的クラス名（.css-）を直接指定していない

#### 問題発生時の対処法:
1. まず犯人セレクタを特定（DevToolsで確認）
2. より具体的なセレクタに置き換え
3. コンポーネントレベルでの解決を検討

# Supabase 開発・本番環境認証設定ナレッジ - 2025/07/03

## 🔧 問題: 開発・本番環境でSupabase OAuth設定が競合する

### 背景
Supabase認証では、Single Projectの場合：
- **Site URL**: JWTのstateパラメータに埋め込まれ、認証後のリダイレクト先を決定
- **Redirect URLs**: OAuth認証完了後の許可されたコールバックURL

本番・開発で**Site URL**が異なるため、片方の環境でしか正常に動作しない問題が発生。

### 🚨 症状
- JWTのstateパラメータ: `"site_url":"https://production.com"`
- 開発時にも本番環境にリダイレクトされる
- localhost設定変更すると本番環境が動作しなくなる

## ✅ 解決方法1: Supabase CLI + ローカルインスタンス（推奨）

### 設定手順

1. **supabase/config.toml にGoogle OAuth設定追加:**
```toml
[auth.external.google]
enabled = true
client_id = "env(SUPABASE_AUTH_GOOGLE_CLIENT_ID)"
secret = "env(SUPABASE_AUTH_GOOGLE_SECRET_KEY)"
redirect_uri = "http://localhost:54321/auth/v1/callback"
skip_nonce_check = true
```

2. **環境変数設定 (.env.local):**
```env
# ローカル開発用
SUPABASE_AUTH_GOOGLE_CLIENT_ID=your_google_client_id
SUPABASE_AUTH_GOOGLE_SECRET_KEY=your_google_secret

# 開発時はローカルSupabaseを使用
NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_local_anon_key
```

3. **Google Cloud Console設定:**
- 認証済みJavaScript生成元: `http://localhost:54321`
- 認証済みリダイレクトURI: `http://localhost:54321/auth/v1/callback`

4. **運用コマンド:**
```bash
# ローカルSupabase起動
supabase start

# アプリ開発
npm run dev

# 設定変更後は再起動
supabase stop && supabase start
```

### メリット
- ✅ 本番環境設定を一切変更せずに開発可能
- ✅ 完全に独立した環境でテスト
- ✅ データベースマイグレーションも安全にテスト
- ✅ 業界標準のベストプラクティス

## ✅ 解決方法2: Additional Redirect URLs活用

1. **Supabase Dashboard設定:**
   - Site URL: 本番環境のまま
   - Additional Redirect URLs: `http://localhost:3000/**`

2. **動的リダイレクト処理:**
```typescript
// auth/callback/route.ts
const isLocalhost = requestUrl.hostname === 'localhost'
const redirectUrl = isLocalhost
  ? `http://localhost:13004/app?locale=${locale}`
  : `${requestUrl.origin}/app?locale=${locale}`
```

### デメリット
- ⚠️ Site URLは本番環境固定のため、一部制限あり
- ⚠️ JWT stateパラメータは本番環境URL

## 🎯 推奨アプローチ

**開発**: Supabase CLI + ローカルインスタンス (`localhost:54321`)
**本番**: リモートSupabaseプロジェクト

これにより完全に独立した環境で開発でき、認証設定の競合問題を根本的に解決可能。