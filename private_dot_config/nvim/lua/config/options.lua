-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Added due to avante.nvim
--views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
vim.g.lazyvim_prettier_needs_config = false

-- Disable cursor completely
vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })
vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
vim.keymap.set("i", "<down>", "<nop>", { noremap = true })

vim.opt.guicursor = ""
vim.opt.mouse = ""
vim.opt.mousescroll = "ver:0,hor:0"
