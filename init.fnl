(vim.keymap.set ""  :<space> "" {:noremap true})
(set vim.g.mapleader " ")
(set vim.g.maplocalleader ",")
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
   "tiagovla/tokyodark.nvim"
   {1 "rose-pine/neovim" :name "rose-pine"}
   "maxmx03/fluoromachine.nvim"

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

   {1 "kdheepak/lazygit.nvim"
    :lazy true
    :cmd ["LazyGit" "LazyGitConfig" "LazyGitCurrentFile" "LazyGitFilter" "LazyGitFilterCurrentFile"]
    :dependencies ["nvim-lua/plenary.nvim"]}

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

   {1 "seblyng/roslyn.nvim"
    :ft "cs"
    :opts {}}

   "supermaven-inc/supermaven-nvim"
   "milanglacier/minuet-ai.nvim"
   "robitx/gp.nvim"
   {1 "coder/claudecode.nvim"
    :dependencies ["folke/snacks.nvim"]
    :config true
    :keys [{1 "<leader>a" :desc "AI/Claude Code"}
           {1 "<leader>ac" 2 "<cmd>ClaudeCode<cr>" :desc "Toggle Claude"}
           {1 "<leader>af" 2 "<cmd>ClaudeCodeFocus<cr>" :desc "Focus Claude"}
           {1 "<leader>ar" 2 "<cmd>ClaudeCode --resume<cr>" :desc "Resume Claude"}
           {1 "<leader>aC" 2 "<cmd>ClaudeCode --continue<cr>" :desc "Continue Claude"}
           {1 "<leader>ab" 2 "<cmd>ClaudeCodeAdd %<cr>" :desc "Add current buffer"}
           {1 "<leader>as" 2 "<cmd>ClaudeCodeSend<cr>" :mode "v" :desc "Send to Claude"}
           {1 "<leader>as" 2 "<cmd>ClaudeCodeTreeAdd<cr>" :desc "Add file" :ft ["NvimTree" "neo-tree" "oil"]}
           {1 "<leader>aa" 2 "<cmd>ClaudeCodeDiffAccept<cr>" :desc "Accept diff"}
           {1 "<leader>ad" 2 "<cmd>ClaudeCodeDiffDeny<cr>" :desc "Deny diff"}]}

   "nvim-treesitter/nvim-treesitter"
   "nvim-treesitter/nvim-treesitter-context"
   {1 "folke/todo-comments.nvim"
    :event "VimEnter"
    :dependencies ["nvim-lua/plenary.nvim"]
    :opts {:signs false}}
   {1 "ThePrimeagen/refactoring.nvim"
    :config (fn [] ((-> :refactoring (require) (. :setup))))}

   "stevearc/conform.nvim"
   "WhoIsSethDaniel/mason-tool-installer.nvim"
   "MunifTanjim/prettier.nvim"

   ;; fennel
   "Olical/conjure"
   {1 "Olical/nfnl" :ft "fennel"}
   ;; "gpanders/nvim-parinfer"
   {1 "eraserhd/parinfer-rust" :build "cargo build --release"}
   "bakpakin/fennel.vim" ; syntax highlighting
   "folke/neodev.nvim"

   ;; neorg
   {1 "nvim-neorg/neorg"
    :ft "norg"
    :opts {:load {:core.defaults {}
                  :core.concealer {:config {:icon_preset "basic"}}
                  :core.dirman {:config {:workspaces {:notes "~/notes"}
                                         :default_workspace "notes"}}
                  :core.keybinds {:config {:default_keybinds true
                                           :neorg_leader "<localleader>"}}}}}

   ;; image rendering for Ghostty
   {1 "3rd/image.nvim"
    :opts {:backend "kitty"  ; Ghostty supports Kitty graphics protocol
           :integrations {:markdown {:enabled true
                                     :clear_in_insert_mode false
                                     :download_remote_images true
                                     :only_render_image_at_cursor false
                                     :filetypes ["markdown" "vimwiki" "norg"]}
                          :neorg {:enabled true
                                  :clear_in_insert_mode false
                                  :download_remote_images true
                                  :only_render_image_at_cursor false
                                  :filetypes ["norg"]}}}}])
