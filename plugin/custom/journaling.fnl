(fn todays-journal-filename []
  (let [today (os.date "%Y-%m-%d")
        year (os.date "%Y")
        journal-dir (.. "~/notes/.private/journal/" year)]
    ;; Ensure the year directory exists
    (vim.fn.system (.. "mkdir -p " journal-dir))
    (.. journal-dir "/" today ".norg")))

(fn open-todays-journal []
  (vim.cmd (.. ":edit " (todays-journal-filename))))
