(local {: run} (require :user.utils))

;; get the path to the Neovim configuration directory
(local nvim-dir (vim.fn.stdpath "config"))


(fn open-in-explorer [dir]
  (fn []
    (vim.cmd (.. "cd " dir))
    (vim.cmd (.. "Oil " dir))))


(vim.keymap.set :t "<Esc><Esc>" "<C-\\><C-n>" {:desc "Activate Normal mode from Terminal"})
(vim.api.nvim_create_autocmd "TermOpen" {:pattern  "*" :command "startinsert"}) ;; auto insert mode
(vim.api.nvim_create_autocmd "BufEnter" {:pattern  "term://*" :command "startinsert"}) ;; auto insert mode


;; these are the regular bindings
(vim.keymap.set :n "<C-Enter>"  vim.lsp.buf.code_action {:desc "Code Actions [LSP]"})
(vim.keymap.set :n "<Enter>"   "m`o<Esc>k``"            {:desc "Add blank line below"})
(vim.keymap.set :n "<S-Enter>" "m`i<Enter><Esc>``"      {:desc "Break line at cursor"})
(vim.keymap.set :n "<C-h>"     "<cmd>wincmd h<cr>"      {:desc "Move focus to the window to the left"})
(vim.keymap.set :n "<C-j>"     "<cmd>wincmd j<cr>"      {:desc "Move focus to window below"})
(vim.keymap.set :n "<C-k>"     "<cmd>wincmd k<cr>"      {:desc "Move focus to window above"})
(vim.keymap.set :n "<C-l>"     "<cmd>wincmd l<cr>"      {:desc "Move focus to the window to the right"})
(vim.keymap.set :t "<C-h>"     "<cmd>wincmd h<cr>"      {:desc "Move focus to the window to the left"})
(vim.keymap.set :t "<C-j>"     "<cmd>wincmd j<cr>"      {:desc "Move focus to window below"})
(vim.keymap.set :t "<C-k>"     "<cmd>wincmd k<cr>"      {:desc "Move focus to window above"})
;; (vim.keymap.set :t "<C-l>" "<cmd>wincmd l<cr>" {:desc "Move focus to the window to the right"}) ; this breaks `clear`
(vim.keymap.set :n "<C-s>"   ":w<cr>"                                   {:desc "Save buffer (:w)"})
(vim.keymap.set :n "<C-w>"   ":q<cr>"                                   {:desc "Close window (:q)"})
(vim.keymap.set :n "<C-q>"   ":bd!<cr>"                                 {:desc "Close buffer (:bd!)"})
(vim.keymap.set :t "<C-w>"   (fn [] (vim.api.nvim_command "q"))         {:desc "Close window (:q)"})
(vim.keymap.set :t "<C-q>"   (fn [] (vim.api.nvim_command "bd!"))       {:desc "Close buffer (:bd!)"})
(vim.keymap.set :n "<C-->"   "<C-^>"                                    {:desc "Switch to Alternate Buffer (ctrl+dash)"})
(vim.keymap.set :t "<C-->"   (fn [] (vim.api.nvim_command "buffer #"))  {:desc "Switch to Alternate Buffer (ctrl+dash)"})
(vim.keymap.set :n "<C-Tab>" "<C-^>"                                    {:desc "Switch to Alternate Buffer (ctrl+tab)"})
(vim.keymap.set :t "<C-Tab>" (fn [] (vim.api.nvim_command "buffer #"))  {:desc "Switch to Alternate Buffer (ctrl+tab)"})

