require("leap").setup({
  safe_labels = "fnut/SFNLHMUGTZ?",
})

-- Removed repeat mappings to allow quickfix navigation with ; and ,
-- require("leap").add_repeat_mappings(";", ",", { relative_directions = true })

-- fix bug where cursor is visible when autoleaping, from docs
vim.api.nvim_create_autocmd("User", {
  pattern = "LeapEnter",
  callback = function()
    vim.cmd.hi("Cursor", "blend=100")
    vim.opt.guicursor:append({ "a:Cursor/lCursor" })
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "LeapLeave",
  callback = function()
    vim.cmd.hi("Cursor", "blend=0")
    vim.opt.guicursor:remove({ "a:Cursor/lCursor" })
  end,
})
