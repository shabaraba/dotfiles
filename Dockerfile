#############################################
# neovimでの開発環境用dockerサンプル
# php(for laravel)とpython3の開発環境
#############################################

FROM ubuntu:18.04

# common env
ENV TZ Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive
ENV TERMINFO=/usr/lib/terminfo
ENV TERM=xterm
ENV LC_ALL en_US.UTF-8

SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]

# add software-properties-common to install "add-apt-repository" command for installing neovim
RUN apt-get update && apt-get -y upgrade && apt-get install -y software-properties-common

# ubuntu18以降でtzdataとgitを同時に入れると止まってしまうので、gitだけ外だし+ nointeractiveを追加
RUN apt-get update && apt-get -y upgrade && apt-get install -y git
RUN apt-get update && apt-get -y upgrade && apt-get install -y --fix-missing\
    locales-all \
    apt-utils \
    gawk \
    wget \
    curl \
    unzip \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    sudo \
    zsh \
    sed \
    make \
    gcc \
    g++ \
    gpg \
    musl-dev \
    ncurses-dev \
    tzdata \
    nginx \
    php-mbstring \
    php-xml \
    php-fpm \
    php-zip \
    php-common \
    php-fpm \
    php-cli \
    python \
    python-dev \
    python3 \
    python3-dev \
    python3-pip \
  && mkdir /home/ubuntu \
  && rm -f /etc/nginx/sites-enabled/default \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  # && docker-php-ext-install intl pdo_mysql zip bcmath

#composer
ENV COMPOSER_ALLOW_SUPERUSER=1 \
  COMPOSER_HOME=/composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# neovim
RUN pip3 install --upgrade pip
RUN pip3 install neovim
RUN pip3 install pynvim
RUN pip3 uninstall -y msgpack && pip3 install msgpack

# upgrade latest node and npm, and install yarn
# RUN npm install n -g && n stable \
#     && apt purge -y nodejs npm \
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get update && apt-get upgrade -y && apt-get install -y nodejs \
    && curl -qL https://www.npmjs.com/install.sh | sh \
    && npm install -g yarn

# create docker user instead of root
ARG USER_NAME
ENV HOME=/home/${USER_NAME}
RUN useradd --user-group --create-home --shell /bin/false ${USER_NAME} &&\
  echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/${USER_NAME} &&\
  chown -R ${USER_NAME} ${HOME}
RUN mkdir /opt/work && chown -R ${USER_NAME} /opt/work
USER ${USER_NAME}

# dotfilees
RUN zsh && cd ~/ && git clone https://github.com/shabaraba/dotfiles.git && cd dotfiles && make install

WORKDIR /opt/work

COPY php.ini /usr/local/etc/php
