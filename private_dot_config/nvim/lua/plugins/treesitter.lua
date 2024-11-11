LazyVim.on_very_lazy(function()
  vim.filetype.add({
    pattern = {
      [".*%.blade%.php"] = "blade",
    },
  })
end)

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "php",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "blade",
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "elixir",
        "heex",
        "javascript",
        "html",
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
  opts = function(_, opts)
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.blade = {
      install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "blade",
    }
  end,
}
