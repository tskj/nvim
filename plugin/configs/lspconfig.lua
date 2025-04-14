local lsp_zero = require("lsp-zero")
local function _1_(client, bufnr)
  return lsp_zero.default_keymaps({buffer = bufnr})
end
lsp_zero.on_attach(_1_)
lsp_zero.format_on_save({servers = {rust_analyzer = {"rust"}, biome = {"typescript", "javascript"}, volar = {"vue"}}})
lsp_zero.set_sign_icons({error = "\226\156\152", warn = "\226\150\178", hint = "\226\154\145", info = "\194\187"})
local neodev = require("neodev")
neodev.setup()
local mason = require("mason")
mason.setup()
local mason_lspconfig = require("mason-lspconfig")
local function _2_()
  local lspconfig = require("lspconfig")
  return lspconfig.fennel_language_server.setup({settings = {fennel = {workspace = {library = vim.api.nvim_list_runtime_paths()}, diagnostics = {globals = {"vim"}}}}})
end
mason_lspconfig.setup({handlers = {lsp_zero.default_setup, fennel_language_server = _2_}, ensure_installed = {"ts_ls", "rust_analyzer", "bashls", "clangd", "omnisharp", "clojure_lsp", "dockerls", "eslint", "elmls", "millet", "fsautocomplete", "fennel_language_server", "gopls", "graphql", "html", "htmx", "biome", "lua_ls", "autotools_ls", "marksman", "glsl_analyzer", "powershell_es", "jedi_language_server", "sqlls", "volar", "wgsl_analyzer", "yamlls", "zls"}})
local mason_tool_installer = require("mason-tool-installer")
mason_tool_installer.setup({ensure_installed = {"prettier", "prettierd"}})
local cmp = require("cmp")
cmp.setup({mapping = cmp.mapping.preset.insert({["<C-Space>"] = cmp.mapping.complete({select = true}), ["<C-enter>"] = cmp.mapping.confirm({select = true})}), preselect = "item", completion = {completeopt = "menu,menuone,noinsert"}, sources = {{name = "nvim_lsp"}, {name = "nvim_lua"}, {name = "conjure"}, {name = "supermaven"}, {name = "minuet"}}, window = {completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered()}})
local lspconfig = require("lspconfig")
return lspconfig.racket_langserver.setup({})
