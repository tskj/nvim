(local {: run} (require :user.utils))

(-> :nvim-web-devicons (require) (. :setup)
    (run {:override_by_extension
          {"norg" {:icon ""
                   :color "#77AA99"
                   :name "Neorg"}}}))
