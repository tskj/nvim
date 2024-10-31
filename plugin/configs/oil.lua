local _local_1_ = require("user.utils")
local run = _local_1_["run"]
local function _2_()
  return run(require("oil").discard_all_changes)
end
local function _3_()
  run(require("oil").save)
  return run(require("oil.actions").cd.callback, {silent = {type = true}})
end
local function _4_()
  run(require("oil.actions").parent.callback)
  return run(require("oil.actions").cd.callback, {silent = {type = true}})
end
local function _5_()
  local function _6_()
    if run(require("oil").get_current_dir) then
      return run(require("oil.actions").cd.callback, {silent = {type = true}})
    else
      return nil
    end
  end
  return run(require("oil.actions").select.callback, {callback = _6_})
end
local function _8_()
  return run(require("oil").close)
end
return run(require("oil").setup, {win_options = {wrap = true}, delete_to_trash = true, skip_confirm_for_simple_edits = true, keymaps = {["<C-r>"] = "actions.refresh", ["<C-c>"] = _2_, ["<C-s>"] = _3_, ["-"] = _4_, ["<CR>"] = _5_, ["<C-v>"] = "actions.select_split", ["<Esc>"] = _8_, ["<C-h>"] = false, ["<C-l>"] = false}})
