local _local_1_ = require("user.utils")
local run = _local_1_["run"]
do
  local _let_2_ = require("nvim-treesitter.configs")
  local setup = _let_2_["setup"]
  setup({highlight = {enable = true, additional_vim_regex_highlighting = false}, ensure_installed = {"typescript", "fennel"}, indent = {enable = true}, textobjects = {move = {enable = true, goto_next_start = {["]]"] = "@block.outer"}, goto_next_end = {["]["] = "@block.outer"}, goto_previous_start = {["[["] = "@block.outer"}, goto_previous_end = {["[]"] = "@block.outer"}}, select = {enable = true, keymaps = {ab = "@block.outer", ib = "@block.inner"}, lookahead = true}}})
end
return run(require("treesitter-context").setup, {mode = "topline", line_numbers = true, multiline_threshold = 1, max_lines = 1, trim_scope = "inner"})
