#!/usr/bin/env bash
# Install the apt packages every other script needs, and the UTF-8 locale.
. "$(dirname "${BASH_SOURCE[0]}")/../helper/lib.sh"

PACKAGES=(git zsh tmux neovim stow curl jq ripgrep fd-find fzf unzip build-essential python3-venv locales)

step "apt packages"
missing=()
for p in "${PACKAGES[@]}"; do
  dpkg -s "$p" >/dev/null 2>&1 || missing+=("$p")
done
if [ ${#missing[@]} -gt 0 ]; then
  sudo apt-get update
  sudo apt-get install -y "${missing[@]}"
else
  echo "all installed"
fi

if ! locale -a 2>/dev/null | grep -qi 'en_US.utf8'; then
  sudo locale-gen en_US.UTF-8
fi

# Ubuntu ships fd as fdfind. Neovim's pickers look for fd.
mkdir -p "$HOME/.local/bin"
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi
