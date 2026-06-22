local function theme_mode()
  local mode_file = vim.fn.expand("~/.current_theme_mode")
  local ok, lines = pcall(vim.fn.readfile, mode_file)
  local mode = ok and lines[1] or "dark"

  if mode ~= "light" and mode ~= "dark" then
    mode = "dark"
  end

  return mode
end

local function apply_theme_mode()
  vim.o.background = theme_mode()
  vim.cmd.colorscheme("everforest")
end

local function set_theme_mode(mode)
  if vim.fn.executable(vim.fn.expand("~/bin/theme")) == 1 then
    vim.fn.system({ vim.fn.expand("~/bin/theme"), mode })
  else
    vim.fn.writefile({ mode }, vim.fn.expand("~/.current_theme_mode"))
  end

  apply_theme_mode()
end

return {
  {
    "neanias/everforest-nvim",
    priority = 1000,
    init = function()
      vim.o.background = theme_mode()
    end,
    config = function()
      require("everforest").setup({
        background = "soft",
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    init = function()
      vim.api.nvim_create_user_command("ThemeSync", apply_theme_mode, {})
      vim.api.nvim_create_user_command("ThemeDark", function()
        set_theme_mode("dark")
      end, {})
      vim.api.nvim_create_user_command("ThemeLight", function()
        set_theme_mode("light")
      end, {})
    end,
    opts = {
      colorscheme = "everforest",
    },
  },
}
