-- ffi binding for levvy, the custom fuzzy-match scorer written in zig
-- (~/code/tarshtein-distance) -- see `levvy_score` and `levvy_positions`
-- in src/levvy.zig
--
-- the library is built natively per-machine by lazy.nvim (see the plugin
-- spec in init.lua) or by tarshtein-distance/install.sh; when it's absent
-- M.available is false and callers should fall back to their default
-- scorer. M.state / M.reason explain why (surfaced by :LevvyStatus and a
-- startup notification -- see plugin/configs/telescope.lua).
--
-- set LEVVY_DISABLE=1 in the environment to force the fallback (handy for
-- A/B-comparing against the stock fzf sorter; silences the warning).

local M = {
  available = false,
  state = "unknown", -- active | disabled | not_built | no_zig | load_error | no_ffi
  reason = nil,
  loaded_from = nil,
}

if vim.env.LEVVY_DISABLE == "1" then
  M.state = "disabled"
  M.reason = "disabled via LEVVY_DISABLE=1"
  return M
end

local ok, ffi = pcall(require, "ffi")
if not ok then
  M.state = "no_ffi"
  M.reason = "luajit ffi is unavailable"
  return M
end

ffi.cdef([[
int levvy_score(const char* query, const char* line, unsigned int pad_to);
int levvy_positions(const char* query, const char* line, uint16_t* out, unsigned int out_cap);
]])

-- dynamic library name is platform-specific: .dll on windows, .dylib on
-- macos, .so on linux/other. searched in priority order:
--   1. <config>/zig/       -- explicit install (install.sh / install.cmd)
--   2. ~/code/...           -- a local dev checkout
--   3. <data>/lazy/...      -- built by lazy.nvim on :Lazy sync (the default
--                              on a fresh machine; see the plugin spec in
--                              init.lua with `build = zig build ...`)
local is_windows = vim.fn.has("win32") == 1
local is_mac = vim.fn.has("mac") == 1
local data = vim.fn.stdpath("data")
local candidates
if is_windows then
  candidates = {
    vim.fn.stdpath("config") .. "\\zig\\levvy.dll",
    data .. "\\lazy\\tarshtein-distance\\zig-out\\bin\\levvy.dll",
    data .. "\\lazy\\tarshtein-distance\\zig-out\\lib\\levvy.dll",
  }
else
  local libname = is_mac and "liblevvy.dylib" or "liblevvy.so"
  candidates = {
    vim.fn.stdpath("config") .. "/zig/" .. libname,
    vim.fn.expand("~/code/tarshtein-distance/zig-out/lib/" .. libname),
    data .. "/lazy/tarshtein-distance/zig-out/lib/" .. libname,
  }
end
M.candidates = candidates

local lib
local load_error = nil
for _, path in ipairs(candidates) do
  if vim.fn.filereadable(path) == 1 then
    local loaded, result = pcall(ffi.load, path)
    if loaded then
      lib = result
      M.loaded_from = path
      break
    else
      -- a library file exists but wouldn't load (wrong arch, corrupt, ...)
      load_error = tostring(result)
    end
  end
end

if not lib then
  if load_error then
    M.state = "load_error"
    M.reason = "found a library file but it failed to load: " .. load_error
  elseif vim.fn.executable("zig") == 1 then
    M.state = "not_built"
    M.reason = "library not built yet -- run :Lazy build tarshtein-distance (then restart)"
  else
    M.state = "no_zig"
    M.reason = "library not built and `zig` is not on PATH -- install zig, then :Lazy build tarshtein-distance"
  end
  return M
end

M.available = true
M.state = "active"
M.reason = "loaded from " .. M.loaded_from

-- lines are scored as if padded to this many columns, which makes scores
-- length-normalized and comparable without knowing the longest candidate
local PAD_TO = 1024

-- returns the levvy distance (lower is better); a poor match just gets a
-- large distance (there is no reject)
function M.score(prompt, line)
  return lib.levvy_score(prompt, line, PAD_TO)
end

-- returns the byte positions (1-based, for highlighting) that an optimal
-- levvy match path actually matched
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
