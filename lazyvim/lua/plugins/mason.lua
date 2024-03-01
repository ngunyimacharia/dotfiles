return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "phpactor", -- PHP LSP
        "phpstan", -- Adds PHPStan / Larastan support
        "php-cs-fixer", -- Adds PHP CS Fixer support
      },
    },
  },
}
