(local padding 10)

(fn scrolly []
  (let [win-height (vim.api.nvim_win_get_height 0)
        cursor-line (vim.fn.winline)

        cap (fn [y]
              (let [line-count (vim.api.nvim_buf_line_count 0)]
                (math.min line-count (math.max y 1))))]

    (when (<= cursor-line padding)
      (let [[current_y current_x] (vim.api.nvim_win_get_cursor 0)
             how-deep-we-are-in-padding (- padding cursor-line)]

        (vim.api.nvim_win_set_cursor 0 [(cap (+ current_y padding how-deep-we-are-in-padding)) 0])
        (vim.api.nvim_command "normal! zb")
        (vim.api.nvim_win_set_cursor 0 [current_y current_x])))

    (when (>= cursor-line (- win-height padding -1))
      (let [[current_y current_x] (vim.api.nvim_win_get_cursor 0)
             how-deep-we-are-in-padding (- cursor-line (- win-height padding -1))]

        (vim.api.nvim_win_set_cursor 0 [(cap (- current_y padding how-deep-we-are-in-padding)) 0])
        (vim.api.nvim_command "normal! zt")
        (vim.api.nvim_win_set_cursor 0 [current_y current_x])))))

(vim.api.nvim_create_autocmd "CursorMoved" {:pattern "*" :callback scrolly})
