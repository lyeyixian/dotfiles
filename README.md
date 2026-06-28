# dotfiles

My personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a **Stow package** whose contents mirror `$HOME`.
Running `stow <package>` symlinks that package's files into the home directory,
so the real files live here (under version control) and `$HOME` just points at them.

## What's in here

| Package       | Symlinks into                                                  | What it is                          |
| ------------- | -------------------------------------------------------------- | ----------------------------------- |
| `zsh`         | `~/.zshrc`, `~/.p10k.zsh`                                       | Zsh + Powerlevel10k prompt          |
| `git`         | `~/.gitconfig`, `~/.gitignore_global`                          | Git config + global ignore patterns |
| `tmux`        | `~/.tmux.conf`, `~/.gitmux.conf`                               | tmux + gitmux status bar            |
| `nvim`        | `~/.config/nvim/`                                              | Neovim (LazyVim) config             |
| `linearmouse` | `~/.config/linearmouse/linearmouse.json`                       | LinearMouse settings                |
| `opencode`    | `~/.config/opencode/opencode.json`                             | opencode config                     |
| `claude`      | `~/.claude/settings.json`, `~/.claude/statusline-command.sh`   | Claude Code settings + statusline   |

Secrets, caches, history, and package-manager state are intentionally **not** tracked.
All paths use `$HOME` / `~` so the configs are portable across machines and usernames.

Two directories are **not** Stow packages and are set up manually (see below):

- `Brewfile` — Homebrew tools + fonts, installed with `brew bundle`.
- `iterm/` — iTerm2 color preset (`catppuccin-macchiato`), imported into iTerm2.

## Setup on a new machine

```sh
# 1. Clone
git clone https://github.com/lyeyixian/dotfiles ~/.dotfiles
cd ~/.dotfiles

# 2. Prerequisites
brew bundle --file ~/.dotfiles/Brewfile     # core tools + Nerd Font
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"   # oh-my-zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"   # powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"        # zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"    # zsh-syntax-highlighting
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm  # tmux plugin manager

# 3. Symlink everything
stow zsh git tmux nvim linearmouse opencode claude
```

Then:

- Open a new shell to load zsh / Powerlevel10k.
- In tmux, press `prefix + I` to let `tpm` install the plugins.
- On first launch, Neovim (LazyVim) will bootstrap its plugins automatically.

### Terminal (iTerm2)

The prompt, LazyVim and tmux all rely on Nerd Font glyphs and a matching color
theme. `brew bundle` above installs the font; set it and the theme in iTerm2:

1. **Font** — Settings (`⌘,`) → Profiles → *Text* → Font → **MesloLGS Nerd Font
   Mono**. Leave *"Use a different font for non-ASCII text"* unchecked, or icons
   render as `?`.
2. **Theme** — Settings → Profiles → *Colors* → **Color Presets… → Import…**,
   pick `iterm/catppuccin-macchiato.itermcolors` from this repo, then select
   **catppuccin-macchiato** from the same dropdown.

## Usage

```sh
cd ~/.dotfiles

stow <package>      # link a package's files into $HOME
stow -D <package>   # unlink (remove the symlinks)
stow -R <package>   # restow (refresh after adding/removing files)
```

### Adding a new config

1. Create the package dir mirroring its path under `$HOME`, e.g.
   `mkdir -p newtool/.config/newtool`
2. Move the real config into it:
   `mv ~/.config/newtool/config.toml newtool/.config/newtool/`
3. Link it back: `stow newtool`
4. Commit and push.

## Notes

- If `stow` reports a conflict, an existing real file is in the way — back it up or
  remove it, then re-run `stow`. Use `stow -nv <package>` to dry-run first.
- Neovim's config was absorbed here (its standalone git history is not preserved).
