local lualine = require("lualine")
local _1_
if vim.g.neovide then
  _1_ = {left = "", right = ""}
else
  _1_ = {left = "\238\130\184", right = "\238\130\190"}
end
return lualine.setup({sections = {lualine_c = {{"filename", path = 3}}, lualine_x = {"searchcount", "selectioncount", "encoding", "filesize", "filetype"}}, options = {component_separators = {left = "", right = ""}, section_separators = _1_}, tabline = {lualine_a = {{"tabs", mode = 0, show_modified_status = false}}, lualine_z = {"windows"}}})
