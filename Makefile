ifeq ($(shell ls /etc | grep ".*-release$"),lsb-release)
	INSTALL := apt install -y
else\
	INSTALL := yum install -y
endif

ifeq ($(shell uname),Debian)
	INSTALL := apt install -y
else
endif

DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help

define _installZplug
	@curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
endef

define _setUpCoc
	@cd .config/coc/extensions && npm install
endef

define _linkDotFiles
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
endef

all:

list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

install: ## Create symlink to home directory
	@echo 'Copyright (c) 2013-2015 BABAROT All Rights Reserved.'
	@echo '==> Install neovim'
	@if !(type "nvim" > /dev/null 2>&1); then \
		pip3 install neovim \
		&& pip3 install pynvim \
		&& git clone https://github.com/neovim/neovim.git \
		&& $(INSTALL) libtool automake cmake libncurses5-dev g++ gettext \
		&& cd neovim \
		&& make CMAKE_BUILD_TYPE=RelWithDebInfo \
		&& make install; \
	else \
		echo 'neovim already installed, skip.';\
	fi
	@echo '==> Install zplug'
	@if !(type "zsh" > /dev/null 2>&1); then \
		@curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh; \
	else \
		echo 'zsh already installed, skip.'; \
	fi
	@echo '==> Start to deploy dotfiles to home directory.'
	@$(call _linkDotFiles)
	@$(call _setUpCoc)

deploy: ## Create symlink to home directory
	@echo 'Copyright (c) 2013-2015 BABAROT All Rights Reserved.'
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(call _linkDotFiles)
	@$(call _setUpCoc)

clean: ## Remove the dot files and this repo
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
	-rm -rf $(DOTPATH)

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

