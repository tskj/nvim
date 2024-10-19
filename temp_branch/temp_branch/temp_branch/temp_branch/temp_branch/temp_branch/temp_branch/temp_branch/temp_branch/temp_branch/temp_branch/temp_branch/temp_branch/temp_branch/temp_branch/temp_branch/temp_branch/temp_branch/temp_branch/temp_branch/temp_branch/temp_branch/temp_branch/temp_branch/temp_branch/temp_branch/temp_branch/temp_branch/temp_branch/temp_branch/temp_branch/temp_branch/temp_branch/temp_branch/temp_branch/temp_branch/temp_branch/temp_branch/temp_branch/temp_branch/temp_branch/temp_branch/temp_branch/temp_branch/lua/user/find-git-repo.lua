local function find_path_to_repo(cwd)
  local dot_git_path = vim.fn.finddir(".git", ".;")
  local git_path = vim.fn.fnamemodify(dot_git_path, ":h")
  local path_to_repo
  if (git_path == ".") then
    path_to_repo = cwd
  else
    path_to_repo = git_path
  end
  if (dot_git_path == "") then
    return nil
  else
    return path_to_repo
  end
end
local function _3_(cwd)
  return find_path_to_repo(cwd)
end
return {["get-path-to-repo"] = _3_}
