local function pick_random(vs)
  local index = math.random(#vs)
  return vs[index]
end
math.randomseed(os.time())
local nightfox = require("nightfox")
nightfox.setup({options = {dim_inactive = true}})
local fm = require("fluoromachine")
fm.setup({glow = true, theme = "fluoromachine", transparent = true})
return vim.cmd(("colorscheme " .. pick_random({"nightfox", "duskfox", "terafox", "carbonfox", "rose-pine", "tokyodark", "torte"})))
