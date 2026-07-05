vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlighting when yanking text",
  callback = function()
    vim.highlight.on_yank({ timeout = 50 })
  end,
})
