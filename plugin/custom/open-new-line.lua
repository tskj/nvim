-- [nfnl] plugin/custom/open-new-line.fnl
local function _1_()
  local function blank_3f(line)
    if (nil == line) then
      return true
    else
      return (nil ~= line:match("^%s*$"))
    end
  end
  local _let_3_ = vim.api.nvim_win_get_cursor(0)
  local line_number = _let_3_[1]
  local next_line_number = (line_number + 1)
  local current_line = vim.api.nvim_get_current_line()
  local _let_4_ = vim.api.nvim_buf_get_lines(0, line_number, next_line_number, false)
  local next_line = _let_4_[1]
  if (blank_3f(current_line) and not blank_3f(next_line)) then
    vim.cmd("execute \"normal \\<Enter>\"")
  else
  end
  return vim.api.nvim_feedkeys("o", "n", true)
end
return vim.keymap.set("n", "o", _1_)
