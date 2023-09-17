-- import mason plugin safely
local mason_status, mason = pcall(require, "mason")
if not mason_status then
  print("Mason not installed")
  return
end

-- import mason-lspconfig plugin safely
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
  print("Mason lspconfig not installed")
  return
end

-- enable mason
mason.setup()

mason_lspconfig.setup({
  -- list of servers for mason to install
  ensure_installed = {
    "html", -- html
    "cssls", -- css
    "tailwindcss", -- tailwind
    "quick_lint_js", -- javascript
    "intelephense", -- php
    "lua_ls", -- lua
  },
  -- auto-install configured servers (with lspconfig)
  automatic_installation = true, -- not the same as ensure_installed
})

