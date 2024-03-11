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
      :volar ["vue"]}})

; set some icons instead of letters in the gutter
(lsp-zero.set_sign_icons
  {:error "✘"
   :warn "▲"
   :hint "⚑"
   :info "»"})

(local mason (require :mason))
(mason.setup)

(local mason-lspconfig (require :mason-lspconfig))
(mason-lspconfig.setup
  {:handlers {1 lsp-zero.default_setup :fennel_language_server (fn []
                                                                  (let [lspconfig (require "lspconfig")]
                                                                    (lspconfig.fennel_language_server.setup
                                                                      {:settings
                                                                       {:fennel
                                                                         {:workspace {:library (vim.api.nvim_list_runtime_paths)}
                                                                          :diagnostics {:globals ["vim"]}}}})))}
   :ensure_installed
    ["tsserver" ; TypeScript and JavaScript
     "rust_analyzer" ; Rust
     "bashls" ; Bash
     "clangd" ; C
     "omnisharp" ; C# (alternative is `csharp_ls`, written in F#)
     "clojure_lsp" ; Clojure
     "dockerls" ; Docker (there is also `docker_compose_language_service` as a supplement)
     "eslint"
     "elmls" ; Elm
     "fsautocomplete" ; F#
     "fennel_language_server" ; Fennel
     "gopls" ; Go
     "graphql"
     "html"
     "htmx"
     ; "hls" ; Haskell, failed to install for some reason
     "biome" ; Linter and Formatter for JavaScript, TypeSript, JSON, CSS, Vue (only the <script> part)
     "lua_ls" ; Lua
     "autotools_ls" ; Make
     "marksman" ; Markdown
     "glsl_analyzer" ; GLSL (OpenGL)
     "powershell_es" ; PowerShell
     "jedi_language_server" ; Python lsp
     "ruff_lsp" ; Python linter and formatter, no type checking (written in Rust)
     "sqlls" ; SQL, written in TypeScript (alternatively tried `sqls` written in Go, didn't work)
     "volar" ; Vue
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

(local cmp (require :cmp))
(cmp.setup
  ;; this mapping allows us to confirm completions without selecting with ctrl+space
  ;; or shift+tab
  {:mapping (cmp.mapping.preset.insert
              {:<C-Space> (cmp.mapping.confirm {:select true})
               :<S-Tab> (cmp.mapping.confirm {:select true})
               :<C-y> (cmp.mapping.confirm {:select false})})
   :sources [{:name "nvim_lsp"} {:name "nvim_lua"}]
   :window {:completion (cmp.config.window.bordered)
            :documentation (cmp.config.window.bordered)}})
