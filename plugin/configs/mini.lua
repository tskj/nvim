local move = require("mini.move")
move.setup({mappings = {left = "<C-h>", right = "<C-l>", down = "<C-j>", up = "<C-k>"}})
local pairs = require("mini.pairs")
pairs.setup()
local surround = require("mini.surround")
surround.setup({mappings = {add = "S"}})
local comment_ = require("mini.comment")
comment_.setup({options = {ignore_blank_line = true}})
local starter = require("mini.starter")
starter.setup()
local sessions = require("mini.sessions")
sessions.setup({file = "", autoread = false})
local jump2d = require("mini.jump2d")
jump2d.setup({mappings = {start_jumping = "<leader>gj"}, view = {dim = true, n_steps_ahead = 2}})
local notify = require("mini.notify")
notify.setup()
local trailspace = require("mini.trailspace")
trailspace.setup()
local function _1_()
  return trailspace.trim()
end
vim.api.nvim_create_autocmd("BufWritePost", {pattern = "*", callback = _1_})
local ai = require("mini.ai")
return ai.setup({n_lines = 500})
