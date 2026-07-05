require("lualine").setup({
  sections = {
    lualine_c = { { "filename", path = 3 } },
    lualine_x = {
      require("minuet.lualine"),
      "searchcount", "selectioncount",
      "encoding", "filesize", "filetype",
    },
  },
  options = {
    component_separators = { left = "", right = "" },
    -- nerd font powerline-ish triangles U+E0B8 / U+E0BE
    section_separators = { left = "\238\130\184", right = "\238\130\190" },
  },
  tabline = {
    lualine_a = { { "tabs",
                    mode = 0,
                    show_modified_status = false } },
    lualine_z = { "windows" },
  },
})
