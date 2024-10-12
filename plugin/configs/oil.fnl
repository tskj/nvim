(local {: run} (require :user.utils))

(-> :oil (require) (. :setup)
    (run {:win_options {; :winbar "%{v:lua.require('oil').get_current_dir()}"
                        :wrap true}
          :delete_to_trash true
          :keymaps {"<C-h>" false
                    "<C-l>" false
                    "<C-v>" "actions.select_split"
                    "<Esc>" (fn [] (-> :oil (require) (. :close) (run)))}}))

