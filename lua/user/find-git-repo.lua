-- [nfnl] lua/user/find-git-repo.fnl
local function find_path_to_repo(cwd)
  local dot_git_dir = vim.fn.finddir(".git", ".;")
  if (dot_git_dir ~= "") then
    local git_path = vim.fn.fnamemodify(dot_git_dir, ":h")
    local path_to_repo
    if (git_path == ".") then
      path_to_repo = cwd
    else
      path_to_repo = git_path
    end
    return path_to_repo
  else
    local dot_git_file = vim.fn.findfile(".git", ".;")
    if (dot_git_file ~= "") then
      local git_path = vim.fn.fnamemodify(dot_git_file, ":h")
      local path_to_repo
      if (git_path == ".") then
        path_to_repo = cwd
      else
        path_to_repo = git_path
      end
      return path_to_repo
    else
      return nil
    end
  end
end
local function _5_(cwd)
  return find_path_to_repo(cwd)
end
return {["get-path-to-repo"] = _5_}
