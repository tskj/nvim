(import-macros {: map} :fnl.macros)

(fn run [f & xs] (f (unpack xs)))

(fn debug-log [& msgs]
   (local file-name (.. (vim.fn.stdpath "data") "/debug.log"))
   (local file (io.open file-name :a))
   (local messages (table.concat (map tostring msgs) " "))
   (local log-line (.. (os.date "[%Y-%m-%dT%H:%M:%S] ")
                       messages "\n"))

   (file:write log-line)
   (file:flush)
   (file:close))

(fn volatile-quickfix [timeout-ms]
  "Opens quickfix with focus and closes after timeout"
  (vim.cmd "copen")
  (vim.fn.timer_start (or timeout-ms 2000)
                      (fn []
                        (when (and (vim.fn.getqflist {:winid 1})
                                   (not= (. (vim.fn.getqflist {:winid 1}) :winid) 0))
                          (vim.cmd "cclose")))))

(fn gitsigns-quickfix-volatile []
  "Run gitsigns setqflist and open as volatile quickfix"
  (vim.cmd "Gitsigns setqflist all")
  (volatile-quickfix))


{: run
 : debug-log
 : volatile-quickfix
 : gitsigns-quickfix-volatile}
