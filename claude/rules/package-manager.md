# パッケージマネージャー

- `npm` と `npx` は使わない。`pnpm` を使う（`pnpm install` / `pnpm run <script>` / `pnpm exec <bin>` / `pnpm dlx`）
- リポジトリのドキュメントやCIが `npm` を前提にしていても、このPCでは `pnpm` に読み替えて実行する。ロックファイルが `package-lock.json` しかない場合は、読み替えずに理由を報告して相談する
- リポジトリに `yarn.lock` がある場合は `yarn` を使う
- `npm` 前提のフックやスクリプト（内部で `npm` を呼ぶもの）は、`--no-verify` などで回避せず、`pnpm` で動くように修正する。修正に `package-lock.json` からの移行が必要な場合は、上記に従って相談する
- 子チャットや subagent に作業を任せるときは、この方針をブリーフに含める
