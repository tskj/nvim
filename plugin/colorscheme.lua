local function pick_random(vs)
  local index = math.random(#vs)
  return vs[index]
end
math.randomseed(os.time())
local nightfox = require("nightfox")
nightfox.setup({options = {dim_inactive = true}})
return vim.cmd(("colorscheme " .. pick_random({"nightfox", "duskfox", "terafox", "carbonfox", "torte"})))
