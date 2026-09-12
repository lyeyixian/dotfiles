#!/usr/bin/env bash
# .gitconfig sets the editor to VS Code and includes ~/.gitconfig.local last,
# so a value there wins. This machine gets nvim.
. "$(dirname "${BASH_SOURCE[0]}")/../helper/lib.sh"

step "git editor"
if [ -f "$HOME/.gitconfig.local" ]; then
  echo "~/.gitconfig.local already exists, leaving it alone"
else
  git config --file "$HOME/.gitconfig.local" core.editor nvim
  echo "wrote ~/.gitconfig.local"
fi
