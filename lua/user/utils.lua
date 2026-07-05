local function debug_log(...)
  local file_name = vim.fn.stdpath("data") .. "/debug.log"
  local file = io.open(file_name, "a")
  local messages = {}
  for _, msg in ipairs({ ... }) do
    table.insert(messages, tostring(msg))
  end
  local log_line = os.date("[%Y-%m-%dT%H:%M:%S] ") .. table.concat(messages, " ") .. "\n"
  file:write(log_line)
  file:flush()
  file:close()
end

-- Opens quickfix with focus and closes after timeout
local function volatile_quickfix(timeout_ms)
  vim.cmd("copen")
  vim.fn.timer_start(timeout_ms or 2000, function()
    if vim.fn.getqflist({ winid = 1 }) and vim.fn.getqflist({ winid = 1 }).winid ~= 0 then
      vim.cmd("cclose")
    end
  end)
end

-- Run gitsigns setqflist and open as volatile quickfix
local function gitsigns_quickfix_volatile()
  vim.cmd("Gitsigns setqflist all")
  volatile_quickfix()
end

return {
  debug_log = debug_log,
  volatile_quickfix = volatile_quickfix,
  gitsigns_quickfix_volatile = gitsigns_quickfix_volatile,
}
