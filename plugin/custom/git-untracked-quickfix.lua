-- [nfnl] plugin/custom/git-untracked-quickfix.fnl
local _local_1_ = require("user.utils")
local run = _local_1_["run"]
local volatile_quickfix = _local_1_["volatile-quickfix"]
local function add_untracked_to_quickfix()
  local project_path = run(require("user.find-git-repo")["get-path-to-repo"], vim.fn.getcwd())
  if not project_path then
    print("Not in a git repository.")
    return
  else
  end
  local git_cmd_prefix = ("cd " .. vim.fn.shellescape(project_path) .. " && ")
  local untracked_files = vim.fn.systemlist((git_cmd_prefix .. "git ls-files --others --exclude-standard"))
  if ((vim.v.shell_error ~= 0) or (#untracked_files == 0)) then
    print("No untracked files found.")
    return
  else
  end
  local qf_items
  do
    local tbl_21_ = {}
    local i_22_ = 0
    for _, file in ipairs(untracked_files) do
      local val_23_ = {filename = vim.fs.joinpath(project_path, file), lnum = 1, text = "New untracked file"}
      if (nil ~= val_23_) then
        i_22_ = (i_22_ + 1)
        tbl_21_[i_22_] = val_23_
      else
      end
    end
    qf_items = tbl_21_
  end
  vim.fn.setqflist(qf_items, "a")
  print(("Added " .. #qf_items .. " untracked files to the quickfix list."))
  return volatile_quickfix()
end
return vim.api.nvim_create_user_command("AddUntracked", add_untracked_to_quickfix, {})
