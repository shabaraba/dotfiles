
# .dotfiles

Personal dotfiles configuration for development environment setup.

## Quick Start

### Initial Setup (First Time Only)

1. Clone this repository:
   ```sh
   git clone https://github.com/shabaraba/dotfiles.git
   cd dotfiles
   ```

2. Run the installation script:
   ```sh
   sh install.sh
   ```

   This will:
   - Install Homebrew (if not installed)
   - Install mise (language version manager)
   - Install packages from Brewfile
   - Install Neovim and Zsh configurations
   - Deploy dotfiles to your home directory

3. Restart your shell:
   ```sh
   exec $SHELL -l
   ```

### Daily Usage (After Installation)

Once installed, you can use mise tasks from anywhere:

```sh
# Redeploy dotfiles (after making changes)
mise run deploy

# Update dotfiles from git and redeploy
mise run dotfiles:update

# Check dotfiles git status
mise run dotfiles:status

# Update Homebrew packages
mise run brew:update

# List all available tasks
mise tasks
```

# install

Executing [the above command](#usage), you can install as following:

- neovim
- zinit

## NOTICE

if you use not `.vimspector.json` in your project root
but configuration files in .vimspector-config/\* to debug,  
you have to set your project root to `/var/www/html/src`
and launch neovim in your project root
because we set path-mapping as belows in the configuration file.

```json
{"/var/www/html/src": "${cwd}"}
```

## Security Notice

⚠️ **Important**: Before using these dotfiles, please configure your private settings:

1. Copy example files and update with your credentials:
   ```sh
   cp sh/zsh/private/env.zsh.example sh/zsh/private/env.zsh
   cp sh/zsh/private/alias.zsh.example sh/zsh/private/alias.zsh
   ```

2. Update placeholders in private files with your actual values:
   - `YOUR_GITHUB_TOKEN`: Your GitHub personal access token
   - `YOUR_CLAUDE_API_TOKEN`: Your Claude API key
   - `YOUR_COMPANY_DOMAIN`: Your company's domain
   - `YOUR_USERNAME`: Your username
   - Other placeholder values as needed

3. **Never commit private files** - they are already in `.gitignore`

4. **Review all configurations** before using in your environment

## Available mise Tasks

### Dotfiles Management
- `mise run deploy` - Deploy dotfiles symlinks
- `mise run dotfiles:update` - Update from git and redeploy
- `mise run dotfiles:status` - Show git status

### System Maintenance
- `mise run brew:update` - Update Homebrew and all packages
- `mise run brew:dump` - Update Brewfile with installed packages
- `mise run brew:check` - Check if all Brewfile packages are installed
- `mise run cache:clean` - Clean system caches

### Utilities
- `mise run myip` - Show public IP address
- `mise run ports` - List all listening ports
- `mise run dns:flush` - Flush DNS cache (macOS)
- `mise run git:cleanup` - Delete merged git branches
- `mise run sysinfo` - Show system information

Run `mise tasks` to see all available tasks with descriptions.

# Brewfile Management

This repository includes a `Brewfile` (located in `installers/`) to manage Homebrew packages.

## Package Categories
- **System Tools**: bash, gnu-sed, wget
- **Development Tools**: mise, openjdk, gh, jq, ripgrep
- **Shell & CLI Enhancement**: sheldon, zoxide, neovim
- **GUI Applications**: claude-code, jetbrains-toolbox, wezterm

