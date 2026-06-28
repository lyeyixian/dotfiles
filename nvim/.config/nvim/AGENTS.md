# AGENTS.md - LazyVim Neovim Configuration Guidelines

## Build/Lint/Test Commands
- **Format code**: `stylua lua/`
- **Lint Lua**: Use lua_ls LSP (configured in .neoconf.json)
- **No build process**: Reload with `:source %` or restart Neovim
- **No tests**: Configuration files don't have unit tests

## Code Style Guidelines
- **Formatting**: 2 spaces indentation, 120 char max width, spaces not tabs
- **Lua**: Use `local` variables, descriptive names, anonymous functions for callbacks, double quotes
- **Structure**: Plugin configs in `lua/plugins/` return tables, use `opts = {}` for overrides
- **Imports**: Use `require()`, LazyVim plugins auto-loaded via lazy.lua spec
- **Error Handling**: Minimal needed, LSP provides real-time syntax feedback