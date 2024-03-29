
(fn run [f & xs] (f (unpack xs)))


(fn debug-log [& msgs]
   (local file-name (.. (vim.fn.stdpath "data") "/debug.log"))
   (local file (io.open file-name :a))
   (local messages (table.concat (icollect [_ m (ipairs msgs)] (tostring m)) " "))
   (local log-line (.. (os.date "[%Y-%m-%dT%H:%M:%S] ")
                       messages "\n"))

   (file:write log-line)
   (file:flush)
   (file:close))


{: run
 : debug-log}
