#!/usr/bin/env bash
# Clone or update my skills library at ~/.skills, then link each skill into the folders
# agents read: ~/.agents/skills for any agent, ~/.claude/skills for Claude Code.
. "$(dirname "${BASH_SOURCE[0]}")/../helper/lib.sh"

SKILLS="$HOME/.skills"

step "skills library"
if [ -d "$SKILLS/.git" ]; then
  # Fast-forward only, so local edits or unpushed commits are never merged
  # or overwritten. Linking still runs if the pull can't.
  git -C "$SKILLS" pull --ff-only -q && echo "pulled $SKILLS" ||
    echo "could not fast-forward $SKILLS, linking what is there"
else
  clone_if_missing https://github.com/lyeyixian/skills "$SKILLS"
fi

step "link skills"
for dest in "$HOME/.agents/skills" "$HOME/.claude/skills"; do
  # An older setup stowed ~/.claude/skills as a whole folder into this repo.
  # Linking into it would write into the repo, so stop and say so.
  if [ -L "$dest" ]; then
    echo "skip $dest: it is a symlink to $(readlink "$dest"). Remove it and rerun."
    continue
  fi
  mkdir -p "$dest"
  for skill in "$SKILLS"/skills/*/; do
    name="$(basename "$skill")"
    if [ -e "$dest/$name" ] && [ ! -L "$dest/$name" ]; then
      echo "skip $dest/$name: a real folder is already there"
      continue
    fi
    ln -sfn "${skill%/}" "$dest/$name"
  done
  # Drop links to skills the library no longer has.
  for link in "$dest"/*; do
    [ -L "$link" ] || continue
    case "$(readlink "$link")" in
      "$SKILLS"/*) [ -e "$link" ] || { rm "$link"; echo "removed stale $link"; } ;;
    esac
  done
  echo "linked $(find "$dest" -maxdepth 1 -lname "$SKILLS/*" | wc -l | tr -d ' ') skills into $dest"
done
