return {
  "charm-and-friends/freeze.nvim",
  config = function()
    require("freeze").setup({
      command = "freeze",
      open = true, -- Open the generated image after running the command
      output = function()
        return "./" .. os.date("%Y-%m-%d") .. "_freeze.png"
      end,
      theme = "catppuccin-mocha",
    })
  end,
}
