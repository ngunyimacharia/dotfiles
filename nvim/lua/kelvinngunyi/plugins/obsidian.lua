-- safe import
local status, obsidian = pcall(require, "obsidian")
if not status then
  print("obsidian not found")
  return
end

obsidian.setup({
  workspaces = {
    {
      name = "kdg",
      path = "~/vaults/kdg",
    },
    {
      name = "personal",
      path = "~/vaults/personal",
    },
  },

  -- TODO:: Add Frontmatter
  disable_frontmatter = false,

  daily_notes = {
    folder = "Daily Notes",
  },

  -- Optional, for templates (see below).
  templates = {
    subdir = "templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
    -- A map for custom variables, the key should be the variable and the value a function
    substitutions = {}
  },
})
