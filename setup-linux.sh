#!/usr/bin/env bash
# Set up these dotfiles on a Debian or Ubuntu machine. Safe to run again.
#
# Runs the scripts in setup/linux and setup/common in order. Each of them also
# works on its own, so run one directly when you only want that tool:
#   ~/.dotfiles/setup/common/nvim.sh
#
# apt and chsh ask for your password. SKIP_APT=1 skips the apt step.
set -euo pipefail
setup="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

[ -n "${SKIP_APT:-}" ] || "$setup/linux/apt.sh"
"$setup/common/node.sh"
"$setup/common/git.sh"
"$setup/linux/git-editor.sh"
"$setup/common/tmux.sh"
"$setup/common/nvim.sh"
"$setup/common/claude.sh"
"$setup/common/zsh.sh"
"$setup/linux/login-shell.sh"

printf '\n\033[1;34m==> done\033[0m\nLog out and back in for zsh to take over.\n'
