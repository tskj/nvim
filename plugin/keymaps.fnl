(vim.keymap.set ""  :<space> "" {:noremap true})
(set vim.g.mapleader " ")

;; get the path to the Neovim configuration directory
(local nvim-dir (vim.fn.stdpath "config"))


;; use :Ex for now, switch to other file explorer in the future
(fn open-in-explorer [dir]
  (.. ":Ex " dir :<cr>))


;; remap esc in terminal mode
(vim.keymap.set :t "<Esc><Esc>" "<C-\\><C-n>" {:noremap true})
(vim.api.nvim_create_autocmd "TermOpen" {:pattern  "*" :command "startinsert"}) ;; auto insert mode
(vim.api.nvim_create_autocmd "BufEnter" {:pattern  "term://*" :command "startinsert"}) ;; auto insert mode


;; these are the regular bindings
(vim.keymap.set :n "<C-Enter>" vim.lsp.buf.code_action {:noremap true})
(vim.keymap.set :n "<Enter>" "m`o<Esc>k``" {:noremap true})
(vim.keymap.set :n "<S-Enter>" "i<Enter><Esc>k$" {:noremap true})
(vim.keymap.set :n "<C-h>" "<cmd>wincmd h<cr>" {:silent true})
(vim.keymap.set :n "<C-j>" "<cmd>wincmd j<cr>" {:silent true})
(vim.keymap.set :n "<C-k>" "<cmd>wincmd k<cr>" {:silent true})
(vim.keymap.set :n "<C-l>" "<cmd>wincmd l<cr>" {:silent true})
(vim.keymap.set :t "<C-h>" "<cmd>wincmd h<cr>" {:silent true})
(vim.keymap.set :t "<C-j>" "<cmd>wincmd j<cr>" {:silent true})
(vim.keymap.set :t "<C-k>" "<cmd>wincmd k<cr>" {:silent true})
(vim.keymap.set :t "<C-l>" "<cmd>wincmd l<cr>" {:silent true})
(vim.keymap.set :n "<C-s>" ":w<cr>")
(vim.keymap.set :n "<C-w>" ":q<cr>")
(vim.keymap.set :n "<C-q>" ":bd!<cr>")
(vim.keymap.set :t "<C-w>" (fn [] (vim.api.nvim_command "q")))
(vim.keymap.set :t "<C-q>" (fn [] (vim.api.nvim_command "bd!")))
(vim.keymap.set :n "<C-->" "<C-^>")
(vim.keymap.set :t "<C-->" (fn [] (vim.api.nvim_command "buffer #")))


; Leap
(vim.keymap.set [:n :x :o] "<leader>jf" "<Plug>(leap-forward)")
(vim.keymap.set [:n :x :o] "<leader>jF" "<Plug>(leap-backward)")


