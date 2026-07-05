local actions = require("telescope.actions")
local levvy = require("user.levvy")

local defaults = {
  layout_strategy = "flex",
  layout_config = {
    horizontal = { width = 0.9, preview_width = 0.6, prompt_position = "top" },
    vertical = { prompt_position = "top", mirror = true },
    flex = { flip_columns = 120 },
  },
  sorting_strategy = "ascending",
  scroll_strategy = "limit",

  -- deep paths: truncate from the left so the filename end is always
  -- visible in the results list...
  path_display = { "truncate" },
  -- ...and show the selected entry's full path as the preview title
  dynamic_preview_title = true,

  mappings = { i = { ["<C-x>"] = actions.delete_buffer },
               n = { ["<C-x>"] = actions.delete_buffer } },
}

-- rank with levvy (the zig fuzzy scorer) when the library is built,
-- otherwise fall back to fzf-native below
if levvy.available then
  local levvy_sorter = require("user.levvy-telescope").sorter
  defaults.file_sorter = levvy_sorter
  defaults.generic_sorter = levvy_sorter
end

local telescope = require("telescope")
telescope.setup({
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown() },
    undo = {},
  },
  defaults = defaults,
})

if levvy.available then
  -- record searches (prompt, ranked corpus, selection) for later
  -- threshold tuning; inspect with :LevvyLog
  require("user.levvy-log").attach()
else
  -- fzf-native overrides file_sorter/generic_sorter when loaded, so only
  -- load it when levvy isn't around to do the ranking
  pcall(telescope.load_extension, "fzf")
end

-- extensions are best-effort: a plugin update that drops or renames an
-- extension must not abort the rest of this config (as happened when
-- refactoring.nvim removed its telescope extension in favour of vim.ui.select)
pcall(telescope.load_extension, "ui-select")
pcall(telescope.load_extension, "undo")

-- :LevvyStatus -- am I actually ranking with levvy? (always available, even
-- when levvy failed to load, which is exactly when you want to check)
vim.api.nvim_create_user_command("LevvyStatus", function()
  if levvy.available then
    vim.notify(
      "levvy: ACTIVE -- Telescope is ranking with the zig scorer.\n" .. levvy.reason,
      vim.log.levels.INFO
    )
  else
    vim.notify(
      "levvy: INACTIVE -- Telescope is using the fzf-native fallback.\nreason: " .. (levvy.reason or "unknown"),
      vim.log.levels.WARN
    )
  end
end, { desc = "Show whether Telescope is ranking with levvy or the fallback" })

-- speak up at startup only when something is actually wrong: silent on
-- success and when intentionally disabled. build-pending is informational,
-- a missing toolchain or a broken library is a warning/error.
if not levvy.available and levvy.state ~= "disabled" then
  local level = vim.log.levels.WARN
  if levvy.state == "not_built" then
    level = vim.log.levels.INFO
  elseif levvy.state == "load_error" then
    level = vim.log.levels.ERROR
  end
  vim.schedule(function()
    vim.notify(
      "levvy scorer not loaded -- Telescope is using fzf-native.\n"
        .. (levvy.reason or "unknown")
        .. "\n(:LevvyStatus for details)",
      level
    )
  end)
end
