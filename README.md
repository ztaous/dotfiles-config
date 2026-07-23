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

An existing file is moved to the same path with a `.bak` suffix before a link
is created. Running the script again leaves correct links unchanged.

After the first run, `~/.ssh/id_ed25519_github.pub` should be added to GitHub as an
authentication and signing key.

## Configuration

- `.editorconfig` is linked to `~/.editorconfig`.
- `.clang-format` is linked to `~/.clang-format`.
- `git/config` is linked to `~/.config/git/config`.
- `ssh/config` is linked to `~/.ssh/config`.
- `tmux/tmux.conf` is linked to `~/.config/tmux/tmux.conf`.
- `nvim/` is linked to `~/.config/nvim`.
