;; get the path to the Neovim configuration directory
(local nvim-dir (vim.fn.stdpath "config"))

;; print the directory for debugging purposes
(print nvim-dir)

;; use :Ex for now, switch to other file explorer in the future
(fn open-in-explorer [dir]
  (.. ":Ex " dir :<cr>))

;; remap esc in terminal mode
(vim.keymap.set :t "<Esc>" "<C-\\><C-n>" {:noremap true})
(vim.keymap.set :t "<C-Space>" "<Esc>" {:noremap true})


;; map SPC f e d to open the file explorer at the neovim config directory
(vim.keymap.set :n "<leader>fed" (open-in-explorer nvim-dir))

;; open file explorer in directory of current file
(vim.keymap.set :n "<leader>pt" (open-in-explorer ""))

;; open terminal (in spacemacs this is SPC a t)
(vim.keymap.set :n "<leader>t" vim.cmd.terminal)

(vim.keymap.set :n "<leader>wr" vim.cmd.WinResizerStartResize)
