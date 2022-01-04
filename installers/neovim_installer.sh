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

if !(type "nvim" > /dev/null 2>&1); then
    pip3 install neovim && pip3 install pynvim
    git clone https://github.com/neovim/neovim.git
    $install_cmd libtool automake cmake libncurses5-dev g++ gettext
    cd neovim
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    make install;
else
    echo 'neovim already installed, skip.'
fi

exit 1

