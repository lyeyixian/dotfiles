#!/usr/bin/env bash
# Make zsh the login shell. Asks for your password.
. "$(dirname "${BASH_SOURCE[0]}")/../helper/lib.sh"

step "login shell"
zsh_path="$(command -v zsh)"
if [ "$(getent passwd "$USER" | cut -d: -f7)" = "$zsh_path" ]; then
  echo "already zsh"
else
  chsh -s "$zsh_path"
fi
