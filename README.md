# dotfiles

Configuration for Bash, Git, SSH, tmux, Neovim, and coding agents.

## Setup

Supported systems:

- Debian and Ubuntu
- Fedora, RHEL, and CentOS
- Arch Linux
- Apple Silicon macOS

Clone the repository and run:

```sh
./run.sh
```

The script installs the command-line packages for the current platform, creates
the configuration links, and generates an SSH key when one does not already
exist.

On Apple Silicon macOS, it also installs Homebrew when needed and makes
Homebrew Bash the login shell. Homebrew's installer may ask for your password
and install Apple's Command Line Tools. Open a new terminal after the login
shell changes.

Individual parts can be run on their own:

```sh
./run.sh tmux
./run.sh nvim
./run.sh agents
./run.sh bash git ssh
```

Available targets are `packages`, `format`, `git`, `bash`, `ssh`, `tmux`, `nvim`, and `agents`.
Component targets do not install packages unless `packages` is included.

An existing destination is moved to the same path with a `.bak` suffix before
a link is created. A later replacement overwrites the previous backup.
Running the script again leaves correct links unchanged.

Remove backups created for managed configuration paths without changing the
active configuration:

```sh
./run.sh --clear-backups
```

After generating an SSH key on macOS, the script copies its public key to the
clipboard. Add it at <https://github.com/settings/keys> once as an
authentication key and again as a signing key.

## Configuration

- `.editorconfig` is linked to `~/.editorconfig`.
- `.clang-format` is linked to `~/.clang-format`.
- `bash/bash_profile` is linked to `~/.bash_profile`.
- `bash/bashrc` is linked to `~/.bashrc`.
- `git/config` is linked to `~/.config/git/config`.
- `tmux/tmux.conf` is linked to `~/.config/tmux/tmux.conf`.
- `nvim/` is linked to `~/.config/nvim`.
- `agents/AGENTS.md` provides shared personal instructions for Codex, Claude
  Code, and OpenCode.

The GitHub entry from `ssh/config` is added to `~/.ssh/config` when missing.
