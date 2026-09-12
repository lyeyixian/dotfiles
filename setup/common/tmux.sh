#!/usr/bin/env bash
# tpm, the tmux package, and the plugins .tmux.conf lists.
. "$(dirname "${BASH_SOURCE[0]}")/../helper/lib.sh"

step "tmux plugin manager"
clone_if_missing https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

step "link tmux"
link tmux .tmux.conf .gitmux.conf

step "tmux plugins"
"$HOME/.tmux/plugins/tpm/bin/install_plugins"
