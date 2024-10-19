local _local_1_ = require("user.utils")
local run = _local_1_["run"]
local function _2_()
  return run(require("oil").close)
end
return run(require("oil").setup, {win_options = {wrap = true}, delete_to_trash = true, keymaps = {["<C-v>"] = "actions.select_split", ["<Esc>"] = _2_, ["<C-h>"] = false, ["<C-l>"] = false}})
