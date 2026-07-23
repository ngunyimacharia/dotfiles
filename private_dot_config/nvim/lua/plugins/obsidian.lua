return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    cmd = "Obsidian",
    keys = {
      { "<leader>o", nil, desc = "Obsidian" },
      { "<leader>oo", "<cmd>Obsidian<cr>", desc = "Commands" },
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
      { "<leader>oN", "<cmd>Obsidian new_from_template<cr>", desc = "New note from template" },
      { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Quick switch" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search notes" },
      { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Today's note" },
      { "<leader>od", "<cmd>Obsidian dailies<cr>", desc = "Daily notes" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
      { "<leader>oi", "<cmd>Obsidian paste_img<cr>", desc = "Paste image" },
    },
    ---@module "obsidian"
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "notes",
          path = "~/Documents/Notes",
        },
      },
      notes_subdir = "00 Inbox",
      new_notes_location = "notes_subdir",
      note_id_func = function(title)
        return title or require("obsidian.builtin").zettel_id()
      end,
      frontmatter = {
        -- Canonical vault templates own frontmatter; do not inject id/aliases/tags.
        enabled = false,
      },
      link = {
        style = "wiki",
        auto_update = true,
      },
      daily_notes = {
        folder = "Journal",
        date_format = "YYYY/YYYY-MM-DD",
        template = "Daily Note.md",
        default_tags = {},
        workdays_only = false,
      },
      templates = {
        folder = "Templates",
        date_format = "YYYY-MM-DD",
        time_format = "HH:mm",
      },
      attachments = {
        folder = "Attachments",
      },
      picker = {
        name = "snacks.picker",
      },
    },
  },
}
