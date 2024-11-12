-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Map Ctrl + s to save in normal mode
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
-- Map Ctrl + s to save in insert mode
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>a", { noremap = true, silent = true })

-- Freeze
vim.api.nvim_set_keymap("v", "<leader>sc", "<cmd>Freeze<cr>", {})
vim.api.nvim_set_keymap("n", "<leader>so", "<cmd>Freeze open<cr>", {})
