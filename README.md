# dotfiles

Personal configuration for Bash, Git, SSH, tmux, Neovim, and coding agents.

## Supported systems

- Debian and Ubuntu
- Fedora, RHEL, and CentOS
- Arch Linux
- Apple Silicon macOS

## Setup

Clone the repository and run:

```sh
./run.sh
```

The script installs command-line packages, links the configuration files, and
creates a GitHub SSH key if one does not already exist.

### After setup

Add the generated public key at <https://github.com/settings/keys> as both an
authentication key and a signing key. The script copies the key to the clipboard
on macOS and prints it on Linux.

On Apple Silicon macOS, the setup installs Homebrew when needed and changes the
login shell to Homebrew Bash. The Homebrew installer may request your password
and install Apple's Command Line Tools. Open a new terminal after the shell
changes.

## Selective setup

Run individual parts without installing packages:

```sh
./run.sh tmux
./run.sh nvim
./run.sh agents
./run.sh bash git ssh
```

Available targets are `packages`, `format`, `git`, `bash`, `ssh`, `tmux`, `nvim`,
and `agents`. Include `packages` explicitly when package installation is needed.

## Backups

Before replacing an existing configuration, the setup moves it to the same path
with a `.bak` suffix. A later replacement overwrites the previous backup.
Correct links remain unchanged when the setup runs again.

Remove backups created for managed configuration paths with:

```sh
./run.sh --clear-backups
```

This command does not change the active configuration.

## Components

| Source | Configured location |
|---|---|
| `.editorconfig` | `~/.editorconfig` |
| `.clang-format` | `~/.clang-format` |
| `bash/bash_profile` | `~/.bash_profile` |
| `bash/bashrc` | `~/.bashrc` |
| `git/config` | `~/.config/git/config` |
| `ssh/config` | GitHub entry in `~/.ssh/config` |
| `tmux/tmux.conf` | `~/.config/tmux/tmux.conf` |
| `nvim/` | `~/.config/nvim` |
| `agents/AGENTS.md` | Codex, Claude Code, and OpenCode user instructions |

See [Neovim](nvim/README.md) and [tmux](tmux/README.md) for component usage.
