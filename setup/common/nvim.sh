#!/usr/bin/env bash
# Link the Neovim config and install the plugins pinned in lazy-lock.json.
# Mason and treesitter finish on the first interactive launch.
. "$(dirname "${BASH_SOURCE[0]}")/../helper/lib.sh"

step "link nvim"
link nvim .config/nvim

step "neovim plugins"
nvim --headless "+Lazy! restore" +qa
