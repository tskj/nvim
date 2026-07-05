local function pick_random(vs)
  return vs[math.random(#vs)]
end

math.randomseed(os.time())

-- Colorscheme persistence
local colorscheme_state_file = vim.fn.stdpath("data") .. "/colorscheme-state.json"
local available_colorschemes = { "nightfox", "duskfox", "terafox", "carbonfox", "darkblue", "torte" }

-- Read colorscheme state from file, returns nil if file doesn't exist or invalid
local function read_colorscheme_state()
  local file = io.open(colorscheme_state_file, "r")
  if not file then
    return nil
  end
  local content = file:read("*a")
  file:close()
  if content and content ~= "" then
    return pcall(vim.fn.json_decode, content)
  end
  return nil
end

-- Write colorscheme and current timestamp to state file
local function write_colorscheme_state(colorscheme)
  local state = { colorscheme = colorscheme, timestamp = os.time() }
  local json_content = vim.fn.json_encode(state)
  local file = io.open(colorscheme_state_file, "w")
  if file then
    file:write(json_content)
    file:close()
  end
end

-- Check if we should reuse the stored colorscheme (within 2 hours)
local function should_reuse_colorscheme(state)
  return state
    and state.colorscheme
    and state.timestamp
    and (os.time() - state.timestamp) < 7200 -- 2 hours = 7200 seconds
end

-- Get colorscheme - either cached (if recent) or random new one
local function get_colorscheme()
  local success, state = read_colorscheme_state()
  if success and should_reuse_colorscheme(state) then
    print("Reusing colorscheme: " .. state.colorscheme)
    return state.colorscheme
  end
  local new_colorscheme = pick_random(available_colorschemes)
  write_colorscheme_state(new_colorscheme)
  print("New random colorscheme: " .. new_colorscheme)
  return new_colorscheme
end

require("nightfox").setup({ options = { dim_inactive = true } })

require("fluoromachine").setup({
  glow = false,
  theme = "fluoromachine",
  transparent = true,
})

-- Apply the selected colorscheme
vim.cmd("colorscheme " .. get_colorscheme())

-- Save colorscheme state when Neovim exits
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local current_colorscheme = vim.g.colors_name
    if current_colorscheme then
      write_colorscheme_state(current_colorscheme)
    end
  end,
})

-- local adv = require("advent")
-- adv.setup()
-- vim.cmd("colorscheme advent")
