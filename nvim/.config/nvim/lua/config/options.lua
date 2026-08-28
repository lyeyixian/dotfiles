-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Yank/delete/put go through the system clipboard (LazyVim skips this over SSH;
-- Neovim >= 0.10 falls back to OSC 52 there, so it is safe to always enable).
vim.opt.clipboard = "unnamedplus"
