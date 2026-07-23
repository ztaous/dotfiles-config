#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSH_KEY="$HOME/.ssh/id_ed25519_github"

clear_backup() {
  local backup="$1.bak"
  if [ -e "$backup" ] || [ -L "$backup" ]; then
    rm -rf "$backup"
  fi
}

link() {
  local src="$DOTFILES/$1" dst="$HOME/$2"
  if [ ! -e "$src" ]; then
    echo "missing source: $src" >&2
    return 1
  fi
  mkdir -p "$(dirname "$dst")"
  [ "$(readlink "$dst" 2>/dev/null)" = "$src" ] && return
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    clear_backup "$dst"
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

has_github_host() {
  grep -Eiq '^[[:space:]]*Host[[:space:]]+([^#]*[[:space:]])?github\.com([[:space:]]|$)' "$1" 2>/dev/null
}

configure_ssh() {
  local config="$HOME/.ssh/config"

  if [ -L "$config" ]; then
    if has_github_host "$config"; then
      return
    fi
    echo "SSH config is a symlink; add the GitHub host to its source" >&2
    return 1
  fi

  if [ ! -e "$config" ]; then
    cp "$DOTFILES/ssh/config" "$config"
    chmod 600 "$config"
    echo "created .ssh/config"
    return
  fi

  if has_github_host "$config"; then
    chmod 600 "$config"
    return
  fi

  clear_backup "$config"
  mv "$config" "$config.bak"
  {
    cat "$DOTFILES/ssh/config"
    printf '\n'
    cat "$config.bak"
  } > "$config"
  chmod 600 "$config"
  echo "updated .ssh/config"
}

setup_macos() {
  [ "$(uname)" = "Darwin" ] || return 0
  bash "$DOTFILES/scripts/macos.sh"
}

link_format() {
  link .editorconfig      .editorconfig
  link .clang-format      .clang-format
}

link_git() {
  link git/config         .config/git/config
}

link_tmux() {
  link tmux/tmux.conf     .config/tmux/tmux.conf
}

link_nvim() {
  if [ -d "$DOTFILES/nvim" ]; then
    link nvim .config/nvim
  else
    echo "warning: nvim config not found; skipping link" >&2
  fi
}

gen_ssh_key() {
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

setup_packages() {
  install_packages
  setup_macos
}

setup_ssh() {
  prepare_ssh_dir
  configure_ssh
  gen_ssh_key
}

setup_all() {
  setup_packages
  link_format
  link_git
  setup_ssh
  link_tmux
  link_nvim
}

usage() {
  echo "usage: ${0##*/} [all|packages|format|git|ssh|tmux|nvim]..."
}

validate_target() {
  case "$1" in
    all|packages|format|git|ssh|tmux|nvim) ;;
    *)
      echo "unknown target: $1" >&2
      usage >&2
      return 1
      ;;
  esac
}

run_target() {
  case "$1" in
    all) setup_all ;;
    packages) setup_packages ;;
    format) link_format ;;
    git) link_git ;;
    ssh) setup_ssh ;;
    tmux) link_tmux ;;
    nvim) link_nvim ;;
  esac
}

if [ "$#" -eq 0 ]; then
  setup_all
  exit
fi

if [ "$#" -eq 1 ] && { [ "$1" = "-h" ] || [ "$1" = "--help" ]; }; then
  usage
  exit
fi

for target in "$@"; do
  validate_target "$target"
done

if [ "$#" -gt 1 ]; then
  for target in "$@"; do
    if [ "$target" = "all" ]; then
      echo "all cannot be combined with other targets" >&2
      exit 1
    fi
  done
fi

for target in "$@"; do
  run_target "$target"
done
