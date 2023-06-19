
(vim.api.nvim_set_var "spacemacs#plugins"
  ["kien/ctrlp.vim"
   "mbbill/undotree"
   "szw/vim-maximizer"
   "tpope/vim-commentary"])

(vim.api.nvim_set_var "spacemacs#excludes"
  ["^t"
   "^fed$"
   "^feR$"])

;; this doesn't really work
;; not that important, but would be nice to have a platform independent way to get to the config
;; (vim.keymap.set "n" "<leader>fed" ":execute 'Explore ' .. vim.fn.stdpath('config')<CR>")

