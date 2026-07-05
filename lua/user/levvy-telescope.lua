-- telescope sorter backed by levvy (see lua/user/levvy.lua)
--
-- plugs in as file_sorter / generic_sorter, so <leader>sf and friends rank
-- with levvy: streak-rewarding distance, smart case, length-normalized.
--
-- there is no match/no-match gate: every entry gets a real levvy distance
-- and the list is purely ranked by it. a poor match just gets a large
-- distance and sinks to the bottom rather than disappearing, which is the
-- point -- a one-character typo is a cheap substitution, so it still ranks
-- near the top instead of being filtered out (as a subsequence gate, or
-- fzf, would do). the flip side is the list never empties: you read the
-- top of a full ranked corpus. discard = false accordingly (nothing is
-- ever filtered, so telescope must keep and re-rank every entry).
--
-- the sorter accumulates, per picker, the set of candidate ordinals it
-- scored (the corpus). the prompt trace (everything typed, incl. backspaces)
-- is captured separately by levvy-log watching the prompt buffer. levvy-log
-- persists both; since levvy is deterministic, storing the raw inputs lets
-- every score be recomputed offline -- smaller than logging scores and
-- strictly more information.

local M = {}

local levvy = require("user.levvy")

-- bound the in-memory corpus set so a giant live_grep session can't blow up
-- memory or the on-disk corpus snapshot (find_files never approaches this)
local CORPUS_CAP = 100000

function M.sorter(_)
  local sorters = require("telescope.sorters")

  local sorter = sorters.Sorter:new({
    discard = false,

    scoring_function = function(self, prompt, line)
      -- record corpus membership (every entry the picker feeds us, even at
      -- the empty prompt), for levvy-log to persist
      local seen = self._levvy_corpus
      if seen and not seen[line] then
        if self._levvy_corpus_n < CORPUS_CAP then
          seen[line] = true
          self._levvy_corpus_n = self._levvy_corpus_n + 1
        else
          self._levvy_corpus_truncated = true
        end
      end

      if not prompt or #prompt == 0 then
        return 1 -- empty query: keep the entries in their incoming order
      end
      -- levvy distance, lower is better (matches telescope's convention);
      -- always >= 0, so nothing is ever discarded
      return levvy.score(prompt, line)
    end,

    -- exact highlighting: the byte positions an optimal levvy match path
    -- actually matched, reconstructed from the dp table
    highlighter = function(_, prompt, display)
      if not prompt or #prompt == 0 then
        return {}
      end
      return levvy.positions(prompt, display) or {}
    end,
  })

  -- per-picker capture state (fresh Sorter instance per picker)
  sorter._levvy = true -- marker so the logger only touches levvy pickers
  sorter._levvy_corpus = {}
  sorter._levvy_corpus_n = 0
  sorter._levvy_corpus_truncated = false
  sorter._levvy_trace = {} -- prompt trace, filled by levvy-log's text hook
  return sorter
end

return M
