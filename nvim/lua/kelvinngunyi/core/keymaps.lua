-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>")

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- delete single character without copying into register
keymap.set("n", "x", '"_x');

-- increment number
keymap.set("n", "<leader>+", "<C-a>")
-- decrement number
keymap.set("n", "<leader>-", "<C-x>")

-- window management
keymap.set("n", "<leader>sv", "<C-w>v")        -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s")        -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=")        -- make split windows equal width & heightCkeymap.set("n", "<leader>sx", ":close<CR>") -- close current split window
keymap.set("n", "<leader>sc", ":close<CR>")    -- close current split window
-- tab management
keymap.set("n", "<leader>to", ":tabnew<CR>")   -- open new tab
keymap.set("n", "<leader>tc", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>")     --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>")     --  go to previous tab

----------------------
-- Plugin Keybinds
----------------------

-- vim maximier
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- comment
keymap.set("n", "<leader>/", "gcc<cr>")

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")                        -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>")                         -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")                       -- find string under cursor in current working directory
keymap.set("n", "<leader>fo", "<cmd>Telescope buffers<cr>")                           -- list open buffers in current neovim instance
keymap.set("n", "<leader>fp", "<cmd>lua require('telescope.builtin').oldfiles()<cr>") -- list previously open files
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")                         -- list available help tags

-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>")   -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")  -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")    -- list current changes per file with diff preview ["gs" for git status]

-- local testing
keymap.set("n", "<leader>t", ":TestNearest<CR>")
keymap.set("n", "<leader>T", ":TestFile<CR>")
keymap.set("n", "<leader>a", ":TestSuite<CR>")
keymap.set("n", "<leader>l", ":TestLast<CR>")
keymap.set("n", "<leader>g", ":TestVisit<CR>")

-- obsidian
keymap.set("n", "<leader>oo", ":ObsidianOpen<CR>")        -- open note in Obsidian app. Optional argument ID, Path or Alias of note. Current buffer is default
keymap.set("n", "<leader>on", ":ObsidianNew<CR>")         -- creates a new notes. Optional argument is title of note.
keymap.set("n", "<leader>oq", ":ObsidianQuickSwitch<CR>") -- quickly switch to another note.
keymap.set("n", "<leader>of", ":ObsidianFollowLink<CR>")  -- follow a ntoe reference under the cursor
keymap.set("n", "<leader>ob", ":ObsidianBacklinks<CR>")   -- for getting a location list of reference of current buffer
keymap.set("n", "<leader>ot", ":ObsidianToday<CR>")       -- open / creates a new daily note
keymap.set("n", "<leader>oy", ":ObsidianYesterday<CR>")   -- open / create new daily note for yesterday
keymap.set("n", "<leader>oi", ":ObsidianTemplate<CR>")    -- insert new template from templates folder
keymap.set("n", "<leader>os", ":ObsidianSearch<CR>")      -- search for notes in vault. Optional argument search query
keymap.set("n", "<leader>ol", ":ObsidianLink<CR>")        -- link inline visual text selection to existing note. Optional argument: ID, Path, Alias. If not given, selected note used to find note
keymap.set("n", "<leader>oln", ":ObsidianLinkNew<CR>")    -- create a new notes and link inline visual text selection. Optional argument is title of note. Defaults to selected text
keymap.set("n", "<leader>ow", ":ObsidianWorkspace<CR>")   -- switch to another workspace

-- cloak
keymap.set("n", "<leader>ce", ":CloakEnable<CR>")
keymap.set("n", "<leader>cd", ":CloakDisable<CR>")
keymap.set("n", "<leader>ct", ":CloakToggle<CR>")

-- Blame line
keymap.set("n", "<leader>b", ":ToggleBlameLine<CR>")

-- Copy path of currently opened buffer
keymap.set("n", "cp", ":let @+ = expand('%')<CR>")

-- Lazygit
keymap.set("n", "lg", ":LazyGit<CR>")

-- Laravel
keymap.set("n", "<leader>la", ":Laravel artisan<cr>")
keymap.set("n", "<leader>lr", ":Laravel routes<cr>")
keymap.set("n", "<leader>lm", ":Laravel related<cr>")