(fn indent-then-move-cursor [cmd]
  (fn []
    (let [prev-line (vim.api.nvim_get_current_line)]
      (vim.cmd (.. "normal! " cmd))
      (let [current-line (vim.api.nvim_get_current_line)
            indents (- (# current-line) (# prev-line))]
        (when (= indents 0)
          (lua :return))
        (if (< indents 0)
          (vim.cmd (.. "normal! " (math.abs indents) "h"))
          (vim.cmd (.. "normal! " indents "l")))))))
(vim.keymap.set :n "<Tab>" (indent-then-move-cursor ">>")   {:desc "Indent line" :noremap true})
(vim.keymap.set :n "<leader><Tab>" "V="                     {:desc "Format line" :noremap true})
;; necessary to avoid ctrl+i also meaning tab in normal mode
(vim.keymap.set :n "<C-i>"   "<C-i>"                        {:noremap true})
(vim.keymap.set :n "<S-Tab>" (indent-then-move-cursor "<<") {:desc "Dedent line" :noremap true})

(vim.keymap.set [:n :t] "<C-S-H>" (fn [] (vim.api.nvim_command "bp"))      {:desc "Previous Buffer (:bp)"})
(vim.keymap.set [:n :t] "<C-S-L>" (fn [] (vim.api.nvim_command "bn"))      {:desc "Next Buffer (:bn)"})
(vim.keymap.set [:n :t] "<C-S-K>" (fn [] (vim.api.nvim_command "tabnext")) {:desc "Next Tab (:tabnext)"})
(vim.keymap.set [:n :t] "<C-S-J>" (fn [] (vim.api.nvim_command "tabprev")) {:desc "Previous Tab (:tabprev)"})


;; Leap
(vim.keymap.set [:n :x :o] "<leader>gj" "<Plug>(leap-forward)"  {:desc "[G]oto [J]ump forwards [Leap]"})
(vim.keymap.set [:n :x :o] "<leader>gJ" "<Plug>(leap-backward)" {:desc "[G]oto [J]ump backwards [Leap]"})

;; Sneak
(vim.keymap.set [:n :x :o] "gj" "<Plug>Sneak_s" {:desc "[G]oto [J]ump forwards [Sneak]"})
(vim.keymap.set [:n :x :o] "gJ" "<Plug>Sneak_S" {:desc "[G]oto [J]ump backwards [Sneak]"})


;;; these are all the spacemacs-like keybindings

;; closes all other windows in current layout
;; if you want to temporarily maximize the window,
;; checkout <leader> lo below
(vim.keymap.set [:n :v] "<leader>wo" ":only<cr>"                 {:desc "[W]indow [O]nly (close every other window)"})
(vim.keymap.set [:n :v] "<leader>bs" ":enew<cr>"                 {:desc "[B]uffer [S]cratch (new buffer)"})
(vim.keymap.set [:n :v] "<leader>en" (open-in-explorer nvim-dir) {:desc "[E]xplore [N]eovim config files"})
(vim.keymap.set [:n :v] "<leader>eh" (open-in-explorer "~")      {:desc "[E]xplore [H]ome"})
(vim.keymap.set [:n :v] "<leader>ec" (open-in-explorer "~/code") {:desc "[E]xplore [C]ode"})
(vim.keymap.set [:n :v] "<leader>ep" (fn []
                                       (run
                                         (open-in-explorer
                                           (-> :user.find-git-repo
                                               (require)
                                               (. :get-path-to-repo)
                                               (run (vim.fn.getcwd))))))
                {:desc "[E]xplore [P]roject (according to git repo)"})

(vim.keymap.set [:n :v] "<leader>vd" vim.diagnostic.open_float   {:desc "[V]iew [D]diagnostic"})

(vim.keymap.set [:n :v] "<leader>ri" vim.lsp.buf.rename    {:desc "[R]ename [I]dentifier [LSP]"})

;; open file explorer in directory of current file
(vim.keymap.set [:n :v] "<leader>ef" (open-in-explorer "") {:desc "[E]xplore [F]ile (open directory of cwd)"})

;; neogit
(vim.keymap.set [:n :v] "<leader>gs" ":Neogit<cr>"        {:desc "[G]it [S]tage [Neogit]"})
(vim.keymap.set [:n :v] "<leader>gc" ":Neogit commit<cr>" {:desc "[G]it [C]ommit [Neogit]"})

;; open terminal (in spacemacs this is SPC a t for "application: terminal")
(vim.keymap.set [:n :v] "<leader>ac" vim.cmd.terminal                            {:desc "[A]pplication [C]ommand line (opens terminal)"})
(vim.keymap.set [:n :v] "<leader>ap" (fn [] (vim.cmd.terminal "powershell.exe")) {:desc "[A]pplication [P]owershell"})
(vim.keymap.set [:n :v] "<leader>al" (fn [] (vim.cmd.terminal "wsl.exe zsh"))    {:desc "[A]pplication [L]inux (wsl zsh)"})
(vim.keymap.set [:n :v] "<leader>ab" (fn [] (vim.cmd.terminal "wsl.exe bash"))   {:desc "[A]pplication [B]ash (wsl bash)"})

(vim.keymap.set [:n :v] "<leader>wr" vim.cmd.WinResizerStartResize {:desc "[W]indow [R]esize"})
(vim.keymap.set [:n :v] "<leader>wD" ":q!<cr>"                     {:desc "[W]indow [D]elete force (:q!)"})

;; buffer home, go to start screen! (mini.starter)
(vim.keymap.set [:n :v] "<leader>bh" (fn [] (-> :mini.starter (require) (. :open) (run))) {:desc "[B]uffer [H]ome [Mini.Starter]"})
(vim.keymap.set [:n :v] "<leader>bD" ":bd!<cr>"                                           {:desc "[B]uffer [D]elete force (:bd!)"})


;; layout/layer stuff, which are neovim _tabs_
(vim.keymap.set [:n :v] "<leader>lh"
  (fn []
    (vim.cmd.tabnew)
    (-> :mini.starter (require) (. :open) (run)))
  {:desc "[L]ayer [H]ome (open new tab with Starter page)"})
(vim.keymap.set [:n :v] "<leader>ln" vim.cmd.tabnext  {:desc "[L]ayer [N]ext (next tab)"})
(vim.keymap.set [:n :v] "<leader>lp" vim.cmd.tabprev  {:desc "[L]ayer [P]rev (prev tab)"})
(vim.keymap.set [:n :v] "<leader>lc" vim.cmd.tabclose {:desc "[L]ayer [C]lose (close tab)"})
(vim.keymap.set [:n :v] "<leader>lo"
                (fn []
                  (let [buffer-name (vim.api.nvim_buf_get_name (vim.api.nvim_get_current_buf))
                        cursor-position (vim.api.nvim_win_get_cursor 0)]
                    (vim.cmd.tabedit buffer-name)
                    (vim.api.nvim_win_set_cursor 0 cursor-position)))
                {:desc "[L]ayer [O]nly (open buffer in new tab to 'maximize' it)"})
(vim.keymap.set [:n :v] "<leader>l<" (fn [] (vim.cmd.tabmove "-1")) {:desc "[L]ayer [<]eft (move tab left)"})
(vim.keymap.set [:n :v] "<leader>l>" (fn [] (vim.cmd.tabmove "+1")) {:desc "[L]ayer [>]ight (move tab right)"})


;; compile all fennel config using make and then quit
;; (sadly there's no way to restart neovim automatically)
(vim.keymap.set [:n :v] "<leader>qr"
  (fn []
    (vim.cmd (.. "cd " nvim-dir))
    (vim.cmd.terminal "make")
    ;; Setup an autocommand to quit Neovim after make completes
    (vim.api.nvim_create_autocmd "TermClose"
      {:pattern "term://*make"
       :callback (fn [] (vim.cmd "qa!"))}))
  {:desc "[Q]uit [R]eload (compiles fennel and quits)"})

(vim.keymap.set [:n :v] "<leader>u" (fn [] (-> :undotree (require) (. :toggle) (run))) {:desc "[U]ndo tree "})

;; spacemacs basics
(vim.keymap.set :n "<leader>bd" ":bd<cr>"    {:desc "[B]uffer [D]elete"})
(vim.keymap.set :n "<leader>bn" ":bn<cr>"    {:desc "[B]uffer [N]ext"})
(vim.keymap.set :n "<leader>bp" ":bp<cr>"    {:desc "[B]uffer [P]rev"})
(vim.keymap.set :n "<leader>bR" ":e<cr>"     {:desc "[B]uffer [R]eload"})
(vim.keymap.set :n "<leader>fs" ":w<cr>"     {:desc "[F]ile [S]ave (same as ctrl+s)"})
(vim.keymap.set :n "<leader>fS" ":wa<cr>"    {:desc "[F]ile [S]ave all"})
(vim.keymap.set :n "<leader>qq" ":qa<cr>"    {:desc "[Q]uit all"})
(vim.keymap.set :n "<leader>qQ" ":qa!<cr>"   {:desc "[Q]uit all force"})
(vim.keymap.set :n "<leader>qs" ":xa<cr>"    {:desc "[Q]uit [S]ave"})
(vim.keymap.set :n "<leader>w-" ":sp<cr>"    {:desc "[W]indow [-]plit horizontally"})
(vim.keymap.set :n "<leader>w/" ":vsp<cr>"   {:desc "[W]indow [/]plit vertically"})
(vim.keymap.set :n "<leader>w=" "<C-W>="     {:desc "[W]indow [=]qualize"})
(vim.keymap.set :n "<leader>wd" ":q<cr>"     {:desc "[W]indow [D]elete"})
(vim.keymap.set :n "<leader>wn" "<C-W><C-W>" {:desc "[W]indow [N]ext (focus)"})
(vim.keymap.set :n "<leader>wh" "<cmd>wincmd h<cr>" {:desc "Move focus to the window to the left"})
(vim.keymap.set :n "<leader>wj" "<cmd>wincmd j<cr>" {:desc "Move focus to window below"})
(vim.keymap.set :n "<leader>wk" "<cmd>wincmd k<cr>" {:desc "Move focus to window above"})
(vim.keymap.set :n "<leader>wl" "<cmd>wincmd l<cr>" {:desc "Move focus to the window to the right"})

;; telescope
(local builtin (require :telescope.builtin))
(vim.keymap.set [:n :v] "<leader>sh" builtin.help_tags                 {:desc "[S]earch [H]elp"})
(vim.keymap.set [:n :v] "<leader>sk" builtin.keymaps                   {:desc "[S]earch [K]eymaps"})
(vim.keymap.set [:n :v] "<leader>sf"
                (. (require :user.telescope-config) :find-files)       {:desc "[S]earch [F]iles"})
(vim.keymap.set [:n :v] "<leader>ss" builtin.builtin                   {:desc "[S]earch [S]elect Telescope"})
(vim.keymap.set [:n :v] "<leader>sw" builtin.grep_string               {:desc "[S]earch current [W]ord"})
(vim.keymap.set [:n :v] "<leader>sg"
                (. (require :user.telescope-config) :live-grep)        {:desc "[S]earch by [G]rep"})
(vim.keymap.set [:n :v] "<leader>sd" builtin.diagnostics               {:desc "[S]earch [D]iagnostics"})
(vim.keymap.set [:n :v] "<leader>sr" builtin.resume                    {:desc "[S]earch [R]esume"})
(vim.keymap.set [:n :v] "<leader>s." builtin.oldfiles                  {:desc "[S]earch Recent Files ('.' for repeat)"})
(vim.keymap.set [:n :v] "<leader>sb" builtin.buffers                   {:desc "[S]earch [B]uffers (existing)"})
(vim.keymap.set [:n :v] "<leader>sj" builtin.current_buffer_fuzzy_find {:desc "[S]earch [J]ump: fuzzily search in current buffer"})
(vim.keymap.set [:n :v] "<leader>s/"
                (fn [] (builtin.live_grep
                         {:grep_open_files true
                          :prompt_title "Live Grep in Open Files"}))   {:desc "[S]earch [/] in Open Files"})
(vim.keymap.set [:n :v] "<leader>sn"
                (fn [] (builtin.find_files
                         {:cwd (vim.fn.stdpath "config")}))            {:desc "[S]earch [N]eovim config files"})
(vim.keymap.set [:n :v] "<leader>st" ":TodoTelescope<cr>"              {:desc "[S]earch [T]odos"})
(vim.keymap.set [:n :v] "<leader>sm" builtin.marks                     {:desc "[S]earch [M]arks"})
(vim.keymap.set [:n :v] "<leader>sq" builtin.quickfix                  {:desc "[S]earch [Q]quickfix list"})
(vim.keymap.set [:n :v] "<leader>sc" builtin.git_commits               {:desc "[S]earch [C]ommits (git)"})
(vim.keymap.set [:n :v] "<leader>su" (fn [] (-> :telescope (require) (. :extensions :undo :undo) (run))) {:desc "[S]earch [U]ndo tree"})


(vim.keymap.set :n "gd" builtin.lsp_definitions      {:desc "[G]oto [D]efinition [LSP]"})
(vim.keymap.set :n "gr" builtin.lsp_references       {:desc "[G]oto [R]eferences [LSP]"})
(vim.keymap.set :n "gi" builtin.lsp_implementations  {:desc "[G]oto [I]mplementations [LSP]"})
(vim.keymap.set :n "go" builtin.lsp_type_definitions {:desc "[G]oto Type Definitions [LSP]"})


;; fzf-lua
(local fzf-lua (require :fzf-lua))
(vim.keymap.set [:n :v] "<leader>zh" fzf-lua.help_tags             {:desc "[Z]earch [H]elp [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zk" fzf-lua.keymaps               {:desc "[Z]earch [K]eymaps [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zf" fzf-lua.files                 {:desc "[Z]earch [F]iles [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zz" fzf-lua.builtin               {:desc "[Z]earch F[Z]F-lua builtins [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zw" fzf-lua.grep_cword            {:desc "[Z]earch current [W]ord [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zv" fzf-lua.grep_visual           {:desc "[Z]earch [V]isual selection [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zg" fzf-lua.live_grep             {:desc "[Z]earch by [G]rep [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zd" fzf-lua.diagnostics_workspace {:desc "[Z]earch [D]iagnostics [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zr" fzf-lua.resume                {:desc "[Z]earch [R]esume [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>z." fzf-lua.oldfiles              {:desc "[Z]earch Recent Files ('.' for repeat) [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zb" fzf-lua.buffers               {:desc "[Z]earch [B]uffers (existing) [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zj" fzf-lua.blines                {:desc "[/] Fuzzily search in current buffer [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>z/" fzf-lua.lines                 {:desc "[Z]earch [/] in Open Files [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zn"
                (fn [] (fzf-lua.files
                         {:cwd (vim.fn.stdpath "config")}          {:desc "[Z]earch [N]eovim config files [fzf-lua]"})))
(vim.keymap.set [:n :v] "<leader>zm" fzf-lua.marks                 {:desc "[Z]earch [M]arks [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zq" fzf-lua.quickfix              {:desc "[Z]earch [Q]quickfix list [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zc" fzf-lua.git_commits           {:desc "[Z]earch [C]ommits (git) [fzf-lua]"})


;; these are modifications of existing behavior, from primeagen
(vim.keymap.set :n "D" "\"_D"  {:silent true}) ; dont' overwrite register when pasting
(vim.keymap.set :v "p" "\"_dP" {:silent true}) ; don't overwrite register when pasting
(vim.keymap.set :v "d" "\"_d"  {:silent true}) ; don't overwrite register when deleting
(vim.keymap.set :v "D" "\"_d"  {:silent true}) ; dont' overwrite register when pasting

(vim.keymap.set :n "X" "D"     {:silent true}) ; cut to end of line)
(vim.keymap.set :v "P" "p"     {:silent true}) ; overwrite register when pasting


(fn command-with-unchanged-unnamed-register [cmd]
  (fn []
    (let [old-unnamed (vim.fn.getreg "\"")]
      (vim.api.nvim_command (.. "normal! " cmd))
      (vim.fn.setreg "\"" old-unnamed))))

;; clipboard integrations
(vim.keymap.set :n "<leader>cy" "\"+y" {:silent true :desc "[C]lipboard [Y]ank (y)"})
(vim.keymap.set :n "<leader>cp" "\"+p" {:silent true :desc "[C]lipboard [P]aste (p)"})
(vim.keymap.set :n "<leader>cd" "\"+d" {:silent true :desc "[C]lipboard [D]elete (d)"})
(vim.keymap.set :n "<leader>cY" "\"+Y" {:silent true :desc "[C]lipboard [Y]ank (Y)"})
(vim.keymap.set :n "<leader>cP" "\"+P" {:silent true :desc "[C]lipboard [P]aste (P)"})
(vim.keymap.set :n "<leader>cD" "\"+D" {:silent true :desc "[C]lipboard [D]elete (D)"})

(vim.keymap.set :v "<leader>cY" "\"+y" {:silent true :desc "[C]lipboard [Y]ank (Y)"})
(vim.keymap.set :v "<leader>cP" "\"+p" {:silent true :desc "[C]lipboard [P]aste (P)"})
(vim.keymap.set :v "<leader>cD" "\"+d" {:silent true :desc "[C]lipboard [D]elete (D)"})

;; yank to clipboard without changing unnamed register:
(vim.keymap.set :v "<leader>cy"
                (command-with-unchanged-unnamed-register "\"+y")
                {:silent true :desc "[C]lipboard [Y]ank (y)"})

;; paste from clipboard without changing unnamed register:
(vim.keymap.set :v "<leader>cp" "\"_d\"+P"  {:silent true :desc "[C]lipboard [P]aste (p)"})

;; yank to clipboard without changing unnamed register:
(vim.keymap.set :v "<leader>cd"
                (command-with-unchanged-unnamed-register "\"+d")
                {:silent true :desc "[C]lipbaord [D]elete (d)"})

;;; jump commands

(var m-type nil)

(fn register [type]
  (set m-type type)
  (vim.defer_fn
    (fn [] (set m-type nil))
    100_000))

(vim.keymap.set :n ";"
                (fn []
                  (match m-type
                    :q (vim.cmd "normal ]q")
                    :l (vim.cmd "normal ]l")
                    :d (vim.cmd "normal ]d")
                    :t (vim.cmd "normal ]t")
                    _  (vim.cmd "normal! ;"))))

(vim.keymap.set :n ","
                (fn []
                  (match m-type
                    :q (vim.cmd "normal [q")
                    :l (vim.cmd "normal [l")
                    :d (vim.cmd "normal [d")
                    :t (vim.cmd "normal [t")
                    _  (vim.cmd "normal! ,"))))

;; quickfix and location list
(vim.keymap.set :n "[q" (fn []
                          (register :q)
                          (vim.api.nvim_command "cprev")) {:desc "[[]ump [Q]uickfix previous (:cprev)"})
(vim.keymap.set :n "]q" (fn []
                          (register :q)
                          (vim.api.nvim_command "cnext")) {:desc "[]]ump [Q]uickfix next (:cnext)"})
(vim.keymap.set :n "[l" (fn []
                          (register :l)
                          (vim.api.nvim_command "lprev")) {:desc "[[]ump [L]ocation previous (:lprev)"})
(vim.keymap.set :n "]l" (fn []
                          (register :l)
                          (vim.api.nvim_command "lnext")) {:desc "[]]ump [L]ocation next (:lnext)"})

;; diagnostics
(vim.keymap.set :n "[d" (fn []
                          (register :d)
                          (vim.diagnostic.goto_prev)) {:desc "[[]ump [D]iagnostic previous"})
(vim.keymap.set :n "]d" (fn []
                          (register :d)
                          (vim.diagnostic.goto_next)) {:desc "[]]ump [D]iagnostic next"})

;; todos
(vim.keymap.set :n "[t"
                (fn []
                  (register :t)
                  (-> (require :todo-comments)
                      (. :jump_prev)
                      (run)))                  {:desc "[[]ump [T]odo previous"})
(vim.keymap.set :n "]t"
                (fn []
                  (register :t)
                  (-> (require :todo-comments)
                      (. :jump_next)
                      (run)))                  {:desc "[]]ump [T]odo next"})
