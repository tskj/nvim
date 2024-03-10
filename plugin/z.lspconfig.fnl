(local lsp-zero (require :lsp-zero))
(lsp-zero.on_attach
  (fn [client bufnr]
    (lsp-zero.default_keymaps {:buffer bufnr})

    ;; check out the lsp-zero docs for more information, specifically under
    ;; LSP configuration
    ;; but in any case: this runs _all_ language servers, so if there
    ;; are more than one, they'll all format in a random order
    ;; apparently you're supposed to make vim.lsp.buf.format()
    ;; use prettier or w/e if you want to use that instead
    (lsp-zero.buffer_autoformat)))

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
  {:handlers [lsp-zero.default_setup]
   :ensure_installed
    ["tsserver"
     "rust_analyzer"]})

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
