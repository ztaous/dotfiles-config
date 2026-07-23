# dotfiles

Configuration for Git, SSH, tmux, and Neovim.

## Setup

Supported systems:

- Debian and Ubuntu
- Fedora, RHEL, and CentOS
- Arch Linux
- macOS with Homebrew

Clone the repository and run:

```sh
./run.sh
```

The script installs Git, tmux, fzf, ripgrep, fd, and Neovim. It then creates
the configuration links and generates an SSH key when one does not already
exist.

Individual parts can be run on their own:

```sh
./run.sh tmux
./run.sh nvim
./run.sh git ssh
```

Available targets are `packages`, `format`, `git`, `ssh`, `tmux`, and `nvim`.
Component targets do not install packages unless `packages` is included.

An existing destination is moved to the same path with a `.bak` suffix before
a link is created. A later replacement overwrites the previous backup.
Running the script again leaves correct links unchanged.

After the first run, `~/.ssh/id_ed25519_github.pub` should be added to GitHub as an
authentication and signing key.

## Configuration

- `.editorconfig` is linked to `~/.editorconfig`.
- `.clang-format` is linked to `~/.clang-format`.
- `git/config` is linked to `~/.config/git/config`.
- `tmux/tmux.conf` is linked to `~/.config/tmux/tmux.conf`.
- `nvim/` is linked to `~/.config/nvim`.

The GitHub entry from `ssh/config` is added to `~/.ssh/config` when missing.
