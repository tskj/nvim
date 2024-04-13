;;; parinfer doesn't auto-indent properly when you open a new line
;;; below all the final closing parens of an expression (kind of
;;; by design), but kind of not, so this plugin aims to fix that
;;; by reading the indent of the line above and automatically
;;; scooching over if needed

(vim.api.nvim_create_autocmd
  "InsertEnter"
  {:pattern "*"
   :callback
   (fn []
     (let [[line-number] (vim.api.nvim_win_get_cursor 0)]

       (when (= line-number 1) (lua :return))

       (fn blank? [line]
         (~= nil (line:match "^%s*$")))

       (fn get-#indent [line]
         (let [(_ end-index) (line:find "^%s*")]
           end-index))

       (fn zi [x] (- x 1)) ;; some things are zero indexed

       (let [previous-line-number (- line-number 1)

             current-line         (vim.api.nvim_get_current_line)
             [previous-line]      (vim.api.nvim_buf_get_lines
                                    0 (zi previous-line-number) (zi line-number) true)

             prev-#indent (get-#indent previous-line)
             curr-#indent (get-#indent current-line)]

         (when (and (blank? current-line)
                    (not (blank? previous-line))

                    (> prev-#indent curr-#indent))

           ;; add appropriate indentation
           (vim.api.nvim_set_current_line (string.rep " " (+ 1 prev-#indent)))

           ;; move cursor to end of line afterwards
           (vim.schedule (fn [] (vim.cmd "normal! $")))))))})
