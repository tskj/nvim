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

if not levvy.available then
  -- fzf-native overrides file_sorter/generic_sorter when loaded, so only
  -- load it when levvy isn't around to do the ranking
  pcall(telescope.load_extension, "fzf")
end

telescope.load_extension("ui-select")
telescope.load_extension("undo")
telescope.load_extension("refactoring")
