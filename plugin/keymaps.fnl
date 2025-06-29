(local {: run : gitsigns-quickfix-volatile} (require :user.utils))

;; get the path to the Neovim configuration directory
(local nvim-dir (vim.fn.stdpath "config"))


(fn open-in-explorer [dir ?opts]
  (fn []
    (when (and ?opts (. ?opts :new-tab))
      (vim.cmd "tabedit"))
    (vim.cmd (.. "cd " dir))
    (vim.cmd (.. "Oil " dir))))


(vim.keymap.set :t "<Esc><Esc>" "<C-\\><C-n>" {:desc "Activate Normal mode from Terminal"})
(vim.api.nvim_create_autocmd "TermOpen" {:pattern  "*" :command "startinsert"}) ;; auto insert mode
;; (vim.api.nvim_create_autocmd "BufEnter" {:pattern  "term://*" :command "startinsert"}) ;; auto insert mode
(vim.api.nvim_create_autocmd
  :TermOpen
  {:callback (fn []
               (vim.keymap.set :n :<Enter>
                               (fn []
                                 (vim.api.nvim_feedkeys :i :n false)
                                 (vim.api.nvim_feedkeys (vim.api.nvim_replace_termcodes :<CR> true false true)
                                                        :n
                                                        false))
                               {:buffer true
                                :desc "Enter terminal mode and send Enter"}))})

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
(vim.keymap.set :n "Z" "zz"  {:desc "Center this line"})

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
(vim.keymap.set [:n :v :o] "<leader>gl" "<Plug>(leap-forward)"  {:desc "[G]oto [L]eap forwards [Leap]"})
(vim.keymap.set [:n :v :o] "<leader>gl" "<Plug>(leap-backward)" {:desc "[G]oto [L]eap backwards [Leap]"})

;; Sneak
(vim.keymap.set [:n :v :o] "gl" "<Plug>Sneak_s" {:desc "[G]oto [L]eap forwards [Sneak]"})
(vim.keymap.set [:n :v :o] "gL" "<Plug>Sneak_S" {:desc "[G]oto [L]eap backwards [Sneak]"})


;;; these are all the spacemacs-like keybindings

;; closes all other windows in current layout
;; if you want to temporarily maximize the window,
;; checkout <leader> lo below
(vim.keymap.set [:n :v] "<leader>wo" ":only<cr>"                 {:desc "[W]indow [O]nly (close every other window)"})
(vim.keymap.set [:n :v] "<leader>bs" ":enew<cr>"                 {:desc "[B]uffer [S]cratch (new buffer)"})
(vim.keymap.set [:n :v] "<leader>ev" (open-in-explorer nvim-dir {:new-tab true}) {:desc "[E]xplore [V]im config (in new tab)"})
(vim.keymap.set [:n :v] "<leader>en" (open-in-explorer "~/notes" {:new-tab true}) {:desc "[E]xplore [N]otes (in new tab)"})
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
(vim.keymap.set [:n :v] "<leader>vh" ":Gitsigns preview_hunk<cr>"         {:desc "[V]iew [H]unk"})
(vim.keymap.set [:n :v] "<leader>vi" ":Gitsigns preview_hunk_inline<cr>"  {:desc "[V]iew hunk [I]nline"})
(vim.keymap.set [:n :v] "<leader>vb" ":Gitsigns toggle_current_line_blame<cr>" {:desc "[V]iew [B]lame inline (toggle)"})

(vim.keymap.set [:n :v] "<leader>ri" vim.lsp.buf.rename    {:desc "[R]ename [I]dentifier [LSP]"})

;; open file explorer in directory of current file
(vim.keymap.set [:n :v] "<leader>ef" (open-in-explorer "") {:desc "[E]xplore [F]ile (open directory of cwd)"})

;; Notes namespace
(local mini-notify (require :mini.notify))
(local notes-notify (mini-notify.make_notify))

(fn open-todays-journal []
  (let [today (os.date "%Y-%m-%d")
        year (os.date "%Y")
        journal-dir (.. "~/notes/.private/journal/" year)]
    ;; Ensure the year directory exists
    (vim.fn.system (.. "mkdir -p " journal-dir))
    (vim.cmd (.. ":edit " journal-dir "/" today ".norg"))))
