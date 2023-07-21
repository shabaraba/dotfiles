#! /usr/bin/sh

if [ "$1" = ubuntu ]; then
    echo 'ubuntu' 1>&2
    install_cmd='apt install -y'
    apt update -y && apt upgrade -y
elif [ "$1" = centos ]; then
    echo 'centos' 1>&2
    install_cmd='yum install -y'
    yum update -y
else
    echo 'macos' 1>&2
    install_cmd='brew install -y'
fi

if !(type "zsh" > /dev/null 2>&1); then
    $install_cmd zsh
else
    echo 'zsh already installed, skip.'
fi

exit 0

