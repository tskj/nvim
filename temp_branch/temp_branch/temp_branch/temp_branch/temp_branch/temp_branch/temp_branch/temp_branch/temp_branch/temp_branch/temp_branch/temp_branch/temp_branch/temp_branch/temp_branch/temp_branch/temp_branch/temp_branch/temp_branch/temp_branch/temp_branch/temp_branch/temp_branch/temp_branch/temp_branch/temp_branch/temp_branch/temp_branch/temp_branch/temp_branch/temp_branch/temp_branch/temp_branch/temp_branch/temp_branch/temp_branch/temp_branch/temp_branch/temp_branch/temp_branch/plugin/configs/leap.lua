local leap = require("leap")
leap.setup({safe_labels = "fnut/SFNLHMUGTZ?"})
leap.add_repeat_mappings(";", ",", {relative_directions = true})
local function _1_()
  vim.cmd.hi("Cursor", "blend=100")
  return (vim.opt.guicursor):append({"a:Cursor/lCursor"})
end
vim.api.nvim_create_autocmd("User", {pattern = "LeapEnter", callback = _1_})
local function _2_()
  vim.cmd.hi("Cursor", "blend=0")
  return (vim.opt.guicursor):remove({"a:Cursor/lCursor"})
end
return vim.api.nvim_create_autocmd("User", {pattern = "LeapLeave", callback = _2_})
