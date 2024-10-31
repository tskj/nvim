local ffi = require("ffi")
ffi.cdef("int fuzzy_search(const char* query, int number_of_lines, const char** input, uint16_t* output);")
local levvy = ffi.load((vim.fn.stdpath("config") .. "\\zig\\levvy"))
local function _1_()
  local query = vim.fn.input("Search: ")
  local start_time = vim.loop.hrtime()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local n_lines = #lines
  local c_lines = ffi.new("const char*[?]", n_lines)
  for i = 1, n_lines do
    c_lines[(i - 1)] = lines[i]
  end
  local output = ffi.new("uint16_t[?]", n_lines)
  local success = (0 == levvy.fuzzy_search(query, n_lines, c_lines, output))
  local matches = {}
  for i = 0, (n_lines - 1) do
    table.insert(matches, tonumber(output[i]))
  end
  local end_time = vim.loop.hrtime()
  return print("\nresult took:", ((end_time - start_time) / 1000000), "ms", " and query length is ", matches[1], " and longest line is ", matches[2], " and number of lines is ", matches[3], " and fourth?? match is ", matches[4], " out of the ", #matches, " matches", " with success? ", success)
end
return _1_
