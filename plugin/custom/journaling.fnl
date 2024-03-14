(fn todays-journal-filename []
  (let [today (os.date "%Y-%m-%d")]
    (.. "~/notes/journal/" today ".org")))

(fn open-todays-journal []
  (vim.cmd (.. ":edit " (todays-journal-filename))))

(vim.keymap.set :n "<leader>cj" open-todays-journal)
