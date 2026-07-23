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
  packages=(bash git tmux fzf ripgrep fd neovim tree-sitter-cli)
  missing=()
  for package in "${packages[@]}"; do
    brew list --versions "$package" >/dev/null 2>&1 || missing+=("$package")
  done
  if [ "${#missing[@]}" -gt 0 ]; then
    brew install "${missing[@]}"
  fi
  warn_neovim_version
  exit 0
fi

. /etc/os-release

case "${ID:-}" in
  debian|ubuntu)
    packages=(git tmux fzf ripgrep fd-find neovim)
    missing=()
    for package in "${packages[@]}"; do
      dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -qx "install ok installed" ||
        missing+=("$package")
    done
    if [ "${#missing[@]}" -gt 0 ]; then
      sudo apt update
      sudo apt install -y "${missing[@]}"
    fi
    ;;
  fedora|rhel|centos)
    packages=(git tmux fzf ripgrep fd-find neovim)
    missing=()
    for package in "${packages[@]}"; do
      rpm -q "$package" >/dev/null 2>&1 || missing+=("$package")
    done
    if [ "${#missing[@]}" -gt 0 ]; then
      sudo dnf install -y "${missing[@]}"
    fi
    ;;
  arch)
    packages=(git tmux fzf ripgrep fd neovim)
    missing=()
    for package in "${packages[@]}"; do
      pacman -Q "$package" >/dev/null 2>&1 || missing+=("$package")
    done
    if [ "${#missing[@]}" -gt 0 ]; then
      sudo pacman -Syu --needed --noconfirm "${missing[@]}"
    fi
    ;;
  *)
    echo "unsupported distro: ${ID:-unknown}" >&2
    exit 1
    ;;
esac

warn_neovim_version
