#!/usr/bin/env bash
set -euo pipefail

BREW_BASH="/opt/homebrew/bin/bash"

grep -qx "$BREW_BASH" /etc/shells || echo "$BREW_BASH" | sudo tee -a /etc/shells >/dev/null

[ "$SHELL" = "$BREW_BASH" ] || chsh -s "$BREW_BASH"
