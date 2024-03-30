(local lualine (require :lualine))
(lualine.setup
  {:sections {:lualine_c [{1 "filename" :path 3}]
              :lualine_x ["searchcount" "selectioncount" "encoding" "filesize" "filetype"]}
   :options {:component_separators {:left "" :right ""}
             :section_separators (if vim.g.neovide
                                   {:left "" :right ""} ; linespace messes with the separators
                                   {:left "" :right ""})}
   :tabline {:lualine_a [{1 "tabs"
                          :mode 0
                          :show_modified_status false}]
             :lualine_z ["windows"]}})
