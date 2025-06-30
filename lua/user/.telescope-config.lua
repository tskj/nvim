local _local_1_ = require("user.utils")
local run = _local_1_["run"]
local function project_path_or_cwd()
  local cwd = vim.fn.getcwd()
  local project_path = run(require("user.find-git-repo")["get-path-to-repo"], cwd)
  if project_path then
    return project_path
  else
    return cwd
  end
end
local function _3_()
  local builtin = require("telescope.builtin")
  return builtin.find_files({cwd = project_path_or_cwd()})
end
local function _4_()
  local builtin = require("telescope.builtin")
  return builtin.find_files({cwd = project_path_or_cwd(), hidden = true, file_ignore_patterns = {".git\\", ".git/"}})
end
local function _5_()
  local builtin = require("telescope.builtin")
  return builtin.live_grep({cwd = project_path_or_cwd()})
end
return {["find-files"] = _3_, ["find-hidden-files"] = _4_, ["live-grep"] = _5_}
