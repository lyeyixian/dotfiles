#!/usr/bin/env bash
# Install everything in the Brewfile. Needs Homebrew already on the machine.
. "$(dirname "${BASH_SOURCE[0]}")/../helper/lib.sh"

step "brew bundle"
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. See https://brew.sh" >&2
  exit 1
fi
brew bundle --file "$DOTFILES/Brewfile"
