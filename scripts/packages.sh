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
  if [ "$(uname -m)" != "arm64" ]; then
    echo "this macOS setup targets Apple Silicon" >&2
    exit 1
  fi

  if ! command -v brew >/dev/null 2>&1; then
    echo "installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"

  packages=(bash git tmux fzf ripgrep fd neovim tree-sitter-cli go node openjdk@21 python rust sqlite)
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
    packages=(git tmux fzf ripgrep fd-find neovim tree-sitter-cli build-essential golang-go nodejs npm openjdk-21-jdk python3 python3-pip python3-venv rustc cargo rustfmt sqlite3 wl-clipboard xclip)
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
    packages=(git tmux fzf ripgrep fd-find neovim tree-sitter-cli gcc golang nodejs npm java-21-openjdk-devel python3 python3-pip rust cargo rustfmt sqlite)
    if [ "$ID" = "fedora" ]; then
      packages+=(wl-clipboard xclip)
    fi
    missing=()
    for package in "${packages[@]}"; do
      rpm -q "$package" >/dev/null 2>&1 || missing+=("$package")
    done
    if [ "${#missing[@]}" -gt 0 ]; then
      sudo dnf install -y "${missing[@]}"
    fi
    ;;
  arch)
    packages=(git tmux fzf ripgrep fd neovim tree-sitter-cli gcc go nodejs npm jdk21-openjdk python python-pip rust sqlite wl-clipboard xclip)
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
