# ワーカーへの委任（vibing.nvim オーケストレーション）

ワーカーのチャットに実装を任せるときの分担。

- 実装の後の simplify と code-review も、ワーカーに実行させる。オーケストレーターは自分では実行しない
  - simplify は `code-simplifier` スキルを指定する
  - code-review は `code-review` スキルを使い、妥当な指摘だけ直させる
- オーケストレーターは、ワーカーの差分のレビュー、動作確認（シミュレータ・E2E など）、コミット、PR 作成を行う
- ワーカーへのブリーフに、simplify と code-review の範囲（その issue の差分だけ）と、修正ごとに通すチェックを書く
