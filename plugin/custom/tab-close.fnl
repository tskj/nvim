;;; if you close a tab, the tab to the right moves into
;;; the spot of your old tab, so that tab (to the right)
;;; gets focus -- really you want the one to the left

(vim.api.nvim_create_autocmd
  "TabClosed"
  {:callback (fn []
               (vim.defer_fn
                 (fn []
                   (let [current-tab (vim.fn.tabpagenr)]
                     (when (> current-tab 1)
                       (vim.cmd "tabprevious"))))
                 10))})
