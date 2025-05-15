# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview
This is a dotfiles repository containing configurations for Neovim, Zsh, terminal emulators, and other development tools.

## Build/Deployment Commands
- `make install` - Install Neovim, Zsh, and deploy dotfiles
- `make deploy` - Deploy dotfiles to home directory 
- `sh deployer.sh` - Manual deployment script

## Project Structure
- `nvim/` - Neovim configuration (Lua-based)
- `sh/` - Shell configurations (zsh, abbreviations, aliases)
- `terminal/` - Terminal emulator configs (wezterm)
- `installers/` - Installation scripts for various tools

## Code Style Guidelines
- **Languages**: Lua (Neovim), Shell script (zsh/bash)
- **Lua style**: Use lowercase_with_underscores for variables/functions, CamelCase for modules
- **Shell style**: Use sh/bash compatible syntax where possible
- **File organization**: Keep configurations modular and organized by function
- **Comments**: Use -- for Lua, # for shell scripts
- **Indentation**: 2 spaces for Lua, 4 spaces for shell scripts
- **Error handling**: Check return codes and file existence before operations
- **Imports**: Use `require()` for Lua modules, `source` for shell scripts

## Testing/Validation
- No automated tests exist; test manually after changes
- Validate shell scripts with `shellcheck` when possible
- Test Neovim configs with `:checkhealth` command after changes

## Git Guidelines
- Use Semantic Commit Messages (feat, fix, chore, test, refactor)
- Commit messages in English only
- Create branches for features (never commit to main directly)
- Owner: shabaraba