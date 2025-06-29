local function todays_journal_filename()
  local today = os.date("%Y-%m-%d")
  local year = os.date("%Y")
  local journal_dir = ("~/notes/.private/journal/" .. year)
  vim.fn.system(("mkdir -p " .. journal_dir))
  return (journal_dir .. "/" .. today .. ".norg")
end
local function open_todays_journal()
  return vim.cmd((":edit " .. todays_journal_filename()))
end
return open_todays_journal
