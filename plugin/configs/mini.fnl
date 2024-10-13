; moves selection using ctrl + [hjkl]
(local move (require :mini.move))
(move.setup
  ;; default is meta (alt),
  ;; I think ctrl is easier to press
  {:mappings {:left "<C-h>"
              :right "<C-l>"
              :down "<C-j>"
              :up "<C-k>"}})

; auto-closes brackets and stuff
(local pairs (require :mini.pairs))
(pairs.setup)

; surround parens
(local surround (require :mini.surround))
(surround.setup
  {:mappings {:add "S"}})

; comment
(local comment_ (require :mini.comment))
(comment_.setup
  {:options {:ignore_blank_line true}})

; starter screen and sessions
(local starter (require :mini.starter))
(starter.setup)
(local sessions (require :mini.sessions))
(sessions.setup
 {:autoread false
  :file ""})

(local jump2d (require :mini.jump2d))
(jump2d.setup
  {:mappings {:start_jumping "<leader>gl"}
   :view {:dim true :n_steps_ahead 2}})

(local notify (require :mini.notify))
(notify.setup)

(local trailspace (require :mini.trailspace))
(trailspace.setup)
; automatically remove trailing white space on save
(vim.api.nvim_create_autocmd "BufWritePost"
  {:pattern "*" :callback (fn [] (trailspace.trim))})
