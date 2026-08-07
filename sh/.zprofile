# GUIアプリが起動する非対話ログインシェル（WezTermの background_child_process 等）にも
# Homebrewのパスを通す。対話シェル向けには zsh/public/export.zsh が別途追加している。
if [ "$(uname)" = 'Darwin' ] && [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# eval $(/usr/bin/locale-check C.UTF-8)


# rbenvが未インストールのためコメントアウト（miseに一本化）
# Added by `rbenv init` on Thu May  1 15:28:44 JST 2025
# eval "$(rbenv init - --no-rehash zsh)"



# gh-hooks: GitHub CLI hooks
[[ -f "$HOME/.local/share/gh/extensions/gh-hooks/gh-hooks.sh" ]] && source "$HOME/.local/share/gh/extensions/gh-hooks/gh-hooks.sh"

# ~/.local/bin (claude CLI 等) を非対話ログインシェル（GUIアプリの `zsh -lc` 経由等）でも解決できるようにする。
# .zshrcはインタラクティブシェルでしか読まれないため、ここに置く必要がある。
export PATH="$HOME/.local/bin:$PATH"
