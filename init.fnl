(vim.keymap.set ""  :<space> "" {:noremap true})
(set vim.g.mapleader " ")

(local lazypath (.. (vim.fn.stdpath "data") "/lazy/lazy.nvim"))
(if (not (vim.loop.fs_stat lazypath))
  (vim.fn.system ["git" "clone" "--filter=blob:none"
                  "https://github.com/folke/lazy.nvim.git"
                  "--branch=stable" lazypath]))
(vim.opt.rtp:prepend lazypath)

(local lazy (require :lazy))
(lazy.setup
  [;; color schemes
   "EdenEast/nightfox.nvim"

   ;; plugins
   "jimmay5469/vim-spacemacs"
   "hecal3/vim-leader-guide"
   "ibhagwan/fzf-lua"
   "simeji/winresizer"
   "ctrlpvim/ctrlp.vim"
   "nvim-treesitter/nvim-treesitter"

   "echasnovski/mini.nvim"
   "nvim-tree/nvim-web-devicons" ; mini.statusline wants this


   {1 "VonHeikemen/lsp-zero.nvim"
    :dependencies
      ["williamboman/mason.nvim"
       "williamboman/mason-lspconfig.nvim"
       "neovim/nvim-lspconfig"
       "hrsh7th/nvim-cmp"
       "hrsh7th/cmp-nvim-lsp"
       "hrsh7th/cmp-nvim-lua"
       "L3MON4D3/LuaSnip"]}

   ;; fennel
   "Olical/conjure"
   "gpanders/nvim-parinfer"
   "bakpakin/fennel.vim" ; syntax highlighting
   "folke/neodev.nvim"])


