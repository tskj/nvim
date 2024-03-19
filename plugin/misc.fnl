(vim.api.nvim_create_autocmd "TextYankPost" {:desc "Highlighting when yanking text"
                                             :callback (fn [] (vim.highlight.on_yank {:timeout 50}))})
