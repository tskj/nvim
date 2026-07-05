require("oil").setup({
  win_options = {
    -- winbar = "%{v:lua.require('oil').get_current_dir()}",
    wrap = true,
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  keymaps = {
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-r>"] = "actions.refresh",
    ["<C-c>"] = function() require("oil").discard_all_changes() end,
    ["<C-s>"] = function() require("oil").save() end,
    ["-"] = function() require("oil.actions").parent.callback() end,
    ["<CR>"] = "actions.select",
    ["<C-v>"] = "actions.select_split",
    ["<Esc>"] = function() require("oil").close() end,
  },
})
