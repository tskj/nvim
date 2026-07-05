-- incase you want different paddings
local padding_top = 10
local padding_bottom = 10
local padding_left = 20
local padding_right = 20

-- let's us know whether the triggered cursored moved event
-- was caused by us moving it out of the way of the scrolling
local just_scrolled_cursor_to = nil
local skip_horizontal_scroll = false

local function equal_coords(ab, cd)
  return ab[1] == cd[1] and ab[2] == cd[2]
end

-- Function to ensure cursor is within legal area (not in padding)
local function ensure_cursor_in_legal_area()
  local win_width = vim.api.nvim_win_get_width(0)
  local cursor_col = vim.fn.wincol()

  -- If cursor is in left padding area
  if cursor_col < padding_left then
    local required_move = padding_left - cursor_col
    if required_move > 0 then
      vim.api.nvim_command("normal! " .. required_move .. "l")
    end
  end

  -- If cursor is in right padding area
  if cursor_col > (win_width - padding_right) then
    local required_move = cursor_col - (win_width - padding_right)
    if required_move > 0 then
      vim.api.nvim_command("normal! " .. required_move .. "h")
    end
  end
end

-- Shift-L: Move screen right (half screen width)
vim.keymap.set("n", "<S-L>", function()
  skip_horizontal_scroll = true
  local win_width = vim.api.nvim_win_get_width(0)
  local half_width = math.floor(win_width / 2)
  -- Move screen right
  vim.api.nvim_command('exe "normal! ' .. half_width .. 'zl"')
  -- Ensure cursor is in legal area
  ensure_cursor_in_legal_area()
  -- Reset after a brief delay
  vim.defer_fn(function() skip_horizontal_scroll = false end, 100)
end)

-- Shift-H: Move screen left (half screen width)
vim.keymap.set("n", "<S-H>", function()
  skip_horizontal_scroll = true
  local win_width = vim.api.nvim_win_get_width(0)
  local half_width = math.floor(win_width / 2)
  -- Move screen left
  vim.api.nvim_command('exe "normal! ' .. half_width .. 'zh"')
  -- Ensure cursor is in legal area
  ensure_cursor_in_legal_area()
  -- Reset after a brief delay
  vim.defer_fn(function() skip_horizontal_scroll = false end, 100)
end)

local function scrolly()
  local win_height = vim.api.nvim_win_get_height(0)
  local win_width = vim.api.nvim_win_get_width(0)
  local cursor_line = vim.fn.winline()
  local cursor_col = vim.fn.wincol()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local distance_to_top, x = cursor[1], cursor[2]
  local screen_is_at_top = distance_to_top == cursor_line

  if just_scrolled_cursor_to and equal_coords({ distance_to_top, x }, just_scrolled_cursor_to) then
    return
  end
  just_scrolled_cursor_to = nil

  -- Vertical scrolling
  local top = padding_top
  local bottom = padding_bottom
  if top + bottom + 1 > win_height then
    top = math.floor(win_height / 2)
    bottom = win_height - top - 1
  end
  if screen_is_at_top and cursor_line <= top then
    top = 0
  end
  if cursor_line <= top then
    local distance_to_padding_border = top - cursor_line
    local one_window_height = win_height - top - bottom
    local n = distance_to_padding_border + one_window_height
    if n > 0 then
      vim.api.nvim_command('exe "normal! ' .. n .. '\\<C-y>"')
    end
  end
  if cursor_line > (win_height - bottom) then
    local distance_to_padding_border = cursor_line - (win_height - bottom) - 1
    local one_window_height = win_height - top - bottom
    local n = distance_to_padding_border + one_window_height
    if n > 0 then
      vim.api.nvim_command('exe "normal! ' .. n .. '\\<C-e>"')
    end
  end

  -- Horizontal scrolling - skip if flag is set
  if cursor_col < padding_left and not skip_horizontal_scroll then
    local distance_to_padding_border = padding_left - cursor_col
    local one_window_width = win_width - padding_left - padding_right
    local n = distance_to_padding_border + one_window_width
    if n > 0 then
      vim.api.nvim_command('exe "normal! ' .. n .. 'zh"')
    end
  end

  if cursor_col > (win_width - padding_right) and not skip_horizontal_scroll then
    local distance_to_padding_border = cursor_col - (win_width - padding_right) - 1
    local one_window_width = win_width - padding_left - padding_right
    local n = distance_to_padding_border + one_window_width + 1
    if n > 0 then
      vim.api.nvim_command('exe "normal! ' .. n .. 'zl"')
    end
  end
end

-- potentially move the screen when the cursor moves
vim.api.nvim_create_autocmd("CursorMoved", { pattern = "*", callback = scrolly })

-- move cursor out of the way when scrolling with mouse wheel
vim.api.nvim_create_autocmd("WinScrolled", {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "n" then
      return
    end
    local win_height = vim.api.nvim_win_get_height(0)
    local cursor_line = vim.fn.winline()
    local distance_to_top = vim.api.nvim_win_get_cursor(0)[1]
    local screen_is_not_at_top = distance_to_top > cursor_line

    -- Vertical handling
    local top = padding_top
    local bottom = padding_bottom
    if top + bottom + 1 > win_height then
      top = math.floor(win_height / 2)
      bottom = win_height - top - 1
    end
    if cursor_line <= top and screen_is_not_at_top then
      local n = top - cursor_line + 1
      -- n is guaranteed to be positive here
      vim.api.nvim_command("normal! " .. n .. "j")
      just_scrolled_cursor_to = vim.api.nvim_win_get_cursor(0)
    end
    if cursor_line >= (win_height - bottom + 1) then
      local n = bottom - (win_height - cursor_line)
      if n > 0 then
        vim.api.nvim_command("normal! " .. n .. "k")
        just_scrolled_cursor_to = vim.api.nvim_win_get_cursor(0)
      end
    end
  end,
})
