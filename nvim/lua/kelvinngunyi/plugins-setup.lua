local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

-- Manually run :PackerSync to update plugins after add/update
return require("packer").startup(function(use)
	-- packer is our go-to plugin manager
	use("wbthomason/packer.nvim")

	-- lua functions that many plugins use
	use("nvim-lua/plenary.nvim")

	-- color theme
	use("bluz71/vim-nightfly-guicolors")

	-- tmux & split window navigation
	use("christoomey/vim-tmux-navigator")

	-- maximizes and restores current split
	use("szw/vim-maximizer")

	-- essential plugins
	use("tpope/vim-surround")
	use("vim-scripts/ReplaceWithRegister")

	-- commenting with gc
	use("numToStr/Comment.nvim")

	-- file explorer
	use("nvim-tree/nvim-tree.lua")

	-- icons
	use("nvim-tree/nvim-web-devicons")

	-- statusline
	use("nvim-lualine/lualine.nvim")

	-- fuzzy finding w/ telescope
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder

	-- treesitter configuration
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	-- auto closing
	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- git integration
	use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

    -- vim-dadbod
    use({"tpope/vim-dadbod",
      requires = {
        "tpope/vim-dotenv",
        "kristijanhusak/vim-dadbod-ui",
        "kristijanhusak/vim-dadbod-completion",
      },
    })

    -- coc
    use({
      "neoclide/coc.nvim",
      branch = 'release'
    })

    -- test support 
    use("vim-test/vim-test")

	if packer_bootstrap then
		require("packer").sync()
	end
end)
