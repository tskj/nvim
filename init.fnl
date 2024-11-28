(vim.keymap.set ""  :<space> "" {:noremap true})
(set vim.g.mapleader " ")
(set vim.g.winresizer_start_key "<F14>") ;; needed to disable <C-e> for winresizer before it's loaded

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
   "ibhagwan/fzf-lua"
   "simeji/winresizer"
   "ggandor/leap.nvim"
   "echasnovski/mini.nvim"
   {1 "lewis6991/gitsigns.nvim" :opts {}}
   "nvim-telescope/telescope-ui-select.nvim"
   "nvim-lualine/lualine.nvim"
   "justinmk/vim-sneak"
   {1 "folke/which-key.nvim"
    :event "VeryLazy"
    :opts {}}
   "stevearc/oil.nvim"
   "jiaoshijie/undotree"
   "debugloop/telescope-undo.nvim"

   "nvim-tree/nvim-web-devicons"
   "mg979/vim-visual-multi"

   {1 "svban/YankAssassin.nvim"
    :opts {:auto_normal true
           :auto_visual true}}
   {1 "0xAdk/full_visual_line.nvim"
    :keys "V"
    :opts {}}


   {1 "NeogitOrg/neogit"
    :dependencies ["nvim-lua/plenary.nvim"
                   "sindrets/diffview.nvim"
                   "nvim-telescope/telescope.nvim"]
    :opts {:disable_context_highlighting true
             :disable_insert_on_commit true
             :graph_style "unicode"
             :integrations {:telescope true :diffview true}
             :commit_editor {:spell_check false}}}

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
   "nvim-treesitter/nvim-treesitter-context"
   {1 "folke/todo-comments.nvim"
    :event "VimEnter"
    :dependencies ["nvim-lua/plenary.nvim"]
    :opts {:signs false}}
   {1 "ThePrimeagen/refactoring.nvim"
    :config (fn [] ((-> :refactoring (require) (. :setup))))}

   ;; fennel
   "Olical/conjure"
   ;; "gpanders/nvim-parinfer"
   {1 "eraserhd/parinfer-rust" :build "cargo build --release"}
   "bakpakin/fennel.vim" ; syntax highlighting
   "folke/neodev.nvim"])
