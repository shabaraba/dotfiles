ubuntu := lsb-release
centos := centos-release
redhat := redhat-release

os_name := 'macos'
ifeq ($(shell ls /etc | grep ${ubuntu}),${ubuntu})
	os_name := 'ubuntu'
endif
ifeq ($(shell ls /etc | grep ${redhat}),${redhat})
	os_name := 'redhat'
endif
ifeq ($(shell ls /etc | grep ${centos}),${centos})
	os_name := 'centos'
endif

DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help

list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

install: ## Initial setup: install tools and deploy dotfiles (run once)
	@echo '==> OS detected: $(os_name)'
ifeq ($(os_name),'macos')
	@echo '==> Installing Homebrew packages...'
	@if command -v brew >/dev/null 2>&1; then \
		brew bundle install --file=installers/Brewfile; \
	else \
		echo "Homebrew not found. Please install Homebrew first:"; \
		echo '  /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'; \
		exit 1; \
	fi
else ifeq ($(os_name),'ubuntu')
	@echo '==> Installing packages for Ubuntu...'
	@echo 'Choose one of the following:'
	@echo '  - With sudo (includes Ghostty): bash installers/ubuntu_installer.sh'
	@echo '  - Without sudo (Homebrew): bash installers/ubuntu_userspace_installer.sh'
	@echo ''
	@read -p "Use sudo installer? [y/N]: " yn; \
	if [ "$$yn" = "y" ] || [ "$$yn" = "Y" ]; then \
		bash installers/ubuntu_installer.sh; \
	else \
		bash installers/ubuntu_userspace_installer.sh; \
	fi
else
	@echo '==> Installing packages for $(os_name)...'
	@echo 'WARNING: For non-macOS/Ubuntu systems, you need to manually install:'
	@echo '  - ripgrep (rg), fd-find (fd), lazygit, zoxide, mise'
	@echo ''
	@sh installers/neovim_installer.sh $(os_name)
	@sh installers/zsh_installer.sh $(os_name)
endif
	@echo ''
	@echo '==> Deploying dotfiles...'
	@sh deployer.sh
	@echo ''
	@echo '==> Installation complete!'
	@echo ''
	@echo 'Next steps:'
	@echo '  1. Restart your shell: exec $$SHELL -l'
	@echo '  2. For daily operations, use mise tasks:'
	@echo '     - mise run deploy           # Redeploy dotfiles'
	@echo '     - mise run dotfiles:update  # Update from git and redeploy'
	@echo '     - mise tasks                # List all available tasks'

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
