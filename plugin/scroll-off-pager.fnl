(local top-limit 14)
(local bot-limit top-limit)

(set vim.o.scrolloff top-limit)

(fn scrolly []
  (let [win-height (vim.api.nvim_win_get_height 0)
        cursor-line (vim.fn.winline)]
    (print "cursor " cursor-line " < " top-limit " and > " (- win-height bot-limit))
    (when (<= cursor-line (+ top-limit 1))
      (set vim.o.scrolloff (+ top-limit 1))
      (vim.api.nvim_command "normal! zb")
      (set vim.o.scrolloff top-limit))
    (when (>= cursor-line (- win-height bot-limit))
      (set vim.o.scrolloff (+ top-limit 1))
      (vim.api.nvim_command "normal! zt")
      (set vim.o.scrolloff top-limit))))

(vim.api.nvim_create_autocmd "CursorMoved" {:pattern "*" :callback scrolly})
