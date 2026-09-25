# zmodload zsh/zprof && zprof

# cargoが未インストールのためコメントアウト
# . "$HOME/.cargo/env"

# Colima Docker socket
# macOS かつ socket が実在するときだけ設定する。
# 無条件に export すると (1) Linux 機では存在しないパスを指して docker が全滅し、
# (2) macOS でも DOCKER_HOST が docker context を上書きしてリモートホストに切り替えられない。
if [[ "$OSTYPE" == darwin* ]] && [[ -S "${HOME}/.config/colima/default/docker.sock" ]]; then
  export DOCKER_HOST="unix://${HOME}/.config/colima/default/docker.sock"
fi

# 壊れたFPATHを環境変数として継承した場合の自己修復。
# 存在しないパスを除き、zsh本体の関数ディレクトリを末尾にフォールバックとして確保する
fpath=(${^fpath}(N-/))
for _zfuncdir in \
    "/usr/share/zsh/${ZSH_VERSION}/functions" \
    /opt/homebrew/share/zsh/functions \
    /home/linuxbrew/.linuxbrew/share/zsh/functions; do
    [[ -d $_zfuncdir && -z ${fpath[(r)$_zfuncdir]} ]] && fpath+=("$_zfuncdir")
done
unset _zfuncdir
