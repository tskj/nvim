-- web filetypes are NOT auto-formatted on save: other people's codebases
-- come with their own formatting, and reformatting the whole file on every
-- save fights it -- format manually with :Prettier when wanted
local no_format_on_save = {
  "javascript", "javascriptreact",
  "typescript", "typescriptreact",
  "html", "css", "scss", "less",
  "json", "jsonc", "yaml", "vue",
}

require("conform").setup({
  -- still used for manual formatting via require("conform").format()
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    vue = { "prettier" },
  },
  format_on_save = function(bufnr)
    if vim.tbl_contains(no_format_on_save, vim.bo[bufnr].filetype) then
      return
    end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
})

require("prettier").setup({
  bin = "prettier",
  filetypes = {
    "javascript",
    "typescript",
    "css",
    "scss",
    "json",
    "html",
    "vue",
    "yaml",
    "markdown",
  },
})
