#!/usr/bin/env bash
# Link the Claude Code settings and install Claude Code if it is missing.
. "$(dirname "${BASH_SOURCE[0]}")/../helper/lib.sh"

step "link claude"
# ~/.claude must exist as a real directory first. Otherwise Stow links the
# whole folder and Claude Code writes its history and caches into this repo.
mkdir -p "$HOME/.claude"
link claude .claude/CLAUDE.md .claude/settings.json .claude/statusline-command.sh

step "claude code"
if command -v claude >/dev/null 2>&1; then
  echo "already installed: $(command -v claude)"
else
  curl -fsSL https://claude.ai/install.sh | bash
fi
