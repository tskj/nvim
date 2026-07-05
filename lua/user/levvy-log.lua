-- records telescope searches ranked by levvy, for later threshold tuning.
--
-- one JSONL record per completed search (selection or abandonment) is
-- appended to `M.path`. each record captures the final prompt, the ranked
-- candidate list with their levvy scores, and (when one was chosen) the
-- selected entry with its score and rank. over a few weeks this is the data
-- we can replay to pick a sensible score cutoff: the highest score of any
-- *selected* item bounds how aggressively we could filter without hiding
-- things you actually wanted.
--
-- enabled by default when levvy is active; set `vim.g.levvy_no_log = true`
-- (or env LEVVY_NO_LOG=1) to turn it off. inspect with :LevvyLog.

local M = {}

M.path = vim.fn.stdpath("data") .. "/levvy-search-log.jsonl"

-- cap the ranked list written per record; the manager only retains the
-- displayable top slice anyway, this is just a hard safety bound
local MAX_RESULTS = 500

local function enabled()
  if vim.env.LEVVY_NO_LOG == "1" then
    return false
  end
  return not vim.g.levvy_no_log
end

local function append(record)
  local ok, line = pcall(vim.json.encode, record)
  if not ok then
    return
  end
  pcall(vim.fn.writefile, { line }, M.path, "a")
end

-- reads the picker's ranked candidate list and the selection, and appends a
-- record. `selected_entry` may be nil (abandoned search). safe to call more
-- than once per picker -- it self-guards against double logging.
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
  -- only log pickers actually ranked by levvy
  if not (picker.sorter and picker.sorter._levvy) then
    return
  end
  picker._levvy_logged = true

  local manager = picker.manager
  if not manager then
    return
  end

  local prompt = require("telescope.actions.state").get_current_line()
  local n = manager:num_results()

  local results = {}
  local selected = nil
  local limit = math.min(n, MAX_RESULTS)
  for i = 1, limit do
    local entry = manager:get_entry(i)
    local score = manager:get_score(i)
    if entry then
      results[i] = { value = entry.ordinal, score = score }
      if selected_entry and entry == selected_entry then
        selected = { value = entry.ordinal, score = score, rank = i }
      end
    end
  end

  -- selected entry might be identified by identity miss; fall back to ordinal
  if selected_entry and not selected then
    local sel_ord = selected_entry.ordinal
    for i = 1, limit do
      if results[i] and results[i].value == sel_ord then
        selected = { value = sel_ord, score = results[i].score, rank = i }
        break
      end
    end
  end

  append({
    ts = os.time(),
    source = picker.prompt_title,
    prompt = prompt,
    prompt_len = prompt and #prompt or 0,
    kept = n,
    selected = selected,
    results = results,
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

-- wires the select-time and close-time hooks; call once from telescope setup
function M.attach()
  local actions = require("telescope.actions")
  actions.select_default:enhance({
    pre = function(prompt_bufnr)
      pcall(M.on_select, prompt_bufnr)
    end,
  })

  -- telescope tears a picker down on BufLeave of its prompt buffer; a global
  -- BufLeave defined here (before any picker's own once-handler) runs first,
  -- while the picker is still alive, catching abandoned searches. the
  -- _levvy_logged guard keeps a select-then-close from logging twice.
  vim.api.nvim_create_autocmd("BufLeave", {
    group = vim.api.nvim_create_augroup("LevvySearchLog", {}),
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
    lines = vim.fn.readfile(M.path)
  end)
  local total = #lines
  local with_sel, rank_sum, sel_score_max = 0, 0, nil
  for _, line in ipairs(lines) do
    local ok, rec = pcall(vim.json.decode, line)
    if ok and rec and rec.selected then
      with_sel = with_sel + 1
      rank_sum = rank_sum + (rec.selected.rank or 0)
      local s = rec.selected.score
      if s and (not sel_score_max or s > sel_score_max) then
        sel_score_max = s
      end
    end
  end
  local avg_rank = with_sel > 0 and string.format("%.1f", rank_sum / with_sel) or "n/a"
  print("levvy search log: " .. M.path)
  print(string.format("  %d searches recorded, %d with a selection", total, with_sel))
  print(string.format("  avg selected rank: %s", avg_rank))
  print(string.format("  highest selected score (threshold floor): %s", tostring(sel_score_max or "n/a")))
end

return M
