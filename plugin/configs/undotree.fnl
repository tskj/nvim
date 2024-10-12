(local {: run} (require :user.utils))

(-> :undotree (require) (. :setup) (run))
