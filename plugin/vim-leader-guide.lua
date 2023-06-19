vim.api.nvim_set_keymap("n", "<leader>", ":<C-U>LeaderGuide '<SPACE>'<CR>", {noremap = true, silent = true})
return vim.api.nvim_set_keymap("v", "<leader>", ":<C-U>LeaderGuideVisual '<SPACE>'<CR>", {noremap = true, silent = true})
