local utils = require("user.utils")

local function add_untracked_to_quickfix()
  -- Use git repo detection from your existing config
  local project_path = require("user.find-git-repo").get_path_to_repo(vim.fn.getcwd())

  if not project_path then
    print("Not in a git repository.")
    return
  end

  -- Run git commands from the git root directory
  local git_cmd_prefix = "cd " .. vim.fn.shellescape(project_path) .. " && "

  -- Get untracked files relative to git root
  local untracked_files = vim.fn.systemlist(git_cmd_prefix .. "git ls-files --others --exclude-standard")

  if vim.v.shell_error ~= 0 or #untracked_files == 0 then
    print("No untracked files found.")
    return
  end

  -- Convert to quickfix items - use full paths from git root
  local qf_items = {}
  for _, file in ipairs(untracked_files) do
    table.insert(qf_items, {
      filename = vim.fs.joinpath(project_path, file),
      lnum = 1,
      text = "New untracked file",
    })
  end

  -- Append to existing quickfix list
  vim.fn.setqflist(qf_items, "a")
  print("Added " .. #qf_items .. " untracked files to the quickfix list.")
  utils.volatile_quickfix()
end

vim.api.nvim_create_user_command("AddUntracked", add_untracked_to_quickfix, {})
