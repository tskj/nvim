(vim.keymap.set ""  :<space> "" {:noremap true})
(set vim.g.mapleader " ")
(set vim.g.winresizer_start_key 0) ;; needed to disable <C-e> for winresizer before it's loaded

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
   "ibhagwan/fzf-lua"
   "simeji/winresizer"
   "ggandor/leap.nvim"
   "echasnovski/mini.nvim"
   {1 "lewis6991/gitsigns.nvim" :opts {}}
   "nvim-telescope/telescope-ui-select.nvim"

   {1 "nvim-lualine/lualine.nvim"
    :opts {:sections {:lualine_c [{1 "filename" :path 3}]
                      :lualine_x ["searchcount" "selectioncount" "encoding" "filesize" "filetype"]}
           :options {:component_separators {:left "" :right ""}
                     :section_separators {:left "" :right ""}}
           :tabline {:lualine_a [{1 "tabs"
                                  :mode 0
                                  :show_modified_status false}]
                     :lualine_z ["windows"]}}}

   "nvim-tree/nvim-web-devicons"
   "mg979/vim-visual-multi"

   {1 "NeogitOrg/neogit"
    :dependencies ["nvim-lua/plenary.nvim"
                   "sindrets/diffview.nvim"
                   "nvim-telescope/telescope.nvim"]
    :config {:disable_insert_on_commit true
             :graph_style "unicode"
             :integrations {:telescope true :diffview true}}}

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
   {1 "folke/todo-comments.nvim"
    :event "VimEnter"
    :dependencies ["nvim-lua/plenary.nvim"]
    :opts {:signs false}}

   ;; fennel
   "Olical/conjure"
   "gpanders/nvim-parinfer"
   "bakpakin/fennel.vim" ; syntax highlighting
   "folke/neodev.nvim"])


