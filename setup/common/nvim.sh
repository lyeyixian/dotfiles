#!/usr/bin/env bash
# Link the Neovim config and install the plugins pinned in lazy-lock.json.
# Mason and treesitter finish on the first interactive launch.
. "$(dirname "${BASH_SOURCE[0]}")/../helper/lib.sh"

step "link nvim"
link nvim .config/nvim

step "neovim plugins"
# On a fresh machine lazy.nvim installs every missing plugin at its newest
# commit and rewrites the lockfile before restore gets a chance to run. Keep a
# copy, let that first run happen, put the lockfile back, then restore for real.
lock="$DOTFILES/nvim/.config/nvim/lazy-lock.json"
saved="$(mktemp)"
cp "$lock" "$saved"
nvim --headless "+Lazy! restore" +qa
cp "$saved" "$lock"
rm "$saved"
nvim --headless "+Lazy! restore" +qa
