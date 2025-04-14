(local {: run} (require :user.utils))

(-> :minuet
    (require)
    (. :setup)
    (run {:provider_options {:codestral {:optional {:max_tokens 256 :stop ["\n\n"]}}}}))
