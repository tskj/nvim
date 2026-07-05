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

local M = {}

local levvy = require("user.levvy")

function M.sorter(_)
  local sorters = require("telescope.sorters")

  return sorters.Sorter:new({
    discard = false,

    scoring_function = function(_, prompt, line)
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
end

return M
