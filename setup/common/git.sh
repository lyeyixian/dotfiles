#!/usr/bin/env bash
# Link the git package.
. "$(dirname "${BASH_SOURCE[0]}")/../helper/lib.sh"

step "link git"
link git .gitconfig .gitignore_global
