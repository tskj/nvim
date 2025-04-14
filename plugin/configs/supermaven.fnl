(local {: run} (require :user.utils))

(-> :supermaven-nvim (require) (. :setup)
  (run {:disable_inline_completion true}))
