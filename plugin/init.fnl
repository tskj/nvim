; Make sure packer is installed
(let [f vim.fn
      install-path (.. (f.stdpath "data") "/site/pack/packer/start/packer.nvim")]
  (when (> (f.empty (f.glob install-path)) 0)
    (f.system ["git" "clone" "https://github.com/wbthomason/packer.nvim" install-path])))

; Plugins
((require :packer).startup (fn []

  (use "altercation/vim-colors-solarized")
  (use "mhartington/oceanic-next")
  (use "rakr/vim-one")
  (use "morhetz/gruvbox")

  (use "jimmay5469/vim-spacemacs")
  (use "hecal3/vim-leader-guide")
  ; (use "preservim/nerdtree")
  (use {1 "junegunn/fzf" :run (fn [] ((vim.fn "fzf#install")))})
  (use "ctrlpvim/ctrlp.vim")

  (use "rktjmp/hotpot.nvim")))

; Mappings for vim-leader-guide
(vim.api.nvim_set_keymap "n" "<leader>" ":<C-U>LeaderGuide '<SPACE>'<CR>" {:noremap true :silent true})
(vim.api.nvim_set_keymap "v" "<leader>" ":<C-U>LeaderGuideVisual '<SPACE>'<CR>" {:noremap true :silent true})
