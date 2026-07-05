-- telescope sorter backed by levvy (see lua/user/levvy.lua)
--
-- plugs in as file_sorter / generic_sorter, so <leader>sf and friends rank
-- with levvy: streak-rewarding distance, smart case, length-normalized.
-- entries whose query isn't a subsequence are discarded (score -1), and
-- since a non-match stays a non-match when the query grows, telescope's
-- prefix discard-caching is sound for it (discard = true).

local M = {}

local levvy = require("user.levvy")

function M.sorter(_)
  local sorters = require("telescope.sorters")

  return sorters.Sorter:new({
    discard = true,

    scoring_function = function(_, prompt, line)
      if not prompt or #prompt == 0 then
        return 1
      end
      local score = levvy.score(prompt, line)
      if score < 0 then
        return -1 -- discard
      end
      return score -- lower is better, matching telescope's convention
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
