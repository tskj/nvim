local function pick_random(vs)
  local index = math.random(#vs)
  return vs[index]
end
math.randomseed(os.time())
local colorscheme_state_file = (vim.fn.stdpath("data") .. "/colorscheme-state.json")
local available_colorschemes = {"nightfox", "duskfox", "terafox", "carbonfox", "darkblue", "torte"}
local function read_colorscheme_state()
  local file = io.open(colorscheme_state_file, "r")
  if file then
    local content = file:read("*a")
    local _ = file:close()
    if (content and (content ~= "")) then
      return pcall(vim.fn.json_decode, content)
    else
      return nil
    end
  else
    return nil
  end
end
local function write_colorscheme_state(colorscheme)
  local state = {colorscheme = colorscheme, timestamp = os.time()}
  local json_content = vim.fn.json_encode(state)
  local file = io.open(colorscheme_state_file, "w")
  if file then
    file:write(json_content)
    return file:close()
  else
    return nil
  end
end
local function should_reuse_colorscheme_3f(state)
  return (state and state.colorscheme and state.timestamp and ((os.time() - state.timestamp) < 7200))
end
local function get_colorscheme()
  local success, state = read_colorscheme_state()
  if (success and should_reuse_colorscheme_3f(state)) then
    print(("Reusing colorscheme: " .. state.colorscheme))
    return state.colorscheme
  else
    local new_colorscheme = pick_random(available_colorschemes)
    write_colorscheme_state(new_colorscheme)
    print(("New random colorscheme: " .. new_colorscheme))
    return new_colorscheme
  end
end
local nightfox = require("nightfox")
nightfox.setup({options = {dim_inactive = true}})
local fm = require("fluoromachine")
fm.setup({theme = "fluoromachine", transparent = true, glow = false})
local selected_colorscheme = get_colorscheme()
vim.cmd(("colorscheme " .. selected_colorscheme))
local function _5_()
  local current_colorscheme = vim.g.colors_name
  if current_colorscheme then
    return write_colorscheme_state(current_colorscheme)
  else
    return nil
  end
end
return vim.api.nvim_create_autocmd("VimLeavePre", {callback = _5_})
