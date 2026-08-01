return {
  {
    "adalessa/laravel.nvim",
    enabled = false,
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.lsp.config("laravel_lsp", {
        cmd = { "laravel-lsp" },
        filetypes = { "php", "blade" },
        root_markers = { "artisan", "composer.json", ".git" },
      })

      vim.lsp.enable("laravel_lsp")
    end,
  },
}
