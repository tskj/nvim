(local env :prod)

(fn log [& msgs]
  (if (= env :debug)
    `(let [utils# (require :user.utils)
           debug-log# utils#.debug-log]
       (debug-log# ,(unpack msgs)))))

(fn map [f xs]
  `(icollect [_# x# (ipairs ,xs)] (,f x#)))

{: log : map}
