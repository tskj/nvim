(let [{: setup} (require :nvim-treesitter.configs)]
  (setup
    {:highlight {:enable true :additional_vim_regex_highlighting false}
     :ensure_installed ["fennel"]
     :indent {:enable true}
     :textobjects
       {:move
         {:enable true
          :goto_next_start {"]]" "@block.outer"}
          :goto_next_end {"][" "@block.outer"}
          :goto_previous_start {"[[" "@block.outer"}
          :goto_previous_end {"[]" "@block.outer"}}
        :select
         {:enable true
          :keymaps
            {:ab "@block.outer"
             :ib "@block.inner"}
          :lookahead true}}}))

((-> :treesitter-context (require) (. :setup))
 {:enable true
  :max_lines 0
  :min_window_height 0
  :line_numbers false
  :multiline_threshold 200
  :trim_scope :outer
  :mode :cursor
  :separator nil
  :zindex 200
  :on_attach nil})
