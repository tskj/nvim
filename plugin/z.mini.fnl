; (local mini-tabline (require :mini.tabline))
; (mini-tabline.setup)

(local mini-statusline (require :mini.statusline))
(mini-statusline.setup)

; moves selection using ctrl + [hjkl]
(local mini-move (require :mini.move))
(mini-move.setup
  ;; default is meta (alt),
  ;; I think ctrl is easier to press
  {:mappings {:left "<C-h>"
              :right "<C-l>"
              :down "<C-j>"
              :up "<C-k>"}})

; auto-closes brackets and stuff
(local mini-pairs (require :mini.pairs))
(mini-pairs.setup)

; surround parens
(local mini-surround (require :mini.surround))
(mini-surround.setup)

; starter screen and sessions
(local mini-starter (require :mini.starter))
(mini-starter.setup)
;(local mini-sessions (require :mini.sessions))
;(mini-sessions.setup
  ;{:autoread false})
