-- [nfnl] plugin/configs/auto-formatting.fnl
local conform = require("conform")
conform.setup({formatters_by_ft = {javascript = {"prettier"}, typescript = {"prettier"}, css = {"prettier"}, html = {"prettier"}, json = {"prettier"}, yaml = {"prettier"}, markdown = {"prettier"}, vue = {"prettier"}}, format_on_save = {timeout_ms = 500, lsp_fallback = true}})
local prettier = require("prettier")
return prettier.setup({bin = "prettier", filetypes = {"javascript", "typescript", "css", "scss", "json", "html", "vue", "yaml", "markdown"}})
