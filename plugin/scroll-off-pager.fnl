;; incase you want different paddings
(local padding-top 15)
(local padding-bottom 15)


(fn empty-strings [n]
  (var result [])
  (for [_ 1 n]
    (table.insert result ""))
  result)

; let's us know whether the triggered cursored moved event
; was caused by us moving it out of the way of the scrolling
(var just-scrolled-cursor-to nil)
(fn equal-coords [ab cd]
  (let [[y0 x0] ab
        [y1 x1] cd]
    (and
      (= y0 y1)
      (= x0 x1))))


(fn scrolly []
  (let [win-height (vim.api.nvim_win_get_height 0)
        cursor-line (vim.fn.winline)
        line-count (vim.api.nvim_buf_line_count 0)
        [distance-to-top x] (vim.api.nvim_win_get_cursor 0)]

    (when (or (not just-scrolled-cursor-to) (not (equal-coords [distance-to-top x] just-scrolled-cursor-to)))
      (set just-scrolled-cursor-to nil)

      (var padding-top padding-top)
      (var padding-bottom padding-bottom)

      (when (> (+ padding-top padding-bottom 1) win-height)
        (set padding-top (math.floor (/ win-height 2)))
        (set padding-bottom (- win-height padding-top -1)))


      (when (<= cursor-line padding-top)
        (let [n padding-bottom]

          ;; insert synthetic lines
          (vim.api.nvim_buf_set_lines 0 line-count (+ line-count n) false (empty-strings n))

          (vim.api.nvim_command (.. "normal! " n "j" "zb" n "k"))

          ;; remove synthetic lines
          (vim.api.nvim_buf_set_lines 0 line-count (+ line-count n) false [])))


      (when (>= cursor-line (- win-height padding-bottom -1))
        (let [n (math.min padding-top distance-to-top)]

          (vim.api.nvim_command (.. "normal! " n "k" "zt" n "j")))))))


(fn run-if-regular-buffer [f]
  (fn []
    (when (and (= vim.bo.buftype "") (~= vim.bo.filetype "netrw"))
      ;; probably modifiable and regular buffer
      (f))))


; potentially move the screen when the cursor moves
(vim.api.nvim_create_autocmd "CursorMoved" {:pattern "*" :callback (run-if-regular-buffer scrolly)})


; move cursor out of the way when scrolling with mouse wheel
(vim.api.nvim_create_autocmd "WinScrolled"
  {:pattern "*" :callback
   (fn []
     (let [win-height (vim.api.nvim_win_get_height 0)
           cursor-line (vim.fn.winline)
           [distance-to-top _x] (vim.api.nvim_win_get_cursor 0)
           screen-is-not-at-top? (> distance-to-top cursor-line)]

      (var padding-top padding-top)
      (var padding-bottom padding-bottom)

      (when (> (+ padding-top padding-bottom 1) win-height)
        (set padding-top (math.floor (/ win-height 2)))
        (set padding-bottom (- win-height padding-top 1)))


      (when (and (<= cursor-line padding-top) screen-is-not-at-top?)
       (let [n (- padding-top cursor-line -1)]
         (vim.api.nvim_command (.. "normal! " n "j"))
         (set just-scrolled-cursor-to (vim.api.nvim_win_get_cursor 0))))


      (when (>= cursor-line (- win-height padding-bottom -1))
           (let [n (- padding-bottom (- win-height cursor-line))]
             (vim.api.nvim_command (.. "normal! " n "k"))
             (set just-scrolled-cursor-to (vim.api.nvim_win_get_cursor 0))))))})
