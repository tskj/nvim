;; these are the supported plugins from vim-spacemacs I want
(vim.api.nvim_set_var "spacemacs#plugins"
  ["kien/ctrlp.vim"
   "mbbill/undotree"
   "szw/vim-maximizer"
   "tpope/vim-commentary"])

;; these aren't doing what I want, so they're being removed
(vim.api.nvim_set_var "spacemacs#excludes"
  ["^t"
   "^fed$"
   "^feR$"])

;; this doesn't really work
;; not that important, but would be nice to have a platform independent way to get to the config
;; (vim.keymap.set "n" "<leader>fed" ":execute 'Explore ' .. vim.fn.stdpath('config')<CR>")

(let [map-set-leader (fn [lhs rhs] (vim.keymap.set :n (.. "<leader>" lhs) rhs {:noremap true}))]
  (map-set-leader "w>" ":vertical resize +10<CR>")
  (map-set-leader "w<" ":vertical resize -10<CR>")
  (map-set-leader "w[" ":vertical resize +20<CR>")
  (map-set-leader "w]" ":vertical resize -20<CR>")
  (map-set-leader "w{" ":resize +5<CR>")
  (map-set-leader "w}" ":resize -5<CR>")
  (map-set-leader "wo" ":only<CR>"))
