return {
  "sudo-tee/opencode.nvim",
  cmd = "OpenCode",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
        file_types = { "markdown", "opencode_output" },
      },
      ft = { "markdown", "opencode_output" },
    },
    "saghen/blink.cmp",
    "folke/snacks.nvim",
  },
  opts = {
    preferred_picker = "snacks",
    preferred_completion = "blink",
    keymap_prefix = "<leader>o",
    opencode_executable = "opencode",
    ui = {
      position = "right",
      window_width = 0.4,
      display_model = true,
      display_context_size = true,
      display_cost = true,
    },
  },
}
