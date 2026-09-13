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

step "claude mcp servers"
# User-scoped servers live in ~/.claude.json next to machine state, so they
# can't be stowed. Register them here instead. OAuth sign-in is still manual:
# run /mcp inside Claude Code once per machine.
if claude mcp get linear >/dev/null 2>&1; then
  echo "already added: linear"
else
  claude mcp add --transport http --scope user linear https://mcp.linear.app/mcp
fi
