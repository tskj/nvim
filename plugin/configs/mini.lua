-- moves selection using ctrl + [hjkl]
require("mini.move").setup({
  -- default is meta (alt),
  -- I think ctrl is easier to press
  mappings = { left = "<C-h>",
               right = "<C-l>",
               down = "<C-j>",
               up = "<C-k>" },
})

-- auto-closes brackets and stuff
require("mini.pairs").setup()

-- surround parens
require("mini.surround").setup({
  mappings = { add = "S" },
})

-- comment
require("mini.comment").setup({
  options = { ignore_blank_line = true },
})

-- starter screen and sessions
require("mini.starter").setup()
require("mini.sessions").setup({
  autoread = false,
  file = "",
})

require("mini.jump2d").setup({
  mappings = { start_jumping = "<leader>gj" },
  view = { dim = true, n_steps_ahead = 2 },
})

require("mini.notify").setup()

local trailspace = require("mini.trailspace")
trailspace.setup()
-- automatically remove trailing white space on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  callback = function() trailspace.trim() end,
})

local ai = require("mini.ai")
ai.setup({
  n_lines = 500,
  mappings = { around_last = nil,
               inside_last = nil },
  custom_textobjects = { a = ai.gen_spec.argument({ separator = ",%s*" }) },
})
