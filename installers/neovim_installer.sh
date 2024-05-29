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
    install_cmd='brew install '
fi

if !(type "nvim" > /dev/null 2>&1); then
    brew install neovim --HEAD
    # pip3 install neovim && pip3 install pynvim
    # if [ ! -e ./neovim ]; then
    #     git clone https://github.com/neovim/neovim.git
    #     cd neovim
    #     make CMAKE_BUILD_TYPE=RelWithDebInfo
    #     make install;
    #     cd ../ && rm -rf neovim
    # fi
    # $install_cmd pkg-config libtool-bin libtool automake cmake libncurses5-dev g++ gettext
else
    echo 'updating...'
    brew reinstall neovim
    # echo 'neovim already installed, skip.'
fi

exit 0

