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



(let [map-set-leader (fn [lhs rhs] (vim.keymap.set :n (.. "<leader>" lhs) rhs {:noremap true}))]
  (map-set-leader "wo" ":only<CR>")
  (map-set-leader "bs" ":enew<CR>")

  ;; map SPC f e d to open the file explorer at the neovim config directory
  (map-set-leader "fed" (open-in-explorer nvim-dir))

  ;; open file explorer in directory of current file
  (map-set-leader "pt" (open-in-explorer ""))

  ;; open terminal (in spacemacs this is SPC a t)
  (map-set-leader "t" vim.cmd.terminal)

  (map-set-leader "wr" vim.cmd.WinResizerStartResize))
