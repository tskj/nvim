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
                              (-> :oil (require) (. :save) (run))
                              (-> :oil.actions (require) (. :cd :callback) (run {:silent {:type true}})))
                    "-" (fn []
                          (-> :oil.actions (require) (. :parent :callback) (run))
                          (-> :oil.actions (require) (. :cd :callback) (run {:silent {:type true}})))
                    "<CR>" (fn []
                             (-> :oil.actions (require) (. :select :callback)
                                 (run {:callback (fn []
                                                    (when (-> :oil (require) (. :get_current_dir) (run)) ;; in directory, not file:
                                                      (-> :oil.actions
                                                          (require)
                                                          (. :cd :callback)
                                                          (run {:silent {:type true}}))))})))
                    "<C-v>" "actions.select_split"
                    "<Esc>" (fn [] (-> :oil (require) (. :close) (run)))}}))