;; these are all my spacemacs-like keybindings
(let [map-set-leader (fn [lhs rhs] (vim.keymap.set [:n :v] (.. "<leader>" lhs) rhs {:noremap true}))]

  ;; closes all other windows in current layout
  ;; if you want to temporarily maximize the window,
  ;; checkout <leader> lo below
  (map-set-leader "wo" ":only<cr>")

  ;; new scratch buffer
  (map-set-leader "bs" ":enew<cr>")

  ;; map SPC f e d to open the file explorer at the neovim config directory
  (map-set-leader "fed" (open-in-explorer nvim-dir))

  ;; rename in spacemacs
  (map-set-leader "se" vim.lsp.buf.rename)
  ;; clear search (opposite of spacemacs(!))
  (map-set-leader "cs" ":nohlsearch<cr>")

  ;; open file explorer in directory of current file
  (map-set-leader "ef" (open-in-explorer ""))

  ;; neogit
  (map-set-leader "gs" ":Neogit<cr>")
  (map-set-leader "gc" ":Neogit commit<cr>")

  ;; open terminal (in spacemacs this is SPC a t for "application: terminal")
  (map-set-leader "ac" vim.cmd.terminal) ;; c for command line
  (map-set-leader "ap" (fn [] (vim.cmd.terminal "powershell.exe")))
  (map-set-leader "al" (fn [] (vim.cmd.terminal "wsl.exe zsh"))) ;; l for linux
  (map-set-leader "ab" (fn [] (vim.cmd.terminal "wsl.exe bash")))

  (map-set-leader "wr" vim.cmd.WinResizerStartResize)
  (map-set-leader "wD" ":q!<cr>")

  ;; buffer home, go to start screen! (mini.starter)
  (map-set-leader "bh" (fn [] (MiniStarter.open)))
  (map-set-leader "bD" ":bd!<cr>")

  ;; layout stuff, which are neovim _tabs_
  (map-set-leader "lh" ;; layout home
    (fn []
      (vim.cmd.tabnew)
      (MiniStarter.open)))
  (map-set-leader "ln" vim.cmd.tabnext)
  (map-set-leader "lp" vim.cmd.tabprev)
  (map-set-leader "lc" vim.cmd.tabclose)
  (map-set-leader "lo" (fn []
                         (let [buffer-name (vim.api.nvim_buf_get_name (vim.api.nvim_get_current_buf))
                               cursor-position (vim.api.nvim_win_get_cursor 0)]
                           (vim.cmd.tabedit buffer-name)
                           (vim.api.nvim_win_set_cursor 0 cursor-position))))
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
         :callback (fn [] (vim.cmd "qa!"))})))

  ;; Telescope!
  (local builtin (require :telescope.builtin))
  (map-set-leader "sh" builtin.help_tags { :desc "[S]earch [H]elp"})
  (map-set-leader "sk" builtin.keymaps { :desc "[S]earch [K]eymaps"})
  (map-set-leader "sf" (. (require :telescope-config) :find-files) { :desc "[S]earch [F]iles"})
  (map-set-leader "ss" builtin.builtin { :desc "[S]earch [S]elect Telescope"})
  (map-set-leader "sw" builtin.grep_string { :desc "[S]earch current [W]ord"})
  (map-set-leader "sg" (. (require :telescope-config) :live-grep) { :desc "[S]earch by [G]rep"})
  (map-set-leader "sd" builtin.diagnostics { :desc "[S]earch [D]iagnostics"})
  (map-set-leader "sr" builtin.resume { :desc "[S]earch [R]esume"})
  (map-set-leader "s." builtin.oldfiles { :desc "[S]earch Recent Files ('.' for repeat)"})
  (map-set-leader "sb" builtin.buffers { :desc "[S]earch [B]uffers (existing)"})
  (map-set-leader "sj" builtin.current_buffer_fuzzy_find { :desc "[/] Fuzzily search in current buffer"})
  (map-set-leader "s/" (fn [] (builtin.live_grep
                                {:grep_open_files true :prompt_title "Live Grep in Open Files"}))
                       {:desc "[S]earch [/] in Open Files"})
  (map-set-leader "sn" (fn [] (builtin.find_files {:cwd (vim.fn.stdpath "config")}))
                       {:desc "[S]earch [N]eovim files"})
  (map-set-leader "st" ":TodoTelescope<cr>" {:desc "[S]earch [T]odos"})
  (map-set-leader "sm" builtin.marks {:desc "[S]earch [M]arks"})
  (map-set-leader "sq" builtin.quickfix {:desc "[S]earch [Q]quickfix list"})
  (map-set-leader "sc" builtin.git_commits {:desc "[S]earch [C]ommits (git)"})
  (vim.keymap.set :n "gd" builtin.lsp_definitions {:desc "[G]oto [D]efinition" :noremap true})
  (vim.keymap.set :n "gr" builtin.lsp_references {:desc "[G]oto [R]eferences" :noremap true})
  (vim.keymap.set :n "gi" builtin.lsp_implementations {:desc "[G]oto [I]mplementations" :noremap true})
  (vim.keymap.set :n "go" builtin.lsp_type_definitions {:desc "[G]oto Type Definitions" :noremap true})


  ;; fzf-lua
  (local fzf-lua (require :fzf-lua))
  (map-set-leader "zh" fzf-lua.help_tags {:desc "[Z]earch [Help]"})
  (map-set-leader "zk" fzf-lua.keymaps { :desc "[Z]earch [K]eymaps"})
  (map-set-leader "zf" fzf-lua.files { :desc "[Z]earch [F]iles"})
  (map-set-leader "zz" fzf-lua.builtin { :desc "[Z]earch F[Z]F-lua builtins"})
  (map-set-leader "zw" fzf-lua.grep_cword { :desc "[Z]earch current [W]ord"})
  (map-set-leader "zv" fzf-lua.grep_visual { :desc "[Z]earch [V]isual selection"})
  (map-set-leader "zg" fzf-lua.live_grep { :desc "[Z]earch by [G]rep"})
  (map-set-leader "zd" fzf-lua.diagnostics_workspace { :desc "[Z]earch [D]iagnostics"})
  (map-set-leader "zr" fzf-lua.resume { :desc "[Z]earch [R]esume"})
  (map-set-leader "z." fzf-lua.oldfiles { :desc "[Z]earch Recent Files ('.' for repeat)"})
  (map-set-leader "zb" fzf-lua.buffers { :desc "[Z]earch [B]uffers (existing)"})
  (map-set-leader "zj" fzf-lua.blines { :desc "[/] Fuzzily search in current buffer"})
  (map-set-leader "z/" fzf-lua.lines {:desc "[Z]earch [/] in Open Files"})
  (map-set-leader "zn" (fn [] (fzf-lua.files {:cwd (vim.fn.stdpath "config")}))
                       {:desc "[Z]earch [N]eovim files"})
  (map-set-leader "zm" fzf-lua.marks {:desc "[Z]earch [M]arks"})
  (map-set-leader "zq" fzf-lua.quickfix {:desc "[Z]earch [Q]quickfix list"})
  (map-set-leader "zc" fzf-lua.git_commits {:desc "[Z]earch [C]ommits (git)"}))



