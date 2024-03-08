(vim.keymap.set ""  :<space> "" {:noremap true})
(set vim.g.mapleader " ")

; sets current working directory you open a file or w/e (needed for terminal)
(set vim.o.autochdir true)

; Make sure packer is installed
(let [f vim.fn
      install-path (.. (f.stdpath "data") "/site/pack/packer/start/packer.nvim")]
  (when (> (f.empty (f.glob install-path)) 0)
    (f.system ["git" "clone" "https://github.com/wbthomason/packer.nvim" install-path])))

; Plugins
(let [packer (require :packer)
      startup packer.startup]
  (startup
    (fn []
      (use "wbthomason/packer.nvim")

      ;; color schemes
      (use "altercation/vim-colors-solarized")
      (use "mhartington/oceanic-next")
      (use "rakr/vim-one")
      (use "morhetz/gruvbox")

      ;; plugins
      (use "jimmay5469/vim-spacemacs")
      (use "hecal3/vim-leader-guide")
      (use "ibhagwan/fzf-lua")
      (use "justinmk/vim-sneak")
      (use "simeji/winresizer")
      (use "ctrlpvim/ctrlp.vim")
      (use "echasnovski/mini.nvim")
      (use "nvim-tree/nvim-web-devicons") ; mini.statusline wants this

      ;; fennel
      (use "Olical/conjure")
      (use "gpanders/nvim-parinfer")
      (use "bakpakin/fennel.vim") ; syntax highlighting

      (use "nvim-treesitter/nvim-treesitter"))))

