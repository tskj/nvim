vim.keymap.set("", "<space>", "", {noremap = true})
vim.g.mapleader = " "
vim.g.winresizer_start_key = "<F14>"
local lazypath = (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
else
end
do end (vim.opt.rtp):prepend(lazypath)
local lazy = require("lazy")
local function _2_()
  return vim.fn["firenvim#install"](0)
end
local function _3_()
  return (1 == vim.fn.executable("make"))
end
return lazy.setup({"EdenEast/nightfox.nvim", "ibhagwan/fzf-lua", "simeji/winresizer", "ggandor/leap.nvim", "echasnovski/mini.nvim", {"lewis6991/gitsigns.nvim", opts = {}}, "nvim-telescope/telescope-ui-select.nvim", "nvim-lualine/lualine.nvim", "justinmk/vim-sneak", {"folke/which-key.nvim", event = "VeryLazy", opts = {}}, "nvim-tree/nvim-web-devicons", "mg979/vim-visual-multi", {"NeogitOrg/neogit", dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim"}, config = {disable_insert_on_commit = true, graph_style = "unicode", integrations = {telescope = true, diffview = true}}}, {"glacambre/firenvim", lazy = not vim.g.started_by_firenvim, build = _2_}, {"nvim-telescope/telescope.nvim", event = "VimEnter", branch = "0.1.x", dependencies = {"nvim-lua/plenary.nvim", {"nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = _3_}, "nvim-telescope/telescope-ui-select.nvim"}}, {"VonHeikemen/lsp-zero.nvim", lazy = true, event = "VeryLazy", dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig", "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-nvim-lua", "L3MON4D3/LuaSnip"}}, "nvim-treesitter/nvim-treesitter", {"folke/todo-comments.nvim", event = "VimEnter", dependencies = {"nvim-lua/plenary.nvim"}, opts = {signs = false}}, "Olical/conjure", "gpanders/nvim-parinfer", "bakpakin/fennel.vim", "folke/neodev.nvim"})
