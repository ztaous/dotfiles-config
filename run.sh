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

clear_backups() {
  local path
  local paths=(
    "$HOME/.editorconfig"
    "$HOME/.clang-format"
    "$HOME/.bash_profile"
    "$HOME/.bashrc"
    "$HOME/.config/git/config"
    "$HOME/.ssh/config"
    "$HOME/.config/tmux/tmux.conf"
    "$HOME/.config/nvim"
    "$HOME/.codex/AGENTS.md"
    "$HOME/.claude/CLAUDE.md"
    "$HOME/.config/opencode/AGENTS.md"
  )

  for path in "${paths[@]}"; do
    if [ -e "$path.bak" ] || [ -L "$path.bak" ]; then
      clear_backup "$path"
      echo "removed $path.bak"
    fi
  done
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

link_bash() {
  link bash/bash_profile  .bash_profile
  link bash/bashrc        .bashrc
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

sync_skills() {
  local dst skill src target
  local destinations=(
    "$HOME/.agents/skills"
    "$HOME/.claude/skills"
    "$HOME/.config/opencode/skills"
  )

  for dst in "${destinations[@]}"; do
    mkdir -p "$dst"

    for target in "$dst"/*; do
      [ -L "$target" ] || continue
      case "$(readlink "$target")" in
        "$DOTFILES/agents/skills/"*)
          [ -e "$target" ] || {
            rm "$target"
            echo "removed stale skill link ${target#$HOME/}"
          }
          ;;
      esac
    done

    for src in "$DOTFILES"/agents/skills/*; do
      [ -d "$src" ] || continue
      skill="${src##*/}"
      link "agents/skills/$skill" "${dst#$HOME/}/$skill"
    done
  done
}

link_agents() {
  link agents/AGENTS.md .codex/AGENTS.md
  link agents/AGENTS.md .claude/CLAUDE.md
  link agents/AGENTS.md .config/opencode/AGENTS.md
  sync_skills
}

setup_agents() {
  link_agents
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
  if [ "$(uname)" = "Darwin" ]; then
    pbcopy < "$SSH_KEY.pub"
    echo "public key copied to the clipboard"
  else
    cat "$SSH_KEY.pub"
  fi
  echo "add the key at https://github.com/settings/keys"
  echo "add it once as an authentication key and again as a signing key"
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
  link_bash
  setup_ssh
  link_tmux
  link_nvim
  setup_agents
}

usage() {
  echo "usage: ${0##*/} [all|packages|format|git|bash|ssh|tmux|nvim|agents]..."
  echo "       ${0##*/} --clear-backups"
}

validate_target() {
  case "$1" in
    all|packages|format|git|bash|ssh|tmux|nvim|agents) ;;
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
    bash) link_bash ;;
    ssh) setup_ssh ;;
    tmux) link_tmux ;;
    nvim) link_nvim ;;
    agents) setup_agents ;;
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

if [ "$#" -eq 1 ] && [ "$1" = "--clear-backups" ]; then
  clear_backups
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
