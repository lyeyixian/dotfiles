# dotfiles

Config files for my macOS setup: zsh, git, tmux, Neovim, iTerm2, Claude Code, and a
few smaller tools. [GNU Stow](https://www.gnu.org/software/stow/) wires them into
`$HOME` as symlinks, so the real files stay here under version control and `$HOME`
just points at them. Edit a file in this repo and the change is live immediately.

Each top-level directory is a Stow package whose inside mirrors `$HOME`. For example
`zsh/.zshrc` becomes `~/.zshrc`, and `nvim/.config/nvim/` becomes `~/.config/nvim/`.
Read the tree that way and you always know where a file will land.

## What's here

| Package       | Links into                                                                                              | What it is                              |
| ------------- | ------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| `zsh`         | `~/.zshrc`, `~/.p10k.zsh`                                                                               | Zsh with oh-my-zsh and Powerlevel10k    |
| `git`         | `~/.gitconfig`, `~/.gitignore_global`                                                                   | Git config, aliases, global ignores     |
| `tmux`        | `~/.tmux.conf`, `~/.gitmux.conf`                                                                        | tmux with catppuccin status bar         |
| `nvim`        | `~/.config/nvim/`                                                                                       | Neovim on LazyVim                       |
| `linearmouse` | `~/.config/linearmouse/linearmouse.json`                                                                | LinearMouse pointer settings            |
| `opencode`    | `~/.config/opencode/opencode.json`                                                                      | opencode config                         |
| `claude`      | `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, `~/.claude/statusline-command.sh`, `~/.claude/skills/` | Claude Code memory, settings, skills    |

Two things here are not Stow packages and need a manual step:

- `Brewfile` lists the Homebrew tools, apps, and the Nerd Font. Install with `brew bundle`.
- `iterm/catppuccin-macchiato.itermcolors` is an iTerm2 color preset you import from
  the app's settings.

Secrets, history, caches, and package-manager state are not tracked. Every path uses
`~`, so nothing breaks on a machine with a different username.

## Set up a new machine

You need macOS, the Xcode command line tools (`xcode-select --install`), and
[Homebrew](https://brew.sh). Everything else comes from the steps below.

### 1. Clone

Clone to `~/.dotfiles`. Stow links into the parent of the repo, so the location
matters. If you keep it somewhere else, pass `-t ~` to every `stow` command.

```sh
git clone https://github.com/lyeyixian/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

### 2. Install the tools

```sh
brew bundle --file ~/.dotfiles/Brewfile
```

That covers stow, git, tmux, neovim, the apps, and MesloLGS Nerd Font. Drop any cask
you don't want before running it.

### 3. Install what the configs expect to find

`.zshrc` loads oh-my-zsh, the Powerlevel10k theme, two zsh plugins, and nvm.
`.tmux.conf` ends by running tpm. None of those live in this repo, so install them
first or your first new shell will be full of errors.

```sh
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# zsh plugins
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# nvm, latest release
NVM_VER=$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest \
  | grep -oE '"tag_name": *"[^"]+"' | cut -d'"' -f4)
PROFILE=/dev/null bash -c \
  "curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VER}/install.sh | bash"
```

The oh-my-zsh installer writes its own `~/.zshrc`. That is fine, step 4 replaces it,
but `stow zsh` will refuse to overwrite it, so delete or rename it first:
`rm ~/.zshrc`.

### 4. Link the configs

```sh
cd ~/.dotfiles
stow -nv zsh git tmux nvim linearmouse opencode claude   # dry run, read the output
stow zsh git tmux nvim linearmouse opencode claude       # do it
```

Skip any package you don't want. They are independent.

### 5. Set up iTerm2

Powerlevel10k, LazyVim, and the tmux status bar all draw Nerd Font glyphs. Without
the right font you get `?` and empty boxes.

1. Font: Settings (`⌘,`) then Profiles, Text, Font, pick **MesloLGS Nerd Font Mono**.
   Leave "Use a different font for non-ASCII text" unchecked or the icons break.
2. Colors: Settings, Profiles, Colors, Color Presets, Import, choose
   `~/.dotfiles/iterm/catppuccin-macchiato.itermcolors`, then select
   **catppuccin-macchiato** from that same dropdown.

### 6. First run

- Open a new terminal window. Zsh and Powerlevel10k load from the linked `.zshrc`.
  If the prompt asks to run the configuration wizard, say no. `~/.p10k.zsh` is
  already set up.
- Start tmux and press `Ctrl-Space` then `I` (capital i) to make tpm install its
  plugins. The prefix is `Ctrl-Space`, not the default `Ctrl-b`.
- Run `nvim`. LazyVim installs its plugins on first launch. Let it finish before you
  start editing.
- Run `nvm install --lts` if you want Node.

### 7. Make it yours

`git/.gitconfig` has my name and email in it. Change them before your first commit or
every commit you make will be attributed to me:

```sh
git config --file ~/.dotfiles/git/.gitconfig user.name "Your Name"
git config --file ~/.dotfiles/git/.gitconfig user.email "you@example.com"
```

Two other spots worth a look:

- `git/.gitconfig` sets `core.editor = code --wait`. If you use VS Code, open its
  command palette and run "Shell Command: Install 'code' command in PATH". Otherwise
  change it to `nvim`.
- `zsh/.zshrc` ends with `PATH` entries for a local postgres install and the .NET
  tools. Harmless if those aren't there, but they are mine, not yours.

## Everyday use

All Stow commands run from `~/.dotfiles`.

```sh
stow <package>       # link a package into $HOME
stow -D <package>    # unlink it
stow -R <package>    # relink, use after adding or deleting files
stow -nv <package>   # dry run, prints what it would do
```

Editing an already linked file needs nothing. `$HOME` points straight at the copy in
this repo, so you edit `~/.zshrc` and `zsh/.zshrc` at the same time.

### Adding a new tool's config

```sh
mkdir -p newtool/.config/newtool                        # mirror the path under $HOME
mv ~/.config/newtool/config.toml newtool/.config/newtool/
stow newtool
```

### Adding a file to a package you already stowed

A file you just added has no symlink yet. Restow the package:

```sh
stow -nv -R claude   # check first
stow -R claude
```

Restowing also cleans up. Delete a file from a package, run `stow -R`, and the
dangling symlink in `$HOME` goes away.

This matters most for `claude`. Because `~/.claude/` already exists as a real
directory, Stow links each file individually instead of the folder as a whole, so
every new file needs a restow. Claude Code skills live at
`claude/.claude/skills/<name>/SKILL.md`, and a restow is what puts them in
`~/.claude/skills/`. A running Claude Code session picks up a new skill on its own,
no restart needed.

## When something goes wrong

**Stow says a conflict exists.** A real file is sitting where the symlink should go.
Back it up or delete it, then run `stow` again. `stow -nv <package>` shows you which
file before you touch anything.

**Icons render as `?` or boxes.** The terminal font is not the Nerd Font. Go back to
step 5, and check that the non-ASCII font override is off.

**The tmux status bar is plain or broken.** tpm has not installed the plugins yet.
Press `Ctrl-Space` then `I` inside tmux.

**The Claude Code status line is blank.** `statusline-command.sh` needs `jq`. Recent
macOS ships it at `/usr/bin/jq`. If yours doesn't, `brew install jq`.

**Everything linked but the shell looks wrong.** You are probably still in the old
session. Open a new window rather than sourcing `~/.zshrc`, since Powerlevel10k's
instant prompt wants a fresh shell.
