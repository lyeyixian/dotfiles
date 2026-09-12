# Shared helpers for the setup scripts. Source this, don't run it.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export PATH="$HOME/.local/bin:$PATH"

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

clone_if_missing() {
  local url=$1 dest=$2
  if [ -d "$dest/.git" ]; then
    echo "already cloned: $dest"
  else
    git clone --depth=1 "$url" "$dest"
  fi
}

# Move a real file out of the way so Stow can put a symlink there.
move_aside() {
  local f=$1
  [ -e "$f" ] || return 0
  [ -L "$f" ] && return 0
  # When Stow linked the parent folder, the file is already the repo copy.
  case "$(cd "$(dirname "$f")" && pwd -P)/$(basename "$f")" in
    "$DOTFILES"/*) return 0 ;;
  esac
  mv "$f" "$f.pre-dotfiles"
  echo "moved $f to $f.pre-dotfiles"
}

# Restow one package. Arguments after the package name are files in $HOME
# that would conflict and should be moved aside first.
link() {
  local pkg=$1; shift
  for f in "$@"; do move_aside "$HOME/$f"; done
  (cd "$DOTFILES" && stow -R "$pkg")
  echo "linked $pkg"
}
