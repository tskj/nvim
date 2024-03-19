(local telescope (require :telescope))
(telescope.setup
  {:extensions {:ui-select [((. (require :telescope.themes) :get_dropdown))]}})

(pcall (. (require :telescope) :load_extension) "fzf")
(pcall (. (require :telescope) :load_extension) "ui-select")
