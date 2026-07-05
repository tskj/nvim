-- records telescope searches ranked by levvy, for later threshold tuning.
--
-- design: since levvy is deterministic, we don't store scores -- we store
-- the raw inputs and recompute offline. two artifacts under M.dir:
--
--   corpora/<sha256>.txt  -- each unique candidate set, one ordinal per
--                            line, written once (content-addressed; the same
--                            project's file list dedupes across searches)
--   searches.jsonl        -- one tiny record per completed search: the
--                            corpus hash, the sequence of prompts typed, and
--                            the selected ordinal (if any)
--
-- to analyze later, load a search's corpus by hash and replay levvy over it
-- for each prompt in the trace -- that reconstructs every score, ranking and
-- the selected item's rank, from which a cutoff can be tuned.
--
-- enabled by default when levvy is active; set `vim.g.levvy_no_log = true`
-- (or env LEVVY_NO_LOG=1) to turn it off. inspect with :LevvyLog.

local M = {}

M.dir = vim.fn.stdpath("data") .. "/levvy-log"
M.searches = M.dir .. "/searches.jsonl"
M.corpora = M.dir .. "/corpora"

local function enabled()
  if vim.env.LEVVY_NO_LOG == "1" then
    return false
  end
  return not vim.g.levvy_no_log
end

-- writes the corpus once, keyed by content hash; returns the hash
local function store_corpus(ordinals)
  table.sort(ordinals) -- deterministic order -> stable hash regardless of scan order
  local hash = vim.fn.sha256(table.concat(ordinals, "\n"))
  local path = M.corpora .. "/" .. hash .. ".txt"
  if vim.fn.filereadable(path) == 0 then
    vim.fn.mkdir(M.corpora, "p")
    pcall(vim.fn.writefile, ordinals, path)
  end
  return hash
end

local function append_search(record)
  local ok, line = pcall(vim.json.encode, record)
  if not ok then
    return
  end
  vim.fn.mkdir(M.dir, "p")
  pcall(vim.fn.writefile, { line }, M.searches, "a")
end

-- builds and appends a record from the picker's captured state.
-- `selected_entry` may be nil (abandoned search). self-guards against
-- double logging (select then close).
local function capture(prompt_bufnr, selected_entry)
  if not enabled() then
    return
  end

  local ok, picker = pcall(function()
    return require("telescope.actions.state").get_current_picker(prompt_bufnr)
  end)
  if not ok or not picker or picker._levvy_logged then
    return
  end
  local sorter = picker.sorter
  if not (sorter and sorter._levvy and sorter._levvy_corpus) then
    return
  end
  picker._levvy_logged = true

  -- the corpus set the sorter accumulated
  local ordinals = {}
  for ordinal in pairs(sorter._levvy_corpus) do
    ordinals[#ordinals + 1] = ordinal
  end
  if #ordinals == 0 then
    return -- nothing was ever scored (picker opened and closed instantly)
  end
  local corpus_hash = store_corpus(ordinals)

  append_search({
    v = 1,
    ts = os.time(),
    source = picker.prompt_title,
    corpus_hash = corpus_hash,
    corpus_n = sorter._levvy_corpus_n,
    corpus_truncated = sorter._levvy_corpus_truncated or nil,
    prompts = sorter._levvy_trace, -- keystroke trace: prompts as typed
    final_prompt = require("telescope.actions.state").get_current_line(),
    selected = selected_entry and selected_entry.ordinal or nil,
  })
end

function M.on_select(prompt_bufnr)
  local ok, entry = pcall(function()
    return require("telescope.actions.state").get_selected_entry()
  end)
  capture(prompt_bufnr, ok and entry or nil)
end

function M.on_close(prompt_bufnr)
  capture(prompt_bufnr, nil)
end

-- appends the current prompt to the picker's trace on every edit, so the
-- record reflects everything typed -- including backspaces and rewrites,
-- not just the prompts that happened to trigger a scoring pass. consecutive
-- duplicates are collapsed.
function M.on_prompt_change(prompt_bufnr)
  if not enabled() then
    return
  end
  local state = require("telescope.actions.state")
  local ok, picker = pcall(state.get_current_picker, prompt_bufnr)
  if not ok or not picker then
    return
  end
  local sorter = picker.sorter
  if not (sorter and sorter._levvy and sorter._levvy_trace) then
    return
  end
  local prompt = state.get_current_line()
  local trace = sorter._levvy_trace
  if trace[#trace] ~= prompt then
    trace[#trace + 1] = prompt
  end
end

-- wires the select-time and close-time hooks; call once from telescope setup
function M.attach()
  local actions = require("telescope.actions")
  actions.select_default:enhance({
    pre = function(prompt_bufnr)
      pcall(M.on_select, prompt_bufnr)
    end,
  })

  local group = vim.api.nvim_create_augroup("LevvySearchLog", {})

  -- capture the full prompt evolution (typing, backspacing, rewriting)
  vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
    group = group,
    callback = function(args)
      if vim.bo[args.buf].filetype == "TelescopePrompt" then
        pcall(M.on_prompt_change, args.buf)
      end
    end,
  })

  -- telescope tears a picker down on BufLeave of its prompt buffer; a global
  -- BufLeave defined here (before any picker's own once-handler) runs first,
  -- while the picker is still alive, catching abandoned searches. the
  -- _levvy_logged guard keeps a select-then-close from logging twice.
  vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    callback = function(args)
      if vim.bo[args.buf].filetype == "TelescopePrompt" then
        pcall(M.on_close, args.buf)
      end
    end,
  })

  vim.api.nvim_create_user_command("LevvyLog", function()
    M.summary()
  end, { desc = "Show the levvy search log location and a quick summary" })
end

-- quick at-a-glance summary (full analysis happens later, offline)
function M.summary()
  local lines = {}
  pcall(function()
    lines = vim.fn.readfile(M.searches)
  end)
  local with_sel = 0
  local corpora = {}
  for _, line in ipairs(lines) do
    local ok, rec = pcall(vim.json.decode, line)
    if ok and rec then
      if rec.selected then
        with_sel = with_sel + 1
      end
      if rec.corpus_hash then
        corpora[rec.corpus_hash] = true
      end
    end
  end
  local n_corpora = 0
  for _ in pairs(corpora) do
    n_corpora = n_corpora + 1
  end
  print("levvy search log: " .. M.dir)
  print(string.format("  %d searches recorded, %d ended in a selection", #lines, with_sel))
  print(string.format("  %d unique corpora stored (replay to recompute scores)", n_corpora))
end

return M
