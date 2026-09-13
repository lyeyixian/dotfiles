# dotfiles

Config files for my Mac and my Linux home server: zsh, git, tmux, Neovim, iTerm2,
Claude Code, and a few smaller tools. [GNU Stow](https://www.gnu.org/software/stow/) wires them into
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

Four things here are not Stow packages:

- `setup-macos.sh` and `setup-linux.sh` do the whole setup on a fresh machine. They
  run the small scripts in `setup/`, one per tool. See below.
- `Brewfile` lists the Homebrew tools, apps, and the Nerd Font. `setup/macos/brew.sh`
  installs it.
- `iterm/catppuccin-macchiato.itermcolors` is an iTerm2 color preset you import from
  the app's settings.

Secrets, history, caches, and package-manager state are not tracked. Every path uses
`~`, so nothing breaks on a machine with a different username.

## Set up a new machine

Clone to `~/.dotfiles`. Stow links into the parent of the repo, so the location
matters. If you keep it somewhere else, pass `-t ~` to every `stow` command.

```sh
git clone https://github.com/lyeyixian/dotfiles ~/.dotfiles
```

Then run the script for your OS. It runs the scripts in `setup/` in order and skips
whatever is already done, so running it twice is fine.

### macOS

Needs the Xcode command line tools (`xcode-select --install`) and
[Homebrew](https://brew.sh) first.

```sh
~/.dotfiles/setup-macos.sh
```

iTerm2 has no config file worth tracking, so its two settings are by hand.
Powerlevel10k, LazyVim, and the tmux status bar all draw Nerd Font glyphs, and
without the font you get `?` and empty boxes.

1. Font: Settings (`⌘,`) then Profiles, Text, Font, pick **MesloLGS Nerd Font Mono**.
   Leave "Use a different font for non-ASCII text" unchecked or the icons break.
2. Colors: Settings, Profiles, Colors, Color Presets, Import, choose
   `~/.dotfiles/iterm/catppuccin-macchiato.itermcolors`, then select
   **catppuccin-macchiato** from that same dropdown.

Open a new terminal window afterwards. If Powerlevel10k asks to run its wizard,
say no. `~/.p10k.zsh` is already set up.

### Linux (Debian or Ubuntu)

```sh
~/.dotfiles/setup-linux.sh
```

It asks for your password twice, once for apt at the start and once for `chsh` at
the end. Log out and back in when it finishes. The glyphs come from the terminal
you ssh from, so the iTerm2 font step above still applies on the client.

Linux gets zsh, git, tmux, nvim, and claude. linearmouse and opencode are Mac only.
The Linux scripts also do a few things the Mac never needs. `.gitconfig` asks for
VS Code as the editor, so `setup/linux/git-editor.sh` writes `core.editor = nvim`
into `~/.gitconfig.local`. That file is included last, wins over anything above it,
and is not tracked. The apt script generates the `en_US.UTF-8` locale, since Ubuntu
ships without one and Nerd Font glyphs come out as `?` over ssh. It also links `fd`
to Ubuntu's `fdfind`, the name Neovim's pickers look for. And `chsh` makes zsh the
login shell, which a Mac has out of the box.

### What the scripts do

| Script                       | What it does                                                          |
| ---------------------------- | --------------------------------------------------------------------- |
| `setup/macos/brew.sh`        | `brew bundle` with the Brewfile                                       |
| `setup/macos/extras.sh`      | `stow linearmouse opencode`                                           |
| `setup/linux/apt.sh`         | apt packages (zsh, tmux, neovim, stow, ripgrep, fd, fzf, jq, a compiler) and the locale |
| `setup/linux/git-editor.sh`  | writes `~/.gitconfig.local` with `core.editor = nvim`                 |
| `setup/linux/login-shell.sh` | `chsh` to zsh                                                         |
| `setup/common/node.sh`       | nvm and the current Node LTS                                          |
| `setup/common/git.sh`        | `stow git`                                                            |
| `setup/common/tmux.sh`       | tpm, `stow tmux`, installs the tmux plugins headless                  |
| `setup/common/nvim.sh`       | `stow nvim`, installs the plugins pinned in `lazy-lock.json` headless |
| `setup/common/claude.sh`     | `stow claude`, installs Claude Code if missing, adds the Linear MCP server |
| `setup/common/zsh.sh`        | oh-my-zsh, Powerlevel10k, the two plugins, `stow zsh`                 |

They share `setup/helper/lib.sh`. Its `link` function is `stow -R` with one extra
step. Stow refuses to overwrite a real file, and a fresh machine always has one in
the way, so `link` first renames it with a `.pre-dotfiles` suffix. The oh-my-zsh
installer's `~/.zshrc` is the usual victim.

Each script works on its own once brew or apt has run, so
`~/.dotfiles/setup/common/nvim.sh` is the way to redo just Neovim. `SKIP_BREW=1`
skips the Brewfile and `SKIP_APT=1` skips apt.

The claude script creates `~/.claude` as a real directory before stowing, so Stow
links the files inside it one by one. If the directory itself were a symlink into
this repo, Claude Code would write its history and caches here.

The nvim script only installs the plugins. Mason and treesitter still finish on the
first interactive launch, so let that run before you start editing.

### Make it yours

`git/.gitconfig` has my name and email in it. Change them before your first commit or
every commit you make will be attributed to me:

```sh
git config --file ~/.dotfiles/git/.gitconfig user.name "Your Name"
git config --file ~/.dotfiles/git/.gitconfig user.email "you@example.com"
```

Two other spots worth a look:

- `git/.gitconfig` sets `core.editor = code --wait`. If you use VS Code, open its
  command palette and run "Shell Command: Install 'code' command in PATH". Otherwise
  put `[core] editor = nvim` in `~/.gitconfig.local`, which is what the Linux setup
  does.
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
the iTerm2 font step, and check that the non-ASCII font override is off.

**The tmux status bar is plain or broken.** tpm has not installed the plugins yet.
Press `Ctrl-Space` then `I` inside tmux.

**The Claude Code status line is blank.** `statusline-command.sh` needs `jq`. Recent
macOS ships it at `/usr/bin/jq`. If yours doesn't, `brew install jq`.

**Everything linked but the shell looks wrong.** You are probably still in the old
session. Open a new window rather than sourcing `~/.zshrc`, since Powerlevel10k's
instant prompt wants a fresh shell.
