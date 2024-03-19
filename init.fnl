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
   "ggandor/leap.nvim"
   "echasnovski/mini.nvim"
   "nvim-tree/nvim-web-devicons" ; mini.statusline wants this
   "mg979/vim-visual-multi"

   {1 "glacambre/firenvim"
     :lazy (not vim.g.started_by_firenvim)
     :build (fn [] ((. vim.fn "firenvim#install") 0))}

   {1 "nvim-telescope/telescope.nvim"
    :event "VimEnter"
    :branch "0.1.x"
    :dependencies ["nvim-lua/plenary.nvim"
                   {1 "nvim-telescope/telescope-fzf-native.nvim"
                    :build "make"
                    :cond (fn [] (= 1 (vim.fn.executable "make")))}
                   "nvim-telescope/telescope-ui-select.nvim"]}

   {1 "VonHeikemen/lsp-zero.nvim"
    :lazy true
    :event "VeryLazy"
    :dependencies
      ["williamboman/mason.nvim"
       "williamboman/mason-lspconfig.nvim"
       "neovim/nvim-lspconfig"
       "hrsh7th/nvim-cmp"
       "hrsh7th/cmp-nvim-lsp"
       "hrsh7th/cmp-nvim-lua"
       "L3MON4D3/LuaSnip"]}

   "nvim-treesitter/nvim-treesitter"

   ;; fennel
   "Olical/conjure"
   "gpanders/nvim-parinfer"
   "bakpakin/fennel.vim" ; syntax highlighting
   "folke/neodev.nvim"])


