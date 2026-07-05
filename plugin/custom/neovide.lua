if not vim.g.neovide then
  return
end

vim.g.neovide_hide_mouse_when_typing = true

vim.keymap.set("n", "<M-Enter>", function()
  vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end)

vim.g.neovide_cursor_animate_command_line = false

-- these get toggled further down, so these are
-- the opposite of the defaults!
local transparent = true
local animation = false
local linespacing = false

local separators = nil

local function neovide_toggle(opts)
  local args = opts.args
  if args == "toggle-transparency" then
    if transparent then
      transparent = false
      vim.g.neovide_opacity = 1
    else
      transparent = true
      vim.g.neovide_opacity = 0.95
    end
  elseif args == "toggle-animations" then
    if animation then
      animation = false
      vim.g.neovide_scroll_animation_length = 0
      vim.g.neovide_cursor_animation_length = 0
      vim.g.neovide_cursor_trail_size = 0
    else
      animation = true
      vim.g.neovide_scroll_animation_length = 0.1
      vim.g.neovide_cursor_animation_length = 0.005
      vim.g.neovide_cursor_trail_size = 0.5
    end
  elseif args == "toggle-linespacing" then
    if linespacing then
      linespacing = false
      vim.opt.linespace = 0
      local config = require("lualine").get_config()
      if separators ~= nil then
        config.options.section_separators = separators
        separators = nil
      end
      require("lualine").setup(config)
    else
      linespacing = true
      vim.opt.linespace = 8
      local config = require("lualine").get_config()
      separators = config.options.section_separators
      config.options.section_separators = { left = "", right = "" }
      require("lualine").setup(config)
    end
  end
end

neovide_toggle({ args = "toggle-transparency" })
neovide_toggle({ args = "toggle-animations" })
neovide_toggle({ args = "toggle-linespacing" })

vim.api.nvim_create_user_command("Neovide", neovide_toggle, {
  nargs = 1,
  complete = function()
    return { "toggle-transparency",
             "toggle-animations",
             "toggle-linespacing" }
  end,
})
