#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

have() { command -v "$1" >/dev/null 2>&1; }

log() { printf "\n[setup] %s\n" "$*"; }

install_homebrew() {
    if have brew; then
        return 0
    fi

    log "Homebrew not found. Installing Linuxbrew (no sudo)."
    NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
        eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
    fi
}

ensure_brew_shellenv_line() {
    local line='eval "$($(command -v brew) shellenv)"'
    local shell_rc="${HOME}/.zshrc"

    if [ -n "${SHELL:-}" ] && [[ "$SHELL" == */bash ]]; then
        shell_rc="${HOME}/.bashrc"
    fi

    if ! grep -Fq "$line" "$shell_rc" 2>/dev/null; then
        log "Adding brew shellenv to ${shell_rc}"
        printf '\n# Homebrew\n%s\n' "$line" >>"$shell_rc"
    fi
}

install_core_packages() {
    log "Installing core packages with Homebrew"
    brew update
    brew install \
        neovim \
        fzf \
        ripgrep \
        fd \
        lazygit \
        xclip \
        luarocks
}

link_nvim_config() {
    mkdir -p "$(dirname "$CONFIG_DIR")"

    if [ -L "$CONFIG_DIR" ] || [ -e "$CONFIG_DIR" ]; then
        if [ "$(readlink -f "$CONFIG_DIR" 2>/dev/null || true)" = "$REPO_DIR" ]; then
            log "Neovim config already linked"
            return 0
        fi
        log "Existing ${CONFIG_DIR} found. Backing up to ${CONFIG_DIR}.bak.$(date +%s)"
        mv "$CONFIG_DIR" "${CONFIG_DIR}.bak.$(date +%s)"
    fi

    log "Linking ${REPO_DIR} -> ${CONFIG_DIR}"
    ln -s "$REPO_DIR" "$CONFIG_DIR"
}

bootstrap_lazyvim() {
    log "Bootstrapping plugins with headless Neovim"
    nvim --headless "+Lazy! sync" +qa
}

print_apt_fallback() {
    cat <<'EOF'

[setup] Optional apt fallback (requires sudo, not run automatically):
  sudo apt update
  sudo apt install -y neovim git curl wget fzf ripgrep fd-find build-essential unzip xclip nodejs npm luarocks
  # lazygit from apt may be outdated on some distros; prefer brew lazygit.
EOF
}

main() {
    install_homebrew
    ensure_brew_shellenv_line

    if ! have brew; then
        log "brew still unavailable in current shell. Re-open shell and re-run ./setup"
        exit 1
    fi

    install_core_packages
    link_nvim_config
    bootstrap_lazyvim
    print_apt_fallback

    log "Done."
    log "Open Neovim with: nvim"
}

main "$@"
