return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        php = { "pint", "php_cs_fixer", "intelephense" },
        blade = { "blade-formatter" },
        fish = {},
      },
      formatters = {
        pint = {
          condition = function(self, ctx)
            local pint_config = "pint.json"
            return vim.fn.filereadable(vim.fn.getcwd() .. "/" .. pint_config) == 1
          end,
        },
        php_cs_fixer = {
          condition = function(self, ctx)
            local php_cs_config = ".php-cs-fixer.php"
            return vim.fn.filereadable(vim.fn.getcwd() .. "/" .. php_cs_config) == 1
          end,
        },
      },
    },
  },
}
