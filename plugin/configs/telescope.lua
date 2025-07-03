-- [nfnl] plugin/configs/telescope.fnl
local _local_1_ = require("user.utils")
local run = _local_1_["run"]
local actions = require("telescope.actions")
local telescope = require("telescope")
telescope.setup({extensions = {["ui-select"] = {run(require("telescope.themes").get_dropdown)}, undo = {}}, defaults = {layout_strategy = "flex", layout_config = {horizontal = {width = 0.9, preview_width = 0.6, prompt_position = "top"}, vertical = {prompt_position = "top", mirror = true}, flex = {flip_columns = 120}}, sorting_strategy = "ascending", scroll_strategy = "limit", mappings = {i = {["<C-x>"] = actions.delete_buffer}, n = {["<C-x>"] = actions.delete_buffer}}}})
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-selet")
telescope.load_extension("ui-select")
telescope.load_extension("undo")
return telescope.load_extension("refactoring")
