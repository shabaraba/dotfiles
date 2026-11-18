# Google Colab CLI

`colab` コマンドで Colab のランタイムを操作するときの安全ルール。操作手順は `colab-operator` スキルに従う。

- このアカウントは無料枠（残高 0 compute units）。課金につながる操作は実行しない。`colab pay` は実行しない
- 単発の処理は `colab run` を優先する。終了時にVMが自動で破棄される
- `colab new` を使ったら、同じ作業の中で必ず `colab stop -s <name>` する。`-s` で名前を付ける
- `colab new` を他のコマンドと並行実行しない。停止前に VM が残る時間が延びる
- 作業の最後に `colab sessions` で0件になっていることを確認する
- `colab usage` で残高と使用率を確認する。残高が 0 でなくなっていた場合は、作業を止めてユーザーに報告する
- `colab repl`、`colab auth`、`colab drivemount`、引数なしの `colab ssh` は対話用なので、エージェントからは実行しない
- 子チャットや subagent に Colab 操作を任せるときは、このルールをブリーフに含める
