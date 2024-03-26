(local telescope (require :telescope))
(telescope.setup
  {:extensions {:ui-select [((. (require :telescope.themes) :get_dropdown))]}
   :defaults {:layout_strategy "flex"
              :layout_config {:flip_columns 120
                              :horizontal {:width 0.9 :preview_width 0.6 :prompt_position "top"}
                              :vertical {:prompt_position "top" :mirror true}}
              :sorting_strategy "ascending"
              :scroll_strategy "limit"}})

(pcall (. (require :telescope) :load_extension) "fzf")
(pcall (. (require :telescope) :load_extension) "ui-selet")

(telescope.load_extension "ui-select")
