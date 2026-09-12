#!/usr/bin/env bash
# oh-my-zsh, the Powerlevel10k theme, the two plugins .zshrc loads, then link
# the zsh package.
. "$(dirname "${BASH_SOURCE[0]}")/../helper/lib.sh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

step "oh-my-zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "already installed"
else
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
clone_if_missing https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
mkdir -p "$ZSH_CUSTOM/completions"

step "link zsh"
# The oh-my-zsh installer writes its own ~/.zshrc. Move it aside.
link zsh .zshrc .p10k.zsh
