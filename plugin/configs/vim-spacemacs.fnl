;; these are the supported plugins from vim-spacemacs I want
(vim.api.nvim_set_var "spacemacs#plugins"
  ["kien/ctrlp.vim"])

;; these aren't doing what I want, so they're being removed
(vim.api.nvim_set_var "spacemacs#excludes"
  ["^t"
   "^fed$"
   "^feR$"])
