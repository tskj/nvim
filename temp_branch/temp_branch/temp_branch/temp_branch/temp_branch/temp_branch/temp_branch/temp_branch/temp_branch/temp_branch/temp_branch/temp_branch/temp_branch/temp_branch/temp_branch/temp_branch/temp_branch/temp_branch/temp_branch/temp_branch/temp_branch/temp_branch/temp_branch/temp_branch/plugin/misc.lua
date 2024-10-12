local function _1_()
  return vim.highlight.on_yank({timeout = 50})
end
return vim.api.nvim_create_autocmd("TextYankPost", {desc = "Highlighting when yanking text", callback = _1_})
