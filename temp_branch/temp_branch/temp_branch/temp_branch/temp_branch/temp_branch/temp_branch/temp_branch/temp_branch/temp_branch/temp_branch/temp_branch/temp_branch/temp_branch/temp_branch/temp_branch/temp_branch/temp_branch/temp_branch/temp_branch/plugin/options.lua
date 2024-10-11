vim.opt.guicursor = {"n-v-c:block", "i-ci-ve:hor20", "r-cr:hor20"}
vim.o.guifont = "FiraCode Nerd Font:h15"
if vim.g.started_by_firenvim then
  vim.o.guifont = "FiraCode Nerd Font:h10"
else
end
vim.o.autochdir = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.signcolumn = "auto"
vim.opt.fileformats = {"unix", "dos"}
vim.wo.wrap = false
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.number = false
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.opt.shm = "sS"
vim.opt.showcmd = false
vim.opt.confirm = false
vim.opt.swapfile = false
do
  local undodir = (vim.fn.stdpath("data") .. "/undo")
  local not_exists_3f = (0 == vim.fn.isdirectory(undodir))
  if not_exists_3f then
    vim.fn.mkdir(undodir, "p")
  else
  end
  vim.opt.undofile = true
  vim.opt.undodir = undodir
end
vim.opt.linespace = 8
return nil
