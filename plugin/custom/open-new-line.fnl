;;; the purpose of this file is to override the "o" key in normal mode when
;;; it's on a blank line immediately preceding a non-blank line, in which
;;; case we want to insert an extra blank line below to space out the code
;;; a bit -- if you _want_ to open a new line above an existing line, go one
;;; down and use shift+O instead

(vim.keymap.set
  :n "o"
  (fn []

    (fn blank? [line]
      (if (= nil line)
        true
        (~= nil (line:match "^%s*$"))))

    (let [[line-number] (vim.api.nvim_win_get_cursor 0)
          next-line-number (+ line-number 1)
          current-line  (vim.api.nvim_get_current_line)
          [next-line]   (vim.api.nvim_buf_get_lines
                          0 line-number next-line-number false)]

      (when (and (blank? current-line)
                 (not (blank? next-line)))
        (vim.cmd "execute \"normal \\<Enter>\"")) ;; open extra line

      ;; regular behavior
      (vim.api.nvim_feedkeys "o" :n true))))
