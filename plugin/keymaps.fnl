;; get the path to the Neovim configuration directory
(local nvim-dir (vim.fn.stdpath "config"))


;; use :Ex for now, switch to other file explorer in the future
(fn open-in-explorer [dir]
  (.. ":Ex " dir :<cr>))


;; remap esc in terminal mode
(vim.keymap.set :t "<Esc>" "<C-\\><C-n>" {:noremap true})
(vim.keymap.set :t "<C-Space>" "<Esc>" {:noremap true})


;; these are the regular bindings
(vim.keymap.set :n "<C-Enter>" (fn [] (vim.lsp.buf.code_action)) {:silent true}) ;; adding both for convenience
(vim.keymap.set :n "<M-Enter>" (fn [] (vim.lsp.buf.code_action)) {:silent true})
(vim.keymap.set :n "<Enter>" "m`o<Esc>k``" {:noremap true})
(vim.keymap.set :n "<S-Enter>" "i<Enter><Esc>k$" {:noremap true})


;; these are all my spacemacs-like keybindings
(let [map-set-leader (fn [lhs rhs] (vim.keymap.set :n (.. "<leader>" lhs) rhs {:noremap true}))]

  (map-set-leader "wo" ":only<CR>")
  (map-set-leader "bs" ":enew<CR>")

  ;; map SPC f e d to open the file explorer at the neovim config directory
  (map-set-leader "fed" (open-in-explorer nvim-dir))

  ;; rename in spacemacs
  (map-set-leader "se" vim.lsp.buf.rename)

  ;; open file explorer in directory of current file
  (map-set-leader "ef" (open-in-explorer ""))

  ;; open terminal (in spacemacs this is SPC a t for "application: terminal")
  (map-set-leader "t" vim.cmd.terminal)

  (map-set-leader "wr" vim.cmd.WinResizerStartResize)

  ;; buffer home, go to start screen! (mini.starter)
  (map-set-leader "bh" (fn [] (MiniStarter.open)))

  ;; layout stuff, which are neovim _tabs_
  (map-set-leader "lt"
    (fn []
      (vim.cmd "tabnew")
      (MiniStarter.open)))
  (map-set-leader "ln" vim.cmd.tabnext)
  (map-set-leader "lp" vim.cmd.tabprev)
  (map-set-leader "lc" vim.cmd.tabclose)
  (map-set-leader "l<" (fn [] (vim.cmd.tabmove "-1")))
  (map-set-leader "l>" (fn [] (vim.cmd.tabmove "+1")))

  ;; compile all fennel config using make and then quit
  ;; (sadly there's no way to restart neovim automatically)
  (map-set-leader "qr"
    (fn []
      (vim.cmd (.. "cd " nvim-dir))
      (vim.cmd.terminal "make")
      ;; Setup an autocommand to quit Neovim after make completes
      (vim.api.nvim_create_autocmd "TermClose"
        {:pattern "term://*make"
         :callback (fn [] (vim.cmd "qa"))}))))


; these are modifications of existing behavior
