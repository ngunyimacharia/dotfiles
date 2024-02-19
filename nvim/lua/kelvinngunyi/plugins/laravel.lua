-- import nvim-laravel safely
local laravel_setup, laravel = pcall(require, "laravel")
if not laravel_setup then
  print("Laravel not found")
  return
end

local environments = require("laravel.config.environments");

-- disable sail as I don't use it
environments.definitions = { {
  name = "local",
  condition = {
    executable = { "php" },
  },
} };


-- configure laravel
laravel.setup({
  lsp_server = "intelephense",
  environments
})
