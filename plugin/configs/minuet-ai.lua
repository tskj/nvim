require("minuet").setup({
  provider_options = { codestral = { optional = { max_tokens = 256, stop = { "\n\n" } } } },
  filetypes = { exclude = { "norg", "markdown", "org", "text", "gitcommit" } },
})
