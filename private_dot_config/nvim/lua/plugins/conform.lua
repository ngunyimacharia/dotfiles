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
            local config_files = {
              ".php-cs-fixer.dist.php",
              ".php-cs-fixer.php",
            }
            for _, filename in ipairs(config_files) do
              if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. filename) == 1 then
                return true
              end
            end
            return false
          end,
        },
      },
    },
  },
}
