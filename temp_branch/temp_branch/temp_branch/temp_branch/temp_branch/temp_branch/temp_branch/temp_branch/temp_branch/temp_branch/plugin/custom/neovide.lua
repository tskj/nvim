if vim.g.neovide then
  vim.g.neovide_transparency = 0.95
  vim.getneovide_scroll_animation_length = 0.1
  local is_transparent = true
  local transparency_value = 0.95
  vim.g.neovide_transparency = transparency_value
  local function _1_()
    if is_transparent then
      vim.g.neovide_transparency = 1
      is_transparent = false
      return nil
    else
      vim.g.neovide_transparency = transparency_value
      is_transparent = true
      return nil
    end
  end
  vim.api.nvim_create_user_command("ToggleNeovide", _1_, {})
  vim.getneovide_scroll_animation_length = 0.1
  vim.g.neovide_hide_mouse_when_typing = true
  local function _3_()
    if vim.g.neovide_fullscreen then
      vim.g.neovide_fullscreen = false
    else
      vim.g.neovide_fullscreen = true
    end
    return {silent = true}
  end
  vim.keymap.set("n", "<M-Enter>", _3_)
  vim.g.neovide_cursor_animation_length = 0.005
  vim.g.neovide_cursor_trail_size = 0.5
  vim.g.neovide_cursor_animate_command_line = false
  return nil
else
  return nil
end
