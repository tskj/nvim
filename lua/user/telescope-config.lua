-- sets cwd to be git repository above in file
-- tree if it exists, otherwise leaves it as
-- current working directory
local function project_path_or_cwd()
  local cwd = vim.fn.getcwd()
  local project_path = require("user.find-git-repo").get_path_to_repo(cwd)
  return project_path or cwd
end

return {
  -- find files relative to git repository
  -- (in project, in other words)
  find_files = function()
    local builtin = require("telescope.builtin")
    builtin.find_files({ cwd = project_path_or_cwd() })
  end,

  -- find files relative to git repository
  -- (in project, in other words)
  -- but also show hidden files,
  -- but not files ignored by git
  find_hidden_files = function()
    local builtin = require("telescope.builtin")
    builtin.find_files({
      cwd = project_path_or_cwd(),
      hidden = true,
      file_ignore_patterns = { ".git\\", ".git/" },
    })
  end,

  -- live grep relative to git repository
  -- (in project, in other words)
  live_grep = function()
    local builtin = require("telescope.builtin")
    builtin.live_grep({ cwd = project_path_or_cwd() })
  end,
}
