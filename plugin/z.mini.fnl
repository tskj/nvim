; (local tabline (require :mini.tabline))
; (tabline.setup)

(local statusline (require :mini.statusline))
(statusline.setup)

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
(surround.setup)

; comment
(local comment_ (require :mini.comment))
(comment_.setup)

; starter screen and sessions
(local starter (require :mini.starter))
(starter.setup)
;(local sessions (require :mini.sessions))
;(sessions.setup
  ;{:autoread false})

; auto suggestions for code
(local completion (require :mini.completion))
(completion.setup)

