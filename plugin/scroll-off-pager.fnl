(local top-limit 14)
(local bot-limit top-limit)

(set vim.o.scrolloff (- top-limit 1))

(fn scrolly []
  (let [win-height (vim.api.nvim_win_get_height 0)
        cursor-line (vim.fn.winline)]
    (when (<= cursor-line top-limit)
      (vim.api.nvim_command "normal! zb"))
    (when (> cursor-line (- win-height bot-limit))
      (vim.api.nvim_command "normal! zt"))))

(vim.api.nvim_create_autocmd "CursorMoved" {:pattern "*" :callback scrolly})
