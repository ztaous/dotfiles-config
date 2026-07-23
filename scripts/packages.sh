#!/usr/bin/env bash
set -euo pipefail

warn_neovim_version() {
  local line version major minor
  line="$(nvim --version 2>/dev/null | sed -n '1p')" || true
  version="$(printf '%s\n' "$line" | sed -n 's/^NVIM v\([0-9][0-9]*\)\.\([0-9][0-9]*\).*/\1 \2/p')"
  if [ -z "$version" ]; then
    echo "warning: unable to determine Neovim version; 0.11+ is required" >&2
    return
  fi
  read -r major minor <<< "$version"
  if [ "$major" -eq 0 ] && [ "$minor" -lt 11 ]; then
    echo "warning: Neovim 0.11+ is required; installed version is ${line#NVIM }" >&2
  fi
}

if [ "$(uname)" = "Darwin" ]; then
  brew install bash git tmux fzf ripgrep fd neovim
  warn_neovim_version
  exit 0
fi

. /etc/os-release

case "${ID:-}" in
  debian|ubuntu)
    sudo apt update
    sudo apt install -y git tmux fzf ripgrep fd-find neovim
    ;;
  fedora|rhel|centos)
    sudo dnf install -y git tmux fzf ripgrep fd-find neovim
    ;;
  arch)
    sudo pacman -Syu --needed --noconfirm git tmux fzf ripgrep fd neovim
    ;;
  *)
    echo "unsupported distro: ${ID:-unknown}" >&2
    exit 1
    ;;
esac

warn_neovim_version
