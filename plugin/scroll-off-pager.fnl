;; incase you want different paddings
(local _padding-top 15)
(local _padding-bottom 15)


(fn empty-strings [n]
  (var result [])
  (for [_ 1 n]
    (table.insert result ""))
  result)


(var just-scrolled-cursor-to nil)


(fn scrolly []
  (let [win-height (vim.api.nvim_win_get_height 0)
        cursor-line (vim.fn.winline)
        line-count (vim.api.nvim_buf_line_count 0)
        [distance-to-top x] (vim.api.nvim_win_get_cursor 0)]

    (print "executing cursor moved event..., curcurs state is" just-scrolled-cursor-to " and actual cursor is" [distance-to-top x])

    (when (or (not just-scrolled-cursor-to) (not (and (= distance-to-top (. just-scrolled-cursor-to 1)) (= x (. just-scrolled-cursor-to 2)))))
      (set just-scrolled-cursor-to nil)

      (var padding-top _padding-top)
      (var padding-bottom _padding-bottom)

      (when (> (+ padding-top padding-bottom 1) win-height)
        (set padding-top (math.floor (/ win-height 2)))
        (set padding-bottom (- win-height padding-top -1)))


      (when (<= cursor-line padding-top)
        (let [n padding-bottom]
          (print "aight, we're at the top")

          ;; insert synthetic lines
          (vim.api.nvim_buf_set_lines 0 line-count (+ line-count n) false (empty-strings n))

          (print (.. "normal! " n "j" "zb" n "k"))
          (vim.api.nvim_command (.. "normal! " n "j" "zb" n "k"))

          ;; remove synthetic lines
          (vim.api.nvim_buf_set_lines 0 line-count (+ line-count n) false [])))


      (when (>= cursor-line (- win-height padding-bottom -1))
        (let [n (math.min padding-top distance-to-top)]
          (print "aight, we're at the bottom")

          (vim.api.nvim_command (.. "normal! " n "k" "zt" n "j")))))))


(fn run-if-regular-buffer [f]
  (fn []
    (when (and (= vim.bo.buftype "") (~= vim.bo.filetype "netrw"))
      ;; probably modifiable and regular buffer
      (f))))

(vim.api.nvim_create_autocmd "CursorMoved" {:pattern "*" :callback (run-if-regular-buffer scrolly)})


(vim.api.nvim_create_autocmd "WinScrolled"
  {:pattern "*" :callback
   (fn []
     (let [win-height (vim.api.nvim_win_get_height 0)
           cursor-line (vim.fn.winline)
           [distance-to-top _x] (vim.api.nvim_win_get_cursor 0)]
       (print "executing scroll event...")


       (when (<= cursor-line _padding-top)
         (let [n (- _padding-top cursor-line -1)]
           (print "nedover" n "")
           (vim.api.nvim_command (.. "normal! " n "j"))
           ; (vim.api.nvim_win_set_cursor 0 [(+ distance-to-top n 3) x])))
           (set just-scrolled-cursor-to (vim.api.nvim_win_get_cursor 0))
           (print "cursor has been scrolled to" just-scrolled-cursor-to)))


       (when (>= cursor-line (- win-height _padding-top -1))
         (let [n (- _padding-bottom (- win-height cursor-line))]
           (print "oppover" n)
           (vim.api.nvim_command (.. "normal! " n "k"))
           (set just-scrolled-cursor-to (vim.api.nvim_win_get_cursor 0))
           (print "cursor has been scrolled to" just-scrolled-cursor-to)))))})
