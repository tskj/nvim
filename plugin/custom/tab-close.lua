-- [nfnl] plugin/custom/tab-close.fnl
local function _1_()
  local function _2_()
    local current_tab = vim.fn.tabpagenr()
    if (current_tab > 1) then
      return vim.cmd("tabprevious")
    else
      return nil
    end
  end
  return vim.defer_fn(_2_, 10)
end
return vim.api.nvim_create_autocmd("TabClosed", {callback = _1_})
