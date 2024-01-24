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

  -- Optional, customize how names/IDs for new notes are created.
  note_id_func = function(title)
    -- A note with the title 'My new note' will given an ID that looks
    -- like 'my-new-note', and therefore the file name 'my-new-note.md'
    if title ~= nil then
      -- If title is given, transform it into valid file name.
      return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      -- If title is nil, just add 4 random uppercase letters to the suffix.
      local suffix = ""
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
      return tostring(os.time()) .. "-" .. suffix
    end
  end,

})
