(local {: run} (require :user.utils))

(let [{: setup} (require :nvim-treesitter.configs)]
  (setup
    {:highlight {:enable true :additional_vim_regex_highlighting false}
     :ensure_installed ["typescript" "fennel"]
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

(-> :treesitter-context (require)
  (. :setup)
  (run {:mode :topline
        :line_numbers true
        :multiline_threshold 1
        :max_lines 1
        :trim_scope :inner}))
