local padding_top = 10
local padding_bottom = 10
local just_scrolled_cursor_to = nil
local function equal_coords(ab, cd)
  local _let_1_ = ab
  local y0 = _let_1_[1]
  local x0 = _let_1_[2]
  local _let_2_ = cd
  local y1 = _let_2_[1]
  local x1 = _let_2_[2]
  return ((y0 == y1) and (x0 == x1))
end
local function scrolly()
  local win_height = vim.api.nvim_win_get_height(0)
  local cursor_line = vim.fn.winline()
  local _let_3_ = vim.api.nvim_win_get_cursor(0)
  local distance_to_top = _let_3_[1]
  local x = _let_3_[2]
  local screen_is_at_top_3f = (distance_to_top == cursor_line)
  if (not just_scrolled_cursor_to or not equal_coords({distance_to_top, x}, just_scrolled_cursor_to)) then
    just_scrolled_cursor_to = nil
    local padding_top0 = padding_top
    local padding_bottom0 = padding_bottom
    if ((padding_top0 + padding_bottom0 + 1) > win_height) then
      padding_top0 = math.floor((win_height / 2))
      padding_bottom0 = (win_height - padding_top0 - 1)
    else
    end
    if (screen_is_at_top_3f and (cursor_line <= padding_top0)) then
      padding_top0 = 0
    else
    end
    if (cursor_line <= padding_top0) then
      local distance_to_padding_border = (padding_top0 - cursor_line)
      local one_window_height = (win_height - padding_top0 - padding_bottom0)
      local n = (distance_to_padding_border + one_window_height)
      if (n > 0) then
        vim.api.nvim_command(("exe \"normal! " .. n .. "\\<C-y>\""))
      else
      end
    else
    end
    if (cursor_line > (win_height - padding_bottom0)) then
      local distance_to_padding_border = (cursor_line - (win_height - padding_bottom0) - 1)
      local one_window_height = (win_height - padding_top0 - padding_bottom0)
      local n = (distance_to_padding_border + one_window_height)
      if (n > 0) then
        return vim.api.nvim_command(("exe \"normal! " .. n .. "\\<C-e>\""))
      else
        return nil
      end
    else
      return nil
    end
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("CursorMoved", {pattern = "*", callback = scrolly})
local function _11_()
  local win_height = vim.api.nvim_win_get_height(0)
  local cursor_line = vim.fn.winline()
  local _let_12_ = vim.api.nvim_win_get_cursor(0)
  local distance_to_top = _let_12_[1]
  local _x = _let_12_[2]
  local screen_is_not_at_top_3f = (distance_to_top > cursor_line)
  local padding_top0 = padding_top
  local padding_bottom0 = padding_bottom
  if ((padding_top0 + padding_bottom0 + 1) > win_height) then
    padding_top0 = math.floor((win_height / 2))
    padding_bottom0 = (win_height - padding_top0 - 1)
  else
  end
  if ((cursor_line <= padding_top0) and screen_is_not_at_top_3f) then
    local n = (padding_top0 - cursor_line - -1)
    vim.api.nvim_command(("normal! " .. n .. "j"))
    just_scrolled_cursor_to = vim.api.nvim_win_get_cursor(0)
  else
  end
  if (cursor_line >= (win_height - padding_bottom0 - -1)) then
    local n = (padding_bottom0 - (win_height - cursor_line))
    if (n > 0) then
      vim.api.nvim_command(("normal! " .. n .. "k"))
      just_scrolled_cursor_to = vim.api.nvim_win_get_cursor(0)
      return nil
    else
      return nil
    end
  else
    return nil
  end
end
return vim.api.nvim_create_autocmd("WinScrolled", {pattern = "*", callback = _11_})
