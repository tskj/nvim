;; incase you want different paddings
(local padding-top 15)
(local padding-bottom 15)


(fn empty-strings [n]
  (var result [])
  (for [_ 1 n]
    (table.insert result ""))
  result)


(fn scrolly []
  (let [win-height (vim.api.nvim_win_get_height 0)
        cursor-line (vim.fn.winline)
        line-count (vim.api.nvim_buf_line_count 0)
        [distance-to-top _] (vim.api.nvim_win_get_cursor 0)]


    (var padding-top padding-top)
    (var padding-bottom padding-bottom)

    (when (> (+ padding-top padding-bottom 1) win-height)
      (set padding-top (math.floor (/ win-height 2)))
      (set padding-bottom (- win-height padding-top -1)))


    (when (<= cursor-line padding-top)
      (let [n padding-bottom]

        ;; insert synthetic lines
        (vim.api.nvim_buf_set_lines 0 line-count (+ line-count n) false (empty-strings n))

        (print (.. "normal! " n "j" "zb" n "k"))
        (vim.api.nvim_command (.. "normal! " n "j" "zb" n "k"))

        ;; remove synthetic lines
        (vim.api.nvim_buf_set_lines 0 line-count (+ line-count n) false [])))


    (when (>= cursor-line (- win-height padding-bottom -1))
      (let [n (math.min padding-top distance-to-top)]

        (vim.api.nvim_command (.. "normal! " n "k" "zt" n "j"))))))


(fn run-if-regular-buffer [f]
  (fn []
    (when (and (= vim.bo.buftype "") (~= vim.bo.filetype "netrw"))
      ;; probably modifiable and regular buffer
      (f))))

(vim.api.nvim_create_autocmd "CursorMoved" {:pattern "*" :callback (run-if-regular-buffer scrolly)})
