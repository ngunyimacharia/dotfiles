return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        php = { "pint", "php_cs_fixer", "intelephense" },
        blade = { "prettier", "blade-formatter" },
        fish = {},
      },
      formatters = {
        ["blade-formatter"] = {
          condition = function(self, ctx)
            local prettier_config = ".prettierrc"
            return vim.fn.filereadable(vim.fn.getcwd() .. "/" .. prettier_config) == 0
          end,
        },
        pint = {
          condition = function(self, ctx)
            local pint_config = "pint.json"
            return vim.fn.filereadable(vim.fn.getcwd() .. "/" .. pint_config) == 1
          end,
        },
        php_cs_fixer = {
          condition = function(self, ctx)
            local php_cs_config = ".php-cs-fixer.dist.php"
            return vim.fn.filereadable(vim.fn.getcwd() .. "/" .. php_cs_config) == 1
          end,
        },
      },
    },
  },
}
