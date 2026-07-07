if vim.g.vscode then
  -- Running inside the VS Code Neovim extension.
  -- VS Code handles LSP, completion, file tree, finder, statusline, etc.,
  -- so skip LazyVim and every plugin — load only keymaps and VS Code bindings.
  require("config.vscode")
else
  -- Standalone (terminal) Neovim: full LazyVim setup.
  require("config.lazy")
end
