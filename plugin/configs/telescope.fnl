(local {: run} (require :user.utils))
(local actions (require :telescope.actions))

(local telescope (require :telescope))
(telescope.setup
  {:extensions {:ui-select [(-> :telescope.themes (require) (. :get_dropdown) (run))]
                :undo {}}
   :defaults {:layout_strategy "flex"
              :layout_config {:flip_columns 120
                              :horizontal {:width 0.9 :preview_width 0.6 :prompt_position "top"}
                              :vertical {:prompt_position "top" :mirror true}}
              :sorting_strategy "ascending"
              :scroll_strategy "limit"

              :mappings {:i {:<C-x> actions.delete_buffer}
                         :n {:<C-x> actions.delete_buffer}}}})

(pcall (. (require :telescope) :load_extension) "fzf")
(pcall (. (require :telescope) :load_extension) "ui-selet")

(telescope.load_extension "ui-select")
(telescope.load_extension "undo")
(telescope.load_extension "refactoring")
