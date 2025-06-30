(local {: run} (require :user.utils))

(-> :oil (require) (. :setup)
    (run {:win_options {; :winbar "%{v:lua.require('oil').get_current_dir()}"
                        :wrap true}
          :delete_to_trash true
          :skip_confirm_for_simple_edits true
          :keymaps {"<C-h>" false
                    "<C-l>" false
                    "<C-r>" "actions.refresh"
                    "<C-c>" (fn [] (-> :oil (require) (. :discard_all_changes) (run)))
                    "<C-s>" (fn []
                              (-> :oil (require) (. :save) (run)))
                    "-" (fn []
                          (-> :oil.actions (require) (. :parent :callback) (run)))
                    "<CR>" "actions.select"
                    "<C-v>" "actions.select_split"
                    "<Esc>" (fn [] (-> :oil (require) (. :close) (run)))}}))

