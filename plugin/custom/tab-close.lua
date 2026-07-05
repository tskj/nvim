-- if you close a tab, the tab to the right moves into
-- the spot of your old tab, so that tab (to the right)
-- gets focus -- really you want the one to the left

vim.api.nvim_create_autocmd("TabClosed", {
  callback = function()
    vim.defer_fn(function()
      local current_tab = vim.fn.tabpagenr()
      if current_tab > 1 then
        vim.cmd("tabprevious")
      end
    end, 10)
  end,
})
