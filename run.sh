#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSH_KEY="$HOME/.ssh/id_ed25519_github"

link() {
  local src="$DOTFILES/$1" dst="$HOME/$2"
  if [ ! -e "$src" ]; then
    echo "missing source: $src" >&2
    return 1
  fi
  mkdir -p "$(dirname "$dst")"
  [ "$(readlink "$dst" 2>/dev/null)" = "$src" ] && return
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    if [ -e "$dst.bak" ] || [ -L "$dst.bak" ]; then
      echo "backup already exists: $dst.bak" >&2
      return 1
    fi
    mv "$dst" "$dst.bak"
    echo "backed up $dst -> $dst.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "linked $2"
}

install_packages() {
  bash "$DOTFILES/scripts/packages.sh"
}

prepare_ssh_dir() {
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
}

setup_macos() {
  [ "$(uname)" = "Darwin" ] || return 0
  bash "$DOTFILES/scripts/macos.sh"
}

link_configs() {
  link .editorconfig      .editorconfig
  link .clang-format      .clang-format
  link git/config         .config/git/config
  prepare_ssh_dir
  link ssh/config         .ssh/config
  link tmux/tmux.conf     .config/tmux/tmux.conf
  if [ -d "$DOTFILES/nvim" ]; then
    link nvim .config/nvim
  else
    echo "warning: nvim config not found; skipping link" >&2
  fi
}

gen_ssh_key() {
  prepare_ssh_dir
  if [ -f "$SSH_KEY" ]; then
    chmod 600 "$SSH_KEY"
    return
  fi
  if [ ! -t 0 ]; then
    echo "SSH key generation requires an interactive terminal" >&2
    return 1
  fi
  ssh-keygen -t ed25519 -f "$SSH_KEY" -C "$(whoami)@$(hostname)"
  echo
  echo "add this public key to GitHub (auth and/or signing):"
  cat "$SSH_KEY.pub"
}

install_packages
setup_macos
link_configs
gen_ssh_key
