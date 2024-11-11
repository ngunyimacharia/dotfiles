return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        php = { "pint", "php_cs_fixer", "intelephense" },
        blade = { "blade-formatter" },
        fish = {},
      },
    },
  },
}
