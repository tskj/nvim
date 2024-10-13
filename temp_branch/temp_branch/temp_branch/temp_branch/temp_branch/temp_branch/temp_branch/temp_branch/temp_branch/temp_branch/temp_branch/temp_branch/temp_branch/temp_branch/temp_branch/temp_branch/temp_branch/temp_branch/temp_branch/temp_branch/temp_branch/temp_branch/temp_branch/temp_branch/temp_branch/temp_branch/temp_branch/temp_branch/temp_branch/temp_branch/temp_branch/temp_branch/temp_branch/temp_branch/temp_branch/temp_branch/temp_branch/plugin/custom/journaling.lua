local function todays_journal_filename()
  local today = os.date("%Y-%m-%d")
  return ("~/notes/journal/" .. today .. ".org")
end
local function open_todays_journal()
  return vim.cmd((":edit " .. todays_journal_filename()))
end
return vim.keymap.set("n", "<leader>cj", open_todays_journal)
