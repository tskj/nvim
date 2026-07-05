vim.opt.guicursor = { "n-v-c:block", "i-ci-ve:hor20", "r-cr:hor20" }

vim.o.guifont = "FiraCode Nerd Font:h15"

-- more convenient with case insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.cursorline = true

-- left gutter, I think it's probably best to not waste that space?
-- it only appears to work with "no" though, so w/e
vim.opt.signcolumn = "auto"

vim.opt.fileformats = { "unix", "dos" }

-- nowrap for long lines
vim.wo.wrap = false

-- e.g. click and drag to resize split with mouse
vim.opt.mouse = "a"

-- we show the mode in status line anyway
vim.opt.showmode = false

-- set to true if you want line numbers
vim.opt.number = false

-- highlight searches, but clears on <Esc>
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.opt.shm = "sS" -- removes search count
vim.opt.showcmd = false -- removes selection count

vim.opt.confirm = false
vim.opt.swapfile = false

local undodir = vim.fn.stdpath("data") .. "/undo"
if 0 == vim.fn.isdirectory(undodir) then
  vim.fn.mkdir(undodir, "p")
end
vim.opt.undofile = true
vim.opt.undodir = undodir

vim.o.timeout = true
vim.o.timeoutlen = 300

vim.api.nvim_del_keymap("n", "<C-w><C-d>")
vim.api.nvim_del_keymap("n", "<C-w>d")

vim.env.LANG = "en_US.UTF-8"
vim.env.LC_ALL = "en_US.UTF-8"

-- Hard wrapping for prose files - insert newlines but no visual wrapping
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "norg", "org", "text" },
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.wrap = false -- No visual wrapping
    -- Set formatoptions for auto-wrapping
    -- t = auto-wrap text using textwidth (inserts actual newlines)
    -- l = don't break long lines that were already long (keep by default)
    vim.opt_local.formatoptions:append("t")
  end,
})
