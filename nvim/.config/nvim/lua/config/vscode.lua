-- VS Code Neovim extension setup.
-- Loaded only when running inside VS Code (see init.lua / vim.g.vscode).
-- The `vscode` module is provided by the extension:
--   https://github.com/vscode-neovim/vscode-neovim

-- Use <Space> as leader, matching the LazyVim habit.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Movement keymaps shared with terminal Neovim (jk, H/L, J/K).
require("config.keymaps")

local vscode = require("vscode")
local keymap = vim.keymap

-- Wrap a VS Code command id into a keymap-friendly callback.
-- Find command ids via the Command Palette (gear icon → "Copy Command ID").
local function action(name)
  return function()
    vscode.action(name)
  end
end

-- Files / navigation
keymap.set("n", "<leader><space>", action("workbench.action.quickOpen"), { desc = "Find file" })
keymap.set("n", "<leader>e", action("workbench.view.explorer"), { desc = "Toggle explorer" })
keymap.set("n", "<leader>/", action("workbench.action.findInFiles"), { desc = "Search in files" })

-- Code / LSP
keymap.set("n", "<leader>ca", action("editor.action.quickFix"), { desc = "Code action" })
keymap.set("n", "<leader>cr", action("editor.action.rename"), { desc = "Rename symbol" })
keymap.set("n", "<leader>cf", action("editor.action.formatDocument"), { desc = "Format document" })
keymap.set("n", "gr", action("editor.action.goToReferences"), { desc = "Go to references" })
keymap.set("n", "gi", action("editor.action.goToImplementation"), { desc = "Go to implementation" })
keymap.set("n", "<leader>h", action("editor.action.showHover"), { desc = "Hover" })

-- Diagnostics
keymap.set("n", "]d", action("editor.action.marker.next"), { desc = "Next diagnostic" })
keymap.set("n", "[d", action("editor.action.marker.prev"), { desc = "Prev diagnostic" })
