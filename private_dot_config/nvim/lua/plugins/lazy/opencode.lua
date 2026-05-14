return {
  "sudo-tee/opencode.nvim",
  cmd = "OpenCode",
  config = function()
    require("opencode").setup()
  end,
}
