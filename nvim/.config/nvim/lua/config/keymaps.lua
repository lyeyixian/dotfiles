-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Faster hjkl movement
keymap.set("n", "H", "^", { desc = "Move cursor to start of line" })
keymap.set("v", "H", "^", { desc = "Move cursor to start of line" })
keymap.set("n", "J", "5j", { desc = "Move cursor down more lines" })
keymap.set("v", "J", "5j", { desc = "Move cursor down more lines" })
keymap.set("n", "K", "5k", { desc = "Move cursor up more lines" })
keymap.set("v", "K", "5k", { desc = "Move cursor up more lines" })
keymap.set("n", "L", "$", { desc = "Move cursor to end of line" })
keymap.set("v", "L", "$", { desc = "Move cursor to end of line" })
