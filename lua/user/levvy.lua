-- ffi binding for levvy, the custom fuzzy-match scorer written in zig
-- (~/code/tarshtein-distance) -- see `levvy_score` and `levvy_positions`
-- in src/levvy.zig
--
-- build and install the library with tarshtein-distance/install.sh
-- (or install.cmd on windows); when it's absent M.available is false
-- and callers should fall back to their default scorer
--
-- set LEVVY_DISABLE=1 in the environment to force the fallback (handy for
-- A/B-comparing against the stock fzf sorter)

local M = { available = false }

if vim.env.LEVVY_DISABLE == "1" then
  return M
end

local ok, ffi = pcall(require, "ffi")
if not ok then
  return M
end

ffi.cdef([[
int levvy_score(const char* query, const char* line, unsigned int pad_to);
int levvy_positions(const char* query, const char* line, uint16_t* out, unsigned int out_cap);
]])

local is_windows = vim.fn.has("win32") == 1
local candidates = is_windows
    and {
      vim.fn.stdpath("config") .. "\\zig\\levvy.dll",
    }
  or {
    vim.fn.stdpath("config") .. "/zig/liblevvy.so",
    vim.fn.expand("~/code/tarshtein-distance/zig-out/lib/liblevvy.so"),
  }

local lib
for _, path in ipairs(candidates) do
  if vim.fn.filereadable(path) == 1 then
    local loaded, result = pcall(ffi.load, path)
    if loaded then
      lib = result
      break
    end
  end
end

if not lib then
  return M
end

M.available = true

-- lines are scored as if padded to this many columns, which makes scores
-- length-normalized and comparable without knowing the longest candidate
local PAD_TO = 1024

-- returns the levvy distance (lower is better), or -1 when the query is
-- not a smart-case subsequence of the line (i.e. "no match")
function M.score(prompt, line)
  return lib.levvy_score(prompt, line, PAD_TO)
end

-- returns the byte positions (1-based, for highlighting) that an optimal
-- levvy match path actually matched, or nil when the query doesn't match
function M.positions(prompt, line)
  local cap = #prompt
  if cap == 0 then
    return {}
  end
  local out = ffi.new("uint16_t[?]", cap)
  local n = lib.levvy_positions(prompt, line, out, cap)
  if n < 0 then
    return nil
  end
  local positions = {}
  for i = 0, n - 1 do
    positions[i + 1] = out[i] + 1
  end
  return positions
end

return M
