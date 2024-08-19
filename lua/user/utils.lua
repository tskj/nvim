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
    local tbl_21_auto = {}
    local i_22_auto = 0
    for __4_auto, x_5_auto in ipairs(msgs) do
      local val_23_auto = tostring(x_5_auto)
      if (nil ~= val_23_auto) then
        i_22_auto = (i_22_auto + 1)
        tbl_21_auto[i_22_auto] = val_23_auto
      else
      end
    end
    _1_ = tbl_21_auto
  end
  messages = table.concat(_1_, " ")
  local log_line = (os.date("[%Y-%m-%dT%H:%M:%S] ") .. messages .. "\n")
  file:write(log_line)
  file:flush()
  return file:close()
end
return {run = run, ["debug-log"] = debug_log}
