local _local_1_ = require("user.utils")
local run = _local_1_["run"]
if vim.g.neovide then
  vim.g.neovide_hide_mouse_when_typing = true
  local function _2_()
    if vim.g.neovide_fullscreen then
      vim.g.neovide_fullscreen = false
    else
      vim.g.neovide_fullscreen = true
    end
    return {silent = true}
  end
  vim.keymap.set("n", "<M-Enter>", _2_)
  vim.g.neovide_cursor_animate_command_line = false
  local transparent_3f = false
  local animation_3f = false
  local linespacing_3f = false
  local separators = nil
  local function neovide_toggle_21(_4_)
    local _arg_5_ = _4_
    local args = _arg_5_["args"]
    if (args == "toggle-transparency") then
      if transparent_3f then
        transparent_3f = false
        vim.g.neovide_transparency = 1
        return nil
      else
        transparent_3f = true
        vim.g.neovide_transparency = 0.95
        return nil
      end
    elseif (args == "toggle-animations") then
      if animation_3f then
        animation_3f = false
        vim.g.neovide_scroll_animation_length = 0
        vim.g.neovide_cursor_animation_length = 0
        vim.g.neovide_cursor_trail_size = 0
        return nil
      else
        animation_3f = true
        vim.g.neovide_scroll_animation_length = 0.1
        vim.g.neovide_cursor_animation_length = 0.005
        vim.g.neovide_cursor_trail_size = 0.5
        return nil
      end
    elseif (args == "toggle-linespacing") then
      if linespacing_3f then
        linespacing_3f = false
        vim.opt.linespace = 0
        local config = run(require("lualine").get_config)
        if (separators ~= nil) then
          config.options["section_separators"] = separators
          separators = nil
        else
        end
        return run(require("lualine").setup, config)
      else
        linespacing_3f = true
        vim.opt.linespace = 8
        local config = run(require("lualine").get_config)
        separators = config.options.section_separators
        config.options["section_separators"] = {left = "", right = ""}
        return run(require("lualine").setup, config)
      end
    else
      return nil
    end
  end
  neovide_toggle_21({args = "toggle-transparency"})
  neovide_toggle_21({args = "toggle-animations"})
  neovide_toggle_21({args = "toggle-linespacing"})
  local function _11_()
    return {"toggle-transparency", "toggle-animations", "toggle-linespacing"}
  end
  return vim.api.nvim_create_user_command("Neovide", neovide_toggle_21, {nargs = 1, complete = _11_})
else
  return nil
end
