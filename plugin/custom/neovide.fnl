(local {: run} (require :user.utils))
(when vim.g.neovide

  (set vim.g.neovide_hide_mouse_when_typing true)

  (vim.keymap.set :n "<M-Enter>"
                  (fn [] (if vim.g.neovide_fullscreen
                           (set vim.g.neovide_fullscreen false)
                           (set vim.g.neovide_fullscreen true))
                    {:silent true}))

  (set vim.g.neovide_cursor_animate_command_line false)

  ;; these get toggled further down, so these are
  ;; the opposite of the defaults!
  (var transparent? true)
  (var animation? false)
  (var linespacing? false)

  (var separators nil)

  (fn neovide-toggle! [{: args}]
    (match args
      :toggle-transparency
      (if transparent?
        (do (set transparent? false)
            (set vim.g.neovide_transparency 1))
        (do (set transparent? true)
            (set vim.g.neovide_transparency 0.95)))

      :toggle-animations
      (if animation?
        (do (set animation? false)
            (set vim.g.neovide_scroll_animation_length 0)
            (set vim.g.neovide_cursor_animation_length 0)
            (set vim.g.neovide_cursor_trail_size 0))
        (do (set animation? true)
            (set vim.g.neovide_scroll_animation_length 0.1)
            (set vim.g.neovide_cursor_animation_length 0.005)
            (set vim.g.neovide_cursor_trail_size 0.5)))

      :toggle-linespacing
      (if linespacing?
        (do (set linespacing? false)
            (set vim.opt.linespace 0)
            (local config (-> (require :lualine) (. :get_config) (run)))
            (when (~= separators nil)
              (tset (-> config (. :options)) :section_separators separators)
              (set separators nil))
            (-> (require :lualine) (. :setup) (run config)))
        (do (set linespacing? true)
            (set vim.opt.linespace 8)
            (local config (-> (require :lualine) (. :get_config) (run)))
            (set separators (-> config (. :options) (. :section_separators)))
            (tset (-> config (. :options)) :section_separators {:left "" :right ""})
            (-> (require :lualine) (. :setup) (run config))))))

  (neovide-toggle! {:args :toggle-transparency})
  (neovide-toggle! {:args :toggle-animations})
  (neovide-toggle! {:args :toggle-linespacing})

  (vim.api.nvim_create_user_command
    "Neovide" neovide-toggle! {:nargs 1
                               :complete
                               (fn [] [
                                       :toggle-transparency
                                       :toggle-animations
                                       :toggle-linespacing])}))

