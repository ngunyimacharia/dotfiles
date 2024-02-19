-- import nvim-lazygit safely
local lazygit_setup, lazygit = pcall(require, "lazygit")
if not lazygit_setup then
  print("Lazygit not found")
  return
end

-- configure lazygit
