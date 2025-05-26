local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      -- Function to read API key from .env file in current directory
      local function get_openrouter_api_key()
        local env_file = vim.fn.getcwd() .. "/.env"
        local file = io.open(env_file, "r")

        if not file then
          vim.notify("Error: .env file not found in current directory: " .. vim.fn.getcwd(), vim.log.levels.ERROR)
          return nil
        end

        for line in file:lines() do
          -- Skip empty lines and comments
          if line:match("^%s*$") or line:match("^%s*#") then
            goto continue
          end

          -- Match OPENROUTER_API_KEY=value pattern (handle quotes and whitespace)
          local value = line:match("^%s*OPENROUTER_API_KEY%s*=%s*(.*)%s*$")
          if value then
            -- Remove surrounding quotes if present
            value = value:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
            file:close()
            return value
          end

          ::continue::
        end

        file:close()
        vim.notify("Error: OPENROUTER_API_KEY not found in .env file", vim.log.levels.ERROR)
        return nil
      end

      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "openrouter_claude",
          },
          inline = {
            adapter = "openrouter_claude",
          },
        },

        prompt_library = {

          ["Fix Larastan Errors"] = {
            strategy = "workflow",
            description = "Fix Larastan issues in the current file with iterative suggestions and user confirmation",
            opts = {
              index = 5,
              is_default = true,
              short_name = "larastan",
            },
            prompts = {
              {
                {
                  name = "Setup Larastan Run",
                  role = constants.USER_ROLE,
                  opts = { auto_submit = false },
                  content = function()
                    -- Enable turbo mode
                    vim.g.codecompanion_auto_tool_mode = true

                    local current_file = vim.fn.expand("%")

                    return string.format(
                      [[### Instructions

Fix all errors reported by Larastan in the current file: `%s`.

### Steps to Follow

1. Use the @cmd_runner tool to run the command:
   ```
   ./vendor/bin/phpstan analyse --memory-limit=2G %s
   ```
2. Edit the code in #buffer{watch} using the @editor tool to fix Larastan issues
3. Run both tools in the same response to ensure a proper fix-analyze cycle.

Repeat until the analysis passes without errors.
]],
                      current_file,
                      current_file
                    )
                  end,
                },
              },
              {
                {
                  name = "Suggest Fixes on Failure",
                  role = constants.ASSISTANT_ROLE,
                  opts = { auto_submit = false },
                  condition = function()
                    return _G.codecompanion_current_tool == "cmd_runner"
                  end,
                  repeat_until = function(chat)
                    return chat.tools.flags.testing == true
                  end,
                  content = [[The Larastan analysis found issues in the current file.

### Instructions

1. Suggest specific code edits to fix the reported errors.
2. Ask the user: "Do you want me to apply these fixes and run Larastan again?"

Wait for user confirmation before proceeding.]],
                },
              },
            },
          },
        },
        adapters = {
          openrouter_claude = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://openrouter.ai/api",
                api_key = get_openrouter_api_key(),
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = {
                  default = "anthropic/claude-3.5-sonnet",
                },
              },
            })
          end,
        },
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
  {
    "echasnovski/mini.diff",
    config = function()
      local diff = require("mini.diff")
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
  },
}
