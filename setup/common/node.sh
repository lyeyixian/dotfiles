#!/usr/bin/env bash
# nvm and the current Node LTS. .zshrc loads nvm, and Neovim's TypeScript
# tooling needs npm.
. "$(dirname "${BASH_SOURCE[0]}")/../helper/lib.sh"

step "nvm and node"
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  echo "nvm already installed"
else
  NVM_VER=$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest \
    | grep -oE '"tag_name": *"[^"]+"' | cut -d'"' -f4)
  PROFILE=/dev/null bash -c \
    "curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VER}/install.sh | bash"
fi
set +u
. "$HOME/.nvm/nvm.sh"
nvm install --lts
set -u
