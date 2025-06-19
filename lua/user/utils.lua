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
    local tbl_21_ = {}
    local i_22_ = 0
    for __4_auto, x_5_auto in ipairs(msgs) do
      local val_23_ = tostring(x_5_auto)
      if (nil ~= val_23_) then
        i_22_ = (i_22_ + 1)
        tbl_21_[i_22_] = val_23_
      else
      end
    end
    _1_ = tbl_21_
  end
  messages = table.concat(_1_, " ")
  local log_line = (os.date("[%Y-%m-%dT%H:%M:%S] ") .. messages .. "\n")
  file:write(log_line)
  file:flush()
  return file:close()
end
local function volatile_quickfix(timeout_ms)
  vim.cmd("copen")
  local function _3_()
    if (vim.fn.getqflist({winid = 1}) and (vim.fn.getqflist({winid = 1}).winid ~= 0)) then
      return vim.cmd("cclose")
    else
      return nil
    end
  end
  return vim.fn.timer_start((timeout_ms or 2000), _3_)
end
local function gitsigns_quickfix_volatile()
  vim.cmd("Gitsigns setqflist all")
  return volatile_quickfix()
end
return {run = run, ["debug-log"] = debug_log, ["volatile-quickfix"] = volatile_quickfix, ["gitsigns-quickfix-volatile"] = gitsigns_quickfix_volatile}
