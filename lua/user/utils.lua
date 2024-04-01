local function run(f, ...)
  local xs = {...}
  return f(unpack(xs))
end
local function debug_log(...)
  local msgs = {...}
  local file_name = (vim.fn.stdpath("data") .. "/debug.log")
  local file = io.open(file_name, "a")
  local messages
  local _1_
  do
    local tbl_17_auto = {}
    local i_18_auto = #tbl_17_auto
    for __4_auto, x_5_auto in ipairs(msgs) do
      local val_19_auto = tostring(x_5_auto)
      if (nil ~= val_19_auto) then
        i_18_auto = (i_18_auto + 1)
        do end (tbl_17_auto)[i_18_auto] = val_19_auto
      else
      end
    end
    _1_ = tbl_17_auto
  end
  messages = table.concat(_1_, " ")
  local log_line = (os.date("[%Y-%m-%dT%H:%M:%S] ") .. messages .. "\n")
  file:write(log_line)
  file:flush()
  return file:close()
end
return {run = run, ["debug-log"] = debug_log}
