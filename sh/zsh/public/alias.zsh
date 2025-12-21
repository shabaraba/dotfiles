# for file
case ${OSTYPE} in
  darwin*)
    # ここに Mac 向けの設定
    alias open='open'
    ;;
  linux*)
    alias open='xdg-open'
    # ここに Linux 向けの設定
    ;;
esac

alias c='clear'
alias his='history'
alias ...='cd ../..'
alias ....='cd ../../..'
alias v='nvim'
alias vl='nvim --listen /tmp/nvim'

# android device bridgh
# wsl2ではusb接続されたデバイスを認識できず、実機デバッグしにくいので、
# windowsのadbを使用する（rootにadbという名前でwindowsのadb.exeにシンボリックリンクを張っている）
# alias adb='~/adb'
# alias adb='/mnt/d/tools/platform-tools/adb.exe'
# alias flutter='/mnt/c/flutter/bin/flutter'
# alias dart='/mnt/c/flutter/bin/dart'
