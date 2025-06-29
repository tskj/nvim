# Neovim Configuration Notes

This is a Fennel-based Neovim configuration, not Lua. All configuration files use Fennel syntax.

## Key Information
- Configuration language: Fennel (Lisp-like syntax that compiles to Lua)
- Main config files are in `/plugin/` directory
- Tree-sitter, LSP, and other plugin configurations follow Fennel syntax patterns

## IMPORTANT: File Editing Rules
- **NEVER edit .lua files** - these are compiled artifacts from Fennel source
- **Always edit .fnl files instead** - these are the actual source files
- Exception: custom-lua folders contain actual Lua files, not compiled Fennel
- Look for .fnl files with the same name as .lua files - edit the .fnl version
- The .lua files are generated automatically from .fnl files

## Folding Configuration
- Currently no folding is configured
- Need to add Treesitter folding for C# support

## Notes System Integration

### Journal Setup
- **Location**: `~/notes/.private/journal/YYYY/YYYY-MM-DD.norg`
- **Format**: Neorg files (`.norg` extension)
- **Organization**: Year-based subdirectories for better organization
- **Keybinding**: `<leader>nj` - Open today's journal entry

### Notes Keybindings (`<leader>n` namespace)
- `<leader>nj` - Open today's journal entry
- `<leader>ns` - Save notes (runs `~/notes/.bin/save.sh` with streaming notifications)
- `<leader>np` - Pull notes from git (with streaming notifications)  
- `<leader>nn` - Navigate to notes directory (opens Oil file explorer)

### Explore Keybindings
- `<leader>en` - Explore notes (opens in new tab)
- `<leader>ev` - Explore vim config (opens in new tab, was `<leader>en`)
- `<leader>es` - **UNUSED** (was accidentally created, should be removed)

### Search Keybindings (Updated)
- `<leader>sv` - Search vim config files (was `<leader>sn`)
- `<leader>zv` - FZF search vim config files (was `<leader>zn`)

### Streaming Notifications
- Uses `mini.notify` for floating notification windows (top-right corner)
- Background script execution with `vim.fn.jobstart`
- Real-time stdout/stderr streaming via `notes-notify` wrapper
- Uses `vim.schedule()` to avoid "fast event context" errors

## Text Wrapping Configuration
- **File types**: markdown, norg, org, text
- **Settings**: 
  - `textwidth = 80` - Auto-wrap at 80 characters
  - `wrap = true` - Visual line wrapping
  - `linebreak = true` - Break at word boundaries
  - `breakindent = true` - Preserve indentation on wrapped lines
  - `formatoptions += "t"` - Enable auto-wrapping while typing
  - `formatoptions -= "l"` - Allow wrapping of existing long lines

### Manual Text Wrapping
- `gqq` - Format current line
- `gqip` - Format current paragraph  
- `gq}` - Format until next paragraph
- Visual mode + `gq` - Format selected text

## Neorg Plugin
- **Plugin**: `nvim-neorg/neorg`
- **Configuration**: 
  - Lazy-loaded on `.norg` filetype
  - Workspace: `~/notes` directory
  - Modules: `core.defaults`, `core.concealer`, `core.dirman`
  - Icon preset: `basic`

## File Explorer Function Enhancement
- **Function**: `open-in-explorer [dir ?opts]`
- **New parameter**: `{:new-tab true}` - Opens explorer in new tab
- **Usage**: Supports keyword arguments for optional new tab behavior

## LSP Configuration Notes
- **Vue server**: Use `vue_ls` (not `volar` or `vue_language_server`)
- **Path expansion**: Always use `(vim.fn.expand "~/path")` for tilde expansion in `vim.system`
- **Deprecated functions**: `vim.tbl_islist` is deprecated, use `vim.islist` instead

## Compilation Workflow
- **Command**: `make` - Compiles all .fnl files to .lua
- **Location**: Run from `/home/tskj/.config/nvim/` directory
- **Auto-compilation**: Uses Makefile to compile Fennel to Lua

## Common Patterns

### Fennel Function Definition
```fennel
(fn function-name [arg1 ?optional-arg]
  (let [local-var value]
    (function-body)))
```

### Keybinding with Function
```fennel
(vim.keymap.set [:n :v] "<leader>key" 
  (fn [] 
    (function-call))
  {:desc "Description"})
```

### Background Command with Notifications
```fennel
(vim.fn.jobstart ["command" "args"]
  {:cwd (vim.fn.expand "~/directory")
   :on_stdout (fn [_ data _]
                (each [_ line (ipairs data)]
                  (when (and line (not= line ""))
                    (vim.schedule #(notes-notify line vim.log.levels.INFO)))))
   :on_exit (fn [_ code _]
              (vim.schedule 
                #(notes-notify "Command completed!" vim.log.levels.INFO)))})
```