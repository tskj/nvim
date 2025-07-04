(local lsp-zero (require :lsp-zero))
(lsp-zero.on_attach
  (fn [client bufnr]
    (lsp-zero.default_keymaps {:buffer bufnr})))

    ;; check out the lsp-zero docs for more information, specifically under
    ;; LSP configuration
    ;; but in any case: this runs _all_ language servers, so if there
    ;; are more than one, they'll all format in a random order
    ;; apparently you're supposed to make vim.lsp.buf.format()
    ;; use prettier or w/e if you want to use that instead
    ; (lsp-zero.buffer_autoformat)))

; mostly to stop tsserver from formatting typescript files randomly
(lsp-zero.format_on_save
  {:servers
     {:rust_analyzer ["rust"]
      :biome ["typescript" "javascript"]
      :vue_ls ["vue"]}})

; set some icons instead of letters in the gutter
(lsp-zero.set_sign_icons
  {:error "✘"
   :warn "▲"
   :hint "⚑"
   :info "»"})

(local neodev (require :neodev))
(neodev.setup)

(local mason (require :mason))
(mason.setup
  {:registries ["github:mason-org/mason-registry"
                "github:Crashdummyy/mason-registry"]})

(local mason-lspconfig (require :mason-lspconfig))
(mason-lspconfig.setup
  {:handlers {1 lsp-zero.default_setup}
   :ensure_installed
    ["ts_ls" ; TypeScript and JavaScript
     "rust_analyzer" ; Rust
     "bashls" ; Bash
     "clangd" ; C
     "clojure_lsp" ; Clojure
     "dockerls" ; Docker (there is also `docker_compose_language_service` as a supplement)
     "eslint"
     "elmls" ; Elm
     "millet" ; standard ml
     "fsautocomplete" ; F#
     "gopls" ; Go
     ; "graphql" ; Disabled due to TypeScript hover conflicts
     "html"
     ; "htmx" ; Disabled due to hover conflicts with TypeScript
     ; "hls" ; Haskell, failed to install for some reason
     "biome" ; Linter and Formatter for JavaScript, TypeSript, JSON, CSS, Vue (only the <script> part)
     "lua_ls" ; Lua
     "autotools_ls" ; Make
     "marksman" ; Markdown
     "glsl_analyzer" ; GLSL (OpenGL)
     "powershell_es" ; PowerShell
     "jedi_language_server" ; Python lsp
     "sqlls" ; SQL, written in TypeScript (alternatively tried `sqls` written in Go, didn't work)
     "vue_ls" ; Vue
     "wgsl_analyzer" ; WebGPU Shading Language
     "yamlls" ; YAML
     "zls"]}) ; Zig

; ;; some that didn't quite make the cut
; (comment
;   arduino_language_server
;   azure_pipelines_ls
;   elixirls
;   julials
;   jqls
;   kotlin_language_server
;   rnix ; or nil_ls, for Nix
;   ocamllsp)

(local mason_tool_installer (require :mason-tool-installer))
(mason_tool_installer.setup
  {:ensure_installed
    ["prettier"
     "prettierd"]})

(local cmp (require :cmp))
(cmp.setup
  {:mapping (cmp.mapping.preset.insert
              {:<C-Space> (cmp.mapping.complete {:select true})
               :<C-enter> (cmp.mapping.confirm {:select true})})
   :preselect "item"
   :completion {:completeopt "menu,menuone,noinsert"}
   :sources [{:name "nvim_lsp"} {:name "nvim_lua"} {:name "conjure"}
             {:name "supermaven"}
             {:name "minuet"}]
   :window {:completion (cmp.config.window.bordered)
            :documentation (cmp.config.window.bordered)}})

;; Disable AI completion sources for prose filetypes
(vim.api.nvim_create_autocmd "FileType"
  {:pattern ["norg" "markdown" "org" "text" "gitcommit"]
   :callback (fn []
               (cmp.setup.buffer
                 {:sources [{:name "nvim_lsp"} {:name "nvim_lua"} {:name "conjure"}]}))})

(let [lspconfig (require "lspconfig")]
  (lspconfig.racket_langserver.setup {}))
