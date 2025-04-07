#!/usr/bin/env zsh

# プロファイリングの開始
zmodload zsh/zprof

# 元の.zshrcを読み込む
source ~/.zshrc

# プロファイリング結果を表示
zprof