; these are modifications of existing behavior from primeagen
(vim.keymap.set :v "p" "\"_dP" {:noremap true :silent true}) ;; don't overwrite register when pasting
(vim.keymap.set :v "d" "\"_d"  {:noremap true :silent true}) ;; don't overwrite register when deleting

(vim.keymap.set :v "P" "p" {:noremap true :silent true}) ;; overwrite register when pasting


(fn command-with-unchanged-unnamed-register [cmd]
  (fn []
    (let [old-unnamed (vim.fn.getreg "\"")]
      (vim.api.nvim_command (.. "normal! " cmd))
      (vim.fn.setreg "\"" old-unnamed))))


; clipboard integrations
(vim.keymap.set :n "<leader>cy" "\"+y" {:noremap true :silent true})
(vim.keymap.set :n "<leader>cp" "\"+p" {:noremap true :silent true})
(vim.keymap.set :n "<leader>cd" "\"+d" {:noremap true :silent true})
(vim.keymap.set :n "<leader>cY" "\"+Y" {:noremap true :silent true})
(vim.keymap.set :n "<leader>cP" "\"+P" {:noremap true :silent true})
(vim.keymap.set :n "<leader>cD" "\"+D" {:noremap true :silent true})

(vim.keymap.set :v "<leader>cY" "\"+y" {:noremap true :silent true})
(vim.keymap.set :v "<leader>cP" "\"+p" {:noremap true :silent true})
(vim.keymap.set :v "<leader>cD" "\"+d" {:noremap true :silent true})

;; yank to clipboard without changing unnamed register:
(vim.keymap.set :v "<leader>cy"
                (command-with-unchanged-unnamed-register "\"+y")
                {:noremap true :silent true})

;; paste from clipboard without changing unnamed register:
(vim.keymap.set :v "<leader>cp" "\"_d\"+P"  {:noremap true :silent true})

;; yank to clipboard without changing unnamed register:
(vim.keymap.set :v "<leader>cd"
                (command-with-unchanged-unnamed-register "\"+d")
                {:noremap true :silent true})

;jump commands

;; quickfix and location list
(vim.keymap.set :n "[q" ":cprev<cr>" {:noremap true :silent true})
(vim.keymap.set :n "]q" ":cnext<cr>" {:noremap true :silent true})
(vim.keymap.set :n "[l" ":lprev<cr>" {:noremap true :silent true})
(vim.keymap.set :n "]l" ":lnext<cr>" {:noremap true :silent true})

;; diagnostics
(vim.keymap.set :n "[d" vim.diagnostic.goto_prev)
(vim.keymap.set :n "]d" vim.diagnostic.goto_next)

;; todos
(vim.keymap.set :n "]t" (fn [] ((. (require :todo-comments) :jump_next))))
(vim.keymap.set :n "[t" (fn [] ((. (require :todo-comments) :jump_prev))))
