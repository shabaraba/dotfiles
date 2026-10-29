#!/usr/bin/env bash
set -euo pipefail

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_AUTOREMOVE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

mise install
mise reshim

# Check every replacement before removing any old installation.
replacements=(
    go:go node:node deno:deno
    gh:gh jq:jq ripgrep:rg fd:fd fzf:fzf bat:bat git-delta:delta jj:jj
    zoxide:zoxide lsd:lsd peco:peco stylua:stylua black:black
    tree-sitter-cli:tree-sitter uv:uv awscli:aws terraform:terraform
    cmake:cmake gradle:gradle cloudflared:cloudflared eslint_d:eslint_d yarn:yarn
)
commands=(graphify graphify-mcp)
if [[ "$(uname -sm)" == 'Darwin arm64' ]]; then
    commands+=(mlx_lm.generate mlx_vlm.generate)
fi
for replacement in "${replacements[@]}"; do
    commands+=("${replacement#*:}")
done
for binary in "${commands[@]}"; do
    resolved="$(mise which "$binary")"
    case "$resolved" in
        "${MISE_DATA_DIR:-$HOME/.local/share/mise}"/installs/*)
            [[ -x "$resolved" ]] || exit 1
            ;;
        *) echo "Replacement is not managed by mise: $binary ($resolved)" >&2; exit 1 ;;
    esac
done

for replacement in "${replacements[@]}"; do
    formula="${replacement%%:*}"
    if ! brew list --formula "$formula" >/dev/null 2>&1; then
        continue
    fi
    dependents="$(brew uses --installed "$formula")"
    if [[ -n "$dependents" ]]; then
        printf 'Keeping %s: required by\n%s\n' "$formula" "$dependents"
        continue
    fi
    brew uninstall --force --formula "$formula"
done

# nvm is disabled in the shell configuration; mise owns Node.js.
if brew list --formula nvm >/dev/null 2>&1 && [[ -z "$(brew uses --installed nvm)" ]]; then
    brew uninstall --force --formula nvm
fi

uv_tools="$(uv tool list 2>/dev/null)"
for package in graphifyy mlx-lm mlx-vlm; do
    if [[ "$package" != graphifyy && "$(uname -sm)" != 'Darwin arm64' ]]; then
        continue
    fi
    if printf '%s\n' "$uv_tools" | grep -q "^$package v"; then
        uv tool uninstall "$package"
    fi
done

echo 'Consolidation complete. Restart the shell to refresh command paths.'
