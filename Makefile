ubuntu := lsb-release
centos := centos-release
redhat := redhat-release

os_name := 'macos'
INSTALL := brew install 
ifeq ($(shell ls /etc | grep ${ubuntu}),${ubuntu})
	os_name := 'ubuntu'
	INSTALL := apt install -y
endif
ifeq ($(shell ls /etc | grep ${redhat}),${redhat})
	os_name := 'ubuntu'
	INSTALL := apt install -y
endif
ifeq ($(shell ls /etc | grep ${centos}),${centos})
	os_name := 'centos'
	INSTALL := apt install -y
endif

DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help

define _setUpCoc
	@cd $(HOME)/.config/coc/extensions && npm install
endef

define _linkDotFiles
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
endef

all:

list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

install: ## Create symlink to home directory
	@echo $(os_name)
	@echo '==> Install neovim'
	@echo 'sh installers/neovim_installer.sh $(os_name)'
	@sh installers/neovim_installer.sh $(os_name)
	@echo '==> Install zsh'
	@sh installers/zsh_installer.sh $(os_name)
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo 'sh deployer.sh'
	@sh deployer.sh
##	@$(call _setUpCoc)

deploy: ## Create symlink to home directory
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo 'sh deployer.sh'
	@sh deployer.sh
##	@$(call _setUpCoc)


help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

