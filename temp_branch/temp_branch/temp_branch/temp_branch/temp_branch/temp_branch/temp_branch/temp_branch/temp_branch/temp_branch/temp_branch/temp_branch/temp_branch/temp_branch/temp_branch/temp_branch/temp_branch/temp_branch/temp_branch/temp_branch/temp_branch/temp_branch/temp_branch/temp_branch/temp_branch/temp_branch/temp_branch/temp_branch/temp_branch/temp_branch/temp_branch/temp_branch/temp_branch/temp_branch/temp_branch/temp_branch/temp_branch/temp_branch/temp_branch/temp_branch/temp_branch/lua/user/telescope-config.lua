local _local_1_ = require("user.utils")
local run = _local_1_["run"]
local function create_opts()
  local cwd = vim.fn.getcwd()
  local project_path = run(require("user.find-git-repo")["get-path-to-repo"], cwd)
  if project_path then
    return {cwd = project_path}
  else
    return {cwd = cwd}
  end
end
local function _3_()
  local builtin = require("telescope.builtin")
  return builtin.find_files(create_opts())
end
local function _4_()
  local builtin = require("telescope.builtin")
  return builtin.live_grep(create_opts())
end
return {["find-files"] = _3_, ["live-grep"] = _4_}
