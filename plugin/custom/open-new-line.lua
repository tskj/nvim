-- the purpose of this file is to override the "o" key in normal mode when
-- it's on a blank line immediately preceding a non-blank line, in which
-- case we want to insert an extra blank line below to space out the code
-- a bit -- if you _want_ to open a new line above an existing line, go one
-- down and use shift+O instead

-- here's a bug (interacts weirdly with something like the indent thing maybe, puts cursor on wrong line in some situations):
--
--   .center {
--            display: flex;
--            flex-direction: row;
--            justify-content: middle
-- }

-- </style>

vim.keymap.set("n", "o", function()
  local function blank(line)
    if line == nil then
      return true
    end
    return nil ~= line:match("^%s*$")
  end

  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local next_line_number = line_number + 1
  local current_line = vim.api.nvim_get_current_line()
  local next_line = vim.api.nvim_buf_get_lines(0, line_number, next_line_number, false)[1]

  if blank(current_line) and not blank(next_line) then
    vim.cmd('execute "normal \\<Enter>"') -- open extra line
  end

  -- regular behavior
  vim.api.nvim_feedkeys("o", "n", true)
end)
