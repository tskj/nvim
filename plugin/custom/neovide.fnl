(when vim.g.neovide

  (set vim.g.neovide_transparency 0.95)
  (set vim.getneovide_scroll_animation_length 0.1)
  (set vim.g.neovide_hide_mouse_when_typing true)

  (vim.keymap.set :n "<M-Enter>"
                  (fn [] (if vim.g.neovide_fullscreen
                           (set vim.g.neovide_fullscreen false)
                           (set vim.g.neovide_fullscreen true))
                    {:silent true}))

  (set vim.g.neovide_cursor_animation_length 0.005)
  (set vim.g.neovide_cursor_trail_size 0.5)
  (set vim.g.neovide_cursor_animate_command_line false))
