#! /usr/bin/sh

if [ "$1" = ubuntu ]; then
    echo 'ubuntu' 1>&2
    if !(type "nvim" > /dev/null 2>&1); then
        echo 'Installing Neovim from Ubuntu repository...'
        sudo apt update -y
        sudo apt install -y neovim
    else
        echo 'Neovim is already installed.'
        echo 'Current version:'
        nvim --version | head -n 1
    fi
elif [ "$1" = centos ]; then
    echo 'centos' 1>&2
    if !(type "nvim" > /dev/null 2>&1); then
        echo 'Installing Neovim from CentOS repository...'
        sudo yum install -y neovim
    else
        echo 'Neovim is already installed.'
        echo 'Current version:'
        nvim --version | head -n 1
    fi
else
    echo 'macos' 1>&2
    if !(type "nvim" > /dev/null 2>&1); then
        echo 'Installing latest nightly neovim...'
        brew install neovim --HEAD
    else
        echo 'Upgrading to latest nightly neovim...'
        brew upgrade neovim --fetch-HEAD
    fi
fi

exit 0