(vim.keymap.set [:n :v] "<leader>nj" open-todays-journal {:desc "[N]otes [J]ournal (open today's entry)"})
(vim.keymap.set [:n :v] "<leader>ns" 
  (fn [] 
    (notes-notify "running save script..." vim.log.levels.INFO)
    (vim.fn.jobstart [(.. (vim.fn.expand "~/notes") "/.bin/save.sh")]
      {:on_stdout (fn [_ data _]
                    (each [_ line (ipairs data)]
                      (when (and line (not= line ""))
                        (vim.schedule #(notes-notify line vim.log.levels.INFO)))))
       :on_stderr (fn [_ data _]
                    (each [_ line (ipairs data)]
                      (when (and line (not= line ""))
                        (vim.schedule #(notes-notify line vim.log.levels.ERROR)))))
       :on_exit (fn [_ code _]
                  (vim.schedule
                    #(if (= code 0)
                       (notes-notify "notes saved successfully!" vim.log.levels.INFO)
                       (notes-notify "save script failed!" vim.log.levels.ERROR))))}))
  {:desc "[N]otes [S]ave (run save script)"})
(vim.keymap.set [:n :v] "<leader>np" 
  (fn [] 
    (notes-notify "pulling notes from git..." vim.log.levels.INFO)
    (vim.fn.jobstart ["git" "pull"]
      {:cwd (vim.fn.expand "~/notes")
       :on_stdout (fn [_ data _]
                    (each [_ line (ipairs data)]
                      (when (and line (not= line ""))
                        (vim.schedule #(notes-notify line vim.log.levels.INFO)))))
       :on_stderr (fn [_ data _]
                    (each [_ line (ipairs data)]
                      (when (and line (not= line ""))
                        (vim.schedule #(notes-notify line vim.log.levels.WARN)))))
       :on_exit (fn [_ code _]
                  (vim.schedule
                    #(if (= code 0)
                       (notes-notify "notes pulled successfully!" vim.log.levels.INFO)
                       (notes-notify "git pull failed!" vim.log.levels.ERROR))))}))
  {:desc "[N]otes [P]ull from git"})
(vim.keymap.set [:n :v] "<leader>nn" (open-in-explorer "~/notes") {:desc "[N]otes [N]avigate (open notes directory)"})

;; neogit
(vim.keymap.set [:n :v] "<leader>gs" ":Neogit<cr>"        {:desc "[G]it [S]tage [Neogit]"})
(vim.keymap.set [:n :v] "<leader>gc" ":Neogit commit<cr>" {:desc "[G]it [C]ommit [Neogit]"})

;; lazygit
(vim.keymap.set [:n :v] "<leader>gl" ":LazyGit<cr>" {:desc "[G]it [L]azy"})

;; git quickfix
(vim.keymap.set [:n :v] "<leader>gq" gitsigns-quickfix-volatile {:desc "[G]it [Q]uickfix"})

;; open terminal (moved from <leader>a* to avoid claudecode.nvim conflicts)
(vim.keymap.set [:n :v] "<leader>tc" vim.cmd.terminal                            {:desc "[T]erminal [C]ommand line"})
(vim.keymap.set [:n :v] "<leader>tp" (fn [] (vim.cmd.terminal "powershell.exe")) {:desc "[T]erminal [P]owershell"})
(vim.keymap.set [:n :v] "<leader>tl" (fn [] (vim.cmd.terminal "wsl.exe zsh"))    {:desc "[T]erminal [L]inux (wsl zsh)"})
(vim.keymap.set [:n :v] "<leader>tb" (fn [] (vim.cmd.terminal "wsl.exe bash"))   {:desc "[T]erminal [B]ash (wsl bash)"})

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
(vim.keymap.set [:n :v] "<leader>sa"
                (. (require :user.telescope-config) :find-hidden-files)
                {:desc "[S]earch [A]ll files (includes hidden but hides .gitignore)"})
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
(vim.keymap.set [:n :v] "<leader>sv"
                (fn [] (builtin.find_files
                         {:cwd (vim.fn.stdpath "config")}))            {:desc "[S]earch [V]im config files"})
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
(vim.keymap.set [:n :v] "<leader>zv"
                (fn [] (fzf-lua.files
                         {:cwd (vim.fn.stdpath "config")}))          {:desc "[Z]earch [V]im config files [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zm" fzf-lua.marks                 {:desc "[Z]earch [M]arks [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zq" fzf-lua.quickfix              {:desc "[Z]earch [Q]quickfix list [fzf-lua]"})
(vim.keymap.set [:n :v] "<leader>zc" fzf-lua.git_commits           {:desc "[Z]earch [C]ommits (git) [fzf-lua]"})


;; command-with-unchanged-unnamed-register
(fn uur [cmd]
  (fn []
    (let [old-unnamed (vim.fn.getreg "\"")]
      (vim.api.nvim_command (.. "normal! " cmd))
      (vim.fn.setreg "\"" old-unnamed))))
(fn uur-2 [cmd r] ;; also writes to register r as if it was unnamed
  (fn []
    (let [old-unnamed (vim.fn.getreg "\"")]
      (vim.api.nvim_command (.. "normal! " cmd))
      (let [new-unnamed (vim.fn.getreg "\"")]
        (vim.fn.setreg r new-unnamed)
        (vim.fn.setreg "\"" old-unnamed)))))

;; these are modifications of existing behavior, from primeagen
(vim.keymap.set :n "d" "\"_d"  {:silent true}) ; don't overwrite register when deleting
(vim.keymap.set :n "D" "\"_D"  {:silent true}) ; don't overwrite register when deleting
(vim.keymap.set :v "d" "\"_d"  {:silent true}) ; don't overwrite register when deleting in visual mode
(vim.keymap.set :v "D" "\"_D"  {:silent true}) ; don't overwrite register when deleting in visual mode
(vim.keymap.set :v "p" (uur "p") {:silent true}) ; don't overwrite register when pasting
(vim.keymap.set :v "P" "p"     {:silent true}) ; overwrite register when pasting over stuff using shift P

;; special cut tool
(vim.keymap.set :n "<leader>d" "d" {:silent true :desc "[C]lipboard [Y]ank (y)"})
(vim.keymap.set :n "<leader>D" "D" {:silent true :desc "[C]lipboard [P]aste (p)"})
(vim.keymap.set :v "<leader>d" "d" {:silent true :desc "[C]lipboard [D]elete (d)"})
(vim.keymap.set :v "<leader>D" "d" {:silent true :desc "[C]lipboard [Y]ank (Y)"})


;; clipboard integrations

; operator pending mode for y and d
(fn vim.g.clipboard_yank_operator [motion-type]
  (let [old-reg-content (vim.fn.getreg "\"")
        old-reg-type (vim.fn.getregtype "\"")
        v (match motion-type
            "line"  "V"
            "block" "\x16"
            _       "v")]

    (vim.cmd (.. "normal! `[" v "`]\"+y"))
    (vim.fn.setreg "\"" old-reg-content old-reg-type)))

(vim.keymap.set :n :<leader>cy (fn []
                                 (set vim.o.operatorfunc
                                      "v:lua.vim.g.clipboard_yank_operator")
                                 "g@")
                {:silent true :desc "[C]lipboard [Y]ank (y)" :expr true})

(fn vim.g.clipboard_append_operator [motion-type]
  (let [old-reg-content (vim.fn.getreg "\"")
        old-reg-type (vim.fn.getregtype "\"")
        current-clipboard (vim.fn.getreg "+")
        v (match motion-type
            "line"  "V"
            "block" "\x16"
            _       "v")]

    (vim.cmd (.. "normal! `[" v "`]y"))
    (let [yanked-text (vim.fn.getreg "\"")]
      (vim.fn.setreg "+" (.. current-clipboard yanked-text)))
    (vim.fn.setreg "\"" old-reg-content old-reg-type)))

(vim.keymap.set :n :<leader>ce (fn []
                                 (set vim.o.operatorfunc
                                      "v:lua.vim.g.clipboard_append_operator")
                                 "g@")
                {:silent true :desc "[C]lipboard [E]xtend (append)" :expr true})

(fn vim.g.clipboard_delete_operator [motion-type]
  (let [old-reg-content (vim.fn.getreg "\"")
        old-reg-type (vim.fn.getregtype "\"")
        v (match motion-type
            "line"  "V"
            "block" "\x16"
            _       "v")]

    (vim.cmd (.. "normal! `[" v "`]\"+d"))
    (vim.fn.setreg "\"" old-reg-content old-reg-type)))

(vim.keymap.set :n :<leader>cd (fn []
                                 (set vim.o.operatorfunc
                                      "v:lua.vim.g.clipboard_delete_operator")
                                 "g@")
                {:silent true :desc "[C]lipboard [D]elete (d)" :expr true})

(vim.keymap.set :n "<leader>cp" (uur "\"+p") {:silent true :desc "[C]lipboard [P]aste (p)"})
(vim.keymap.set :n "<leader>cY" (uur "\"+y$") {:silent true :desc "[C]lipboard [Y]ank (Y)"})
(vim.keymap.set :n "<leader>cP" (uur "\"+P") {:silent true :desc "[C]lipboard [P]aste (P)"})
(vim.keymap.set :n "<leader>cD" (uur "\"+D") {:silent true :desc "[C]lipboard [D]elete (D)"})

(vim.keymap.set :v "<leader>cy" (uur "\"+y") {:silent true :desc "[C]lipboard [Y]ank (y)"})
(vim.keymap.set :v "<leader>ce"
                (fn []
                  (let [old-unnamed (vim.fn.getreg "\"")
                        current-clipboard (vim.fn.getreg "+")]
                    (vim.cmd "normal! y")
                    (let [yanked-text (vim.fn.getreg "\"")]
                      (vim.fn.setreg "+" (.. current-clipboard yanked-text))
                      (vim.fn.setreg "\"" old-unnamed))))
                {:silent true :desc "[C]lipboard [E]xtend (append)"})
(vim.keymap.set :v "<leader>cY" (uur "\"+y") {:silent true :desc "[C]lipboard [Y]ank (Y)"})
(vim.keymap.set :v "<leader>cP" (uur-2 "\"+p" "+") {:silent true :desc "[C]lipboard [P]aste (P)"})
(vim.keymap.set :v "<leader>cD" (uur "\"+D") {:silent true :desc "[C]lipboard [D]elete (D)"})
(vim.keymap.set :v "<leader>cp" (uur "\"+p")  {:silent true :desc "[C]lipboard [P]aste (p)"})
(vim.keymap.set :v "<leader>cd" (uur "\"+d") {:silent true :desc "[C]lipbaord [D]elete (d)"})


;;; jump commands

(var m-type nil)
(var m-timer nil)

(fn register [type]
  (set m-type type)
  (when m-timer
    (vim.fn.timer_stop m-timer))
  (set m-timer (vim.fn.timer_start 100_000
                                   (fn []
                                     (set m-type nil)
                                     (set m-timer nil)))))

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

;; refactors
(vim.keymap.set :v "<leader>ref" ":Refactor extract "         {:desc "[R]efactor [E]xtract [F]unction"})
(vim.keymap.set :v "<leader>rff" ":Refactor extract_to_file " {:desc "[R]efactor to [F]ile: [F]unction"})
(vim.keymap.set :v "<leader>rev" ":Refactor extract_var "     {:desc "[R]efactor [E]xtract [V]variable"})
(vim.keymap.set :n "<leader>rIf" ":Refactor inline_func<cr>"      {:desc "[R]efactor [I]nline [F]unctino"})
(vim.keymap.set [:n :v] "<leader>rIv" ":Refactor inline_var<cr>"  {:desc "[R]efactor [I]nline [V]ariable"})
(vim.keymap.set :n "<leader>reb" ":Refactor extract_block<cr>"    {:desc "[R]efactor [E]xtract [B]lock"})
(vim.keymap.set :n "<leader>rfb" ":Refactor extract_block<cr>"    {:desc "[R]efactor to [F]ile: [B]lock"})
(vim.keymap.set [:n :v] "<leader>rs" (fn [] ((-> :telescope (require) (. :extensions :refactoring :refactors)))) {:desc "[R]efactor [S]earch (telescope)"})
;; debug
(vim.keymap.set :n "<leader>rdf" (fn [] ((-> :refactoring (require) (. :debug :printf))))                        {:desc "[R]efactor [D]debug [F]unction"})
(vim.keymap.set [:n :v] "<leader>rdp" (fn [] ((-> :refactoring (require) (. :debug :print_var))))                {:desc "[R]efactor [D]debug [P]rint (variable or selection)"})
(vim.keymap.set [:n :v] "<leader>rdc" (fn [] ((-> :refactoring (require) (. :debug :cleanup)) {}))              {:desc "[R]efactor [D]debug [C]lean"})

;; Quickfix window specific keybindings
(vim.api.nvim_create_autocmd "FileType"
  {:pattern "qf"
   :callback (fn []
               (vim.keymap.set :n "<CR>" "<CR><cmd>cclose<cr>"
                               {:buffer true :desc "Jump to item and close quickfix"}))})

;; AI
(vim.keymap.set [:n :v] "gpr" ":GpRewrite<cr>" {:desc "[G][P][R]ewrite"})
(vim.keymap.set [:n :v] "gpa" ":GpAppend<cr>" {:desc "[G][P][A]ppend"})
(vim.keymap.set [:n :v] "gpc" ":GpChatNew<cr>" {:desc "[G][P][C]hat new"})
(vim.keymap.set [:n :v] "gpt" ":GpChatToggle<cr>" {:desc "[G][P][T]oggle (chat)"})
(vim.keymap.set [:n :v] "gpq" ":GpPopup<cr>" {:desc "[G][P][Q]uestion (popup)"})

(vim.keymap.set :n "gpf" "<cmd>ClaudeCodeFind<cr>" {:desc "[G][P][F]ind file (Claude)"})

;; Custom Claude prompt with selection
(vim.keymap.set :v "<leader>ap" "<cmd>ClaudeSelectionWithPrompt<cr>" {:desc "[A]I [P]rompt with selection"})
