local function _1_()
  local _let_2_ = vim.api.nvim_win_get_cursor(0)
  local line_number = _let_2_[1]
  if (line_number == 1) then
    return
  else
  end
  local function blank_3f(line)
    return (nil ~= line:match("^%s*$"))
  end
  local function get__23indent(line)
    local _, end_index = line:find("^%s*")
    return end_index
  end
  local function zi(x)
    return (x - 1)
  end
  local previous_line_number = (line_number - 1)
  local current_line = vim.api.nvim_get_current_line()
  local _let_4_ = vim.api.nvim_buf_get_lines(0, zi(previous_line_number), zi(line_number), true)
  local previous_line = _let_4_[1]
  local prev__23indent = get__23indent(previous_line)
  local curr__23indent = get__23indent(current_line)
  if (blank_3f(current_line) and not blank_3f(previous_line) and (prev__23indent > curr__23indent)) then
    vim.api.nvim_set_current_line(string.rep(" ", (1 + prev__23indent)))
    local function _5_()
      return vim.cmd("normal! $")
    end
    return vim.schedule(_5_)
  else
    return nil
  end
end
return vim.api.nvim_create_autocmd("InsertEnter", {pattern = "*", callback = _1_})
