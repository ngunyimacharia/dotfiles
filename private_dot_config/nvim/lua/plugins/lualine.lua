return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections = opts.sections or {}

      -- Remove the clock in the bottom-right; keep the usual cursor location instead.
      -- LazyVim's defaults can include location in both lualine_y and lualine_z.
      -- Keep it only once to avoid duplicate line/column.
      local y = opts.sections.lualine_y or {}
      local filtered = {}
      for _, item in ipairs(y) do
        local name = item
        if type(item) == "table" then
          name = item[1]
        end
        if name ~= "location" then
          table.insert(filtered, item)
        end
      end
      -- Tighten up spacing:
      -- - keep a bit more breathing room after progress (e.g. "75%")
      -- - remove padding around location (e.g. "31:5")
      local y2 = {}
      for _, item in ipairs(filtered) do
        local name = item
        if type(item) == "table" then
          name = item[1]
        end

        if name == "progress" then
          local progress = item
          if type(progress) == "string" then
            progress = { progress }
          end
          progress.padding = { left = 1, right = 2 }
          progress.separator = ""
          table.insert(y2, progress)
        else
          table.insert(y2, item)
        end
      end
      opts.sections.lualine_y = y2

      opts.sections.lualine_z = {
        {
          "location",
          padding = { left = 0, right = 0 },
        },
      }
    end,
  },
}
