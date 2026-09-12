#!/usr/bin/env bash
# Set up these dotfiles on a Mac. Safe to run again.
#
# Runs the scripts in setup/macos and setup/common in order. Each of them also
# works on its own, so run one directly when you only want that tool:
#   ~/.dotfiles/setup/common/nvim.sh
#
# Needs Homebrew first. SKIP_BREW=1 skips the Brewfile step.
set -euo pipefail
setup="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

[ -n "${SKIP_BREW:-}" ] || "$setup/macos/brew.sh"
"$setup/common/node.sh"
"$setup/common/git.sh"
"$setup/common/tmux.sh"
"$setup/common/nvim.sh"
"$setup/common/claude.sh"
"$setup/common/zsh.sh"
"$setup/macos/extras.sh"

printf '\n\033[1;34m==> done\033[0m\nOpen a new terminal window. iTerm2 font and colors are still manual, see the README.\n'
