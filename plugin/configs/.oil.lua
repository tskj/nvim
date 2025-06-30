local _local_1_ = require("user.utils")
local run = _local_1_["run"]
local function _2_()
  return run(require("oil").discard_all_changes)
end
local function _3_()
  return run(require("oil").save)
end
local function _4_()
  return run(require("oil.actions").parent.callback)
end
local function _5_()
  return run(require("oil").close)
end
return run(require("oil").setup, {win_options = {wrap = true}, delete_to_trash = true, skip_confirm_for_simple_edits = true, keymaps = {["<C-r>"] = "actions.refresh", ["<C-c>"] = _2_, ["<C-s>"] = _3_, ["-"] = _4_, ["<CR>"] = "actions.select", ["<C-v>"] = "actions.select_split", ["<Esc>"] = _5_, ["<C-h>"] = false, ["<C-l>"] = false}})
