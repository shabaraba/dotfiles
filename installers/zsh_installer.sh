#! /usr/bin/sh

if [ $1 = 'ubuntu' ]; then
    echo 'ubuntu' 1>&2
    install_cmd='apt install -y'
elif [ $1 = 'centos' ]; then
    echo 'centos' 1>&2
    install_cmd='yum install -y'
else
    echo 'macos' 1>&2
    install_cmd='brew install -y'
fi

if !(type "zsh" > /dev/null 2>&1); then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
else
    echo 'zsh already installed, skip.'
fi

exit 1

