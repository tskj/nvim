(local {: run} (require :user.utils))

(-> :oil (require) (. :setup)
    (run {:win_options {; :winbar "%{v:lua.require('oil').get_current_dir()}"
                        :wrap true}
          :delete_to_trash true
          :skip_confirm_for_simple_edits true
          :keymaps {"<C-h>" false
                    "<C-l>" false
                    "<C-r>" "actions.refresh"
                    "<C-s>" (fn []
                              (-> :oil (require) (. :save) (run))
                              (-> :oil.actions (require) (. :cd) (. :callback) (run)))
                    "-" (fn []
                          (-> :oil.actions (require) (. :parent) (. :callback) (run))
                          (-> :oil.actions (require) (. :cd) (. :callback) (run)))
                    "<CR>" (fn []
                             (-> :oil.actions (require) (. :select) (. :callback)
                                 (run {:callback (fn []
                                                    (-> :oil.actions
                                                        (require)
                                                        (. :cd)
                                                        (. :callback)
                                                        (run)))})))
                    "<C-v>" "actions.select_split"
                    "<Esc>" (fn [] (-> :oil (require) (. :close) (run)))}}))

