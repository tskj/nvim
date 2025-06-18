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