(local ffi (-> :ffi (require)))

(ffi.cdef "int fuzzy_search(const char* query, int number_of_lines, const char** input, uint16_t* output);")
(local levvy (ffi.load (.. (vim.fn.stdpath "config")
                           "\\zig\\levvy")))

(fn []
  (local query (vim.fn.input "Search: "))
  (local start-time (vim.loop.hrtime))

  (local lines (vim.api.nvim_buf_get_lines 0 0 -1 false))
  (local n-lines (# lines))

  (local c-lines (ffi.new "const char*[?]" n-lines))
  (for [i 1 n-lines]
    (tset c-lines (- i 1) (. lines i)))

  (local output (ffi.new "uint16_t[?]" n-lines))
  (local success (= 0 (levvy.fuzzy_search query n-lines c-lines output)))

  (local matches [])
  (for [i 0 (-> n-lines (- 1))]
    (table.insert matches (tonumber (. output i))))

  (local end-time (vim.loop.hrtime))
  (print "\nresult took:" (/ (- end-time start-time) 1e6)
         "ms"
         " and query length is " (. matches 1)
         " and longest line is " (. matches 2)
         " and number of lines is " (. matches 3)
         " and fourth?? match is " (. matches 4)
         " out of the " (# matches) " matches"
         " with success? " success))
