;; incase you want different paddings
(local padding-top 10)
(local padding-bottom 10)
(local padding-left 20)
(local padding-right 20)

; let's us know whether the triggered cursored moved event
; was caused by us moving it out of the way of the scrolling
(var just-scrolled-cursor-to nil)
(var skip-horizontal-scroll false)

(fn equal-coords [ab cd]
  (let [[y0 x0] ab
        [y1 x1] cd]
    (and
      (= y0 y1)
      (= x0 x1))))

;; Function to ensure cursor is within legal area (not in padding)
(fn ensure-cursor-in-legal-area []
  (let [win-width (vim.api.nvim_win_get_width 0)
        cursor-col (vim.fn.wincol)]
    ;; If cursor is in left padding area
    (when (< cursor-col padding-left)
      (let [required-move (- padding-left cursor-col)]
        (when (> required-move 0)
          (vim.api.nvim_command (.. "normal! " required-move "l")))))

    ;; If cursor is in right padding area
    (when (> cursor-col (- win-width padding-right))
      (let [required-move (- cursor-col (- win-width padding-right))]
        (when (> required-move 0)
          (vim.api.nvim_command (.. "normal! " required-move "h")))))))

;; Shift-L: Move screen right (half screen width)
(vim.keymap.set "n" "<S-L>"
  (fn []
    (set skip-horizontal-scroll true)
    (let [win-width (vim.api.nvim_win_get_width 0)
          half-width (math.floor (/ win-width 2))]
      ;; Move screen right
      (vim.api.nvim_command (.. "exe \"normal! " half-width "zl\""))
      ;; Ensure cursor is in legal area
      (ensure-cursor-in-legal-area))
    ;; Reset after a brief delay
    (vim.defer_fn (fn [] (set skip-horizontal-scroll false)) 100)))

;; Shift-H: Move screen left (half screen width)
(vim.keymap.set "n" "<S-H>"
  (fn []
    (set skip-horizontal-scroll true)
    (let [win-width (vim.api.nvim_win_get_width 0)
          half-width (math.floor (/ win-width 2))]
      ;; Move screen left
      (vim.api.nvim_command (.. "exe \"normal! " half-width "zh\""))
      ;; Ensure cursor is in legal area
      (ensure-cursor-in-legal-area))
    ;; Reset after a brief delay
    (vim.defer_fn (fn [] (set skip-horizontal-scroll false)) 100)))

(fn scrolly []
  (let [win-height (vim.api.nvim_win_get_height 0)
        win-width (vim.api.nvim_win_get_width 0)
        cursor-line (vim.fn.winline)
        cursor-col (vim.fn.wincol)
        [distance-to-top x] (vim.api.nvim_win_get_cursor 0)
        screen-is-at-top? (= distance-to-top cursor-line)]
    (when (or (not just-scrolled-cursor-to)
              (not (equal-coords [distance-to-top x] just-scrolled-cursor-to)))
      (set just-scrolled-cursor-to nil)

      ;; Vertical scrolling
      (var padding-top padding-top)
      (var padding-bottom padding-bottom)
      (when (> (+ padding-top padding-bottom 1) win-height)
        (set padding-top (math.floor (/ win-height 2)))
        (set padding-bottom (- win-height padding-top 1)))
      (when (and screen-is-at-top? (<= cursor-line padding-top))
          (set padding-top 0))
      (when (<= cursor-line padding-top)
        (let [distance-to-padding-border (- padding-top cursor-line)
              one-window-height (- win-height padding-top padding-bottom)
              n (+ distance-to-padding-border one-window-height)]
          (when (> n 0) (vim.api.nvim_command (.. "exe \"normal! " n "\\<C-y>\"")))))
      (when (> cursor-line (- win-height padding-bottom))
        (let [distance-to-padding-border (- cursor-line (- win-height padding-bottom) 1)
              one-window-height (- win-height padding-top padding-bottom)
              n (+ distance-to-padding-border one-window-height)]
          (when (> n 0) (vim.api.nvim_command (.. "exe \"normal! " n "\\<C-e>\"")))))

      ;; Horizontal scrolling - skip if flag is set
      (when (and (< cursor-col padding-left)
                 (not skip-horizontal-scroll))
        (let [distance-to-padding-border (- padding-left cursor-col)
              one-window-width (- win-width padding-left padding-right)
              n (+ distance-to-padding-border one-window-width)]
          (when (> n 0) (vim.api.nvim_command (.. "exe \"normal! " n "zh\"")))))

      (when (and (> cursor-col (- win-width padding-right))
                 (not skip-horizontal-scroll))
        (let [distance-to-padding-border (- cursor-col (- win-width padding-right) 1)
              one-window-width (- win-width padding-left padding-right)
              n (+ distance-to-padding-border one-window-width 1)]
          (when (> n 0) (vim.api.nvim_command (.. "exe \"normal! " n "zl\""))))))))

; potentially move the screen when the cursor moves
(vim.api.nvim_create_autocmd "CursorMoved" {:pattern "*" :callback scrolly})

; move cursor out of the way when scrolling with mouse wheel
(vim.api.nvim_create_autocmd "WinScrolled"
  {:pattern "*" :callback
     (fn []
       (when (~= (vim.fn.mode) "n")
         (lua :return))
       (let [win-height (vim.api.nvim_win_get_height 0)
             cursor-line (vim.fn.winline)
             [distance-to-top _x] (vim.api.nvim_win_get_cursor 0)
             screen-is-not-at-top? (> distance-to-top cursor-line)]

         ;; Vertical handling
         (var padding-top padding-top)
         (var padding-bottom padding-bottom)
         (when (> (+ padding-top padding-bottom 1) win-height)
           (set padding-top (math.floor (/ win-height 2)))
           (set padding-bottom (- win-height padding-top 1)))
         (when (and (<= cursor-line padding-top) screen-is-not-at-top?)
           (let [n (- padding-top cursor-line -1)]
             ;; n is guaranteed to be positive here
             (vim.api.nvim_command (.. "normal! " n "j"))
             (set just-scrolled-cursor-to (vim.api.nvim_win_get_cursor 0))))
         (when (>= cursor-line (- win-height padding-bottom -1))
           (let [n (- padding-bottom (- win-height cursor-line))]
             (when (> n 0)
               (vim.api.nvim_command (.. "normal! " n "k"))
               (set just-scrolled-cursor-to (vim.api.nvim_win_get_cursor 0)))))))})
