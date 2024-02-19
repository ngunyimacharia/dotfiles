-- import nvim-lazygit safely
local lazygit_setup, lazygit = pcall(require, "nvim-lazygit")
if not lazygit_setup then
  return
end

-- configure lazygit
lazygit.setup({
})
