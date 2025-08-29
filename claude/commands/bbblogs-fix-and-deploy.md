# BBBlogs自動修正・デプロイコマンド

このコマンドは、BBBlogsシステム全体の修正と最新記事の更新を自動化します。

## 実行手順

### 1. bbblogs-top最新記事収集・デプロイ

```bash
cd /Users/t002451/my_work/private/blog-gatling/bbblogs-top

# クリーンビルド（RSS最新取得）
rm -rf .next out
npm run build

# 正常に30記事取得されたか確認
# ログに "Successfully fetched 30 posts total" が表示されることを確認

# Cloudflare Pagesにデプロイ
wrangler pages deploy out --project-name bbblogs-top --commit-dirty=true
```

### 2. 各ブログのエラー修正（必要時のみ）

RSS feedエラーが発生している場合：

```bash
# blog01修正例
cd ../blog01
npm run build
wrangler pages deploy out --project-name blog01-gatling --commit-dirty=true

# blog08修正例
cd ../blog08 
npm run build
wrangler pages deploy out --project-name blog08-gatling --commit-dirty=true
```

### 3. 確認項目

**RSS feed動作確認:**
```bash
curl -s https://ai.bbblogs.work/index.xml | head -5
curl -s https://side.bbblogs.work/index.xml | head -5
```

**記事リンク確認:**
```bash
curl -s -o /dev/null -w "%{http_code}" https://side.bbblogs.work/posts/base-side-hustle-what-to-sell/
# 200 or 308が正常
```

## 重要ポイント

1. **記事取得の確認**: ビルド時に必ず30記事（全10ブログ×3記事）が取得されていることを確認
2. **URL修正**: 各ブログのblog.config.tsでdomainが正しく設定されていることを確認
3. **RSS feed**: /index.xmlエンドポイントが全ブログで正常動作していることを確認
4. **静的エクスポート**: bbblogs-topは`output: 'export'`モードで動作
5. **404エラー**: 記事リンクの404エラーが発生した場合は、該当ブログのconfig修正が必要

## エラー対応

- **RSS 404エラー**: 該当ブログのRSS routeファイル確認
- **記事リンク404**: blog.config.tsのdomain設定確認
- **ビルドエラー**: 型エラーの場合、Post型のfrontMatterプロパティアクセス確認

## デプロイ先URL

- **bbblogs-top**: https://bbblogs.work（最新デプロイはプレビューURLで確認）
- **個別ブログ**: https://[blog-name].bbblogs.work

このコマンドにより、BBBlogsシステム全体の自動更新と問題修正が可能です。