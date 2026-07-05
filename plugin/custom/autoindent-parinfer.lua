-- parinfer doesn't auto-indent properly when you open a new line
-- below all the final closing parens of an expression (kind of
-- by design), but kind of not, so this plugin aims to fix that
-- by reading the indent of the line above and automatically
-- scooching over if needed

local function blank(line)
  return nil ~= line:match("^%s*$")
end

local function indent_width(line)
  local _, end_index = line:find("^%s*")
  return end_index
end

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    local line_number = vim.api.nvim_win_get_cursor(0)[1]

    if line_number == 1 then
      return
    end

    local previous_line_number = line_number - 1

    local current_line = vim.api.nvim_get_current_line()
    -- nvim_buf_get_lines is zero indexed
    local previous_line = vim.api.nvim_buf_get_lines(0, previous_line_number - 1, line_number - 1, true)[1]

    local prev_indent = indent_width(previous_line)
    local curr_indent = indent_width(current_line)

    if blank(current_line) and not blank(previous_line) and prev_indent > curr_indent then
      -- add appropriate indentation
      vim.api.nvim_set_current_line(string.rep(" ", 1 + prev_indent))

      -- move cursor to end of line afterwards
      vim.schedule(function() vim.cmd("normal! $") end)
    end
  end,
})
