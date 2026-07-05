-- NOTE: currently unused - the <leader>nj journal keybinding in
-- plugin/keymaps.lua has its own copy of this logic

local function todays_journal_filename()
  local today = os.date("%Y-%m-%d")
  local year = os.date("%Y")
  local journal_dir = "~/notes/.private/journal/" .. year
  -- Ensure the year directory exists
  vim.fn.system("mkdir -p " .. journal_dir)
  return journal_dir .. "/" .. today .. ".norg"
end

local function open_todays_journal()
  vim.cmd(":edit " .. todays_journal_filename())
end

return open_todays_journal
