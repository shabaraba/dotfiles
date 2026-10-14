# パッケージマネージャー

- `npm` と `npx` は使わない。`pnpm` を使う（`pnpm install` / `pnpm run <script>` / `pnpm exec <bin>` / `pnpm dlx`）
- リポジトリのドキュメントやCIが `npm` を前提にしていても、このPCでは `pnpm` に読み替えて実行する。ロックファイルが `package-lock.json` しかない場合は、読み替えずに理由を報告して相談する
- `pnpm` で実行できない手順（内部で `npm` を呼ぶスクリプトなど）は、回避せずに止まって報告する
- 子チャットや subagent に作業を任せるときは、この方針をブリーフに含める
