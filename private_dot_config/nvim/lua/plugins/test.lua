return {
  { "nvim-neotest/neotest-plenary" },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-phpunit",
      "V13Axel/neotest-pest",
    },
    opts = {
      adapters = {
        "neotest-plenary",
        "neotest-phpunit",
        "neotest-pest",
      },
    },
  },
}
