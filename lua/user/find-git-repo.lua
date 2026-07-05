-- functionality to find the path to a "project",
-- which means the path to the directory containing
-- a .git directory (if you are in a git repo).
-- if not (you're outside any git repo): returns nil

local function find_path_to_repo(cwd)
  -- First try to find .git as a directory (normal repo)
  local dot_git_dir = vim.fn.finddir(".git", ".;")
  if dot_git_dir ~= "" then
    local git_path = vim.fn.fnamemodify(dot_git_dir, ":h")
    if git_path == "." then
      return cwd
    end
    return git_path
  end

  -- No .git directory found, try to find .git file (worktree)
  local dot_git_file = vim.fn.findfile(".git", ".;")
  if dot_git_file ~= "" then
    local git_path = vim.fn.fnamemodify(dot_git_file, ":h")
    if git_path == "." then
      return cwd
    end
    return git_path
  end

  -- No .git found at all
  return nil
end

return {
  get_path_to_repo = find_path_to_repo,
}
