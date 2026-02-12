# Project Purpose
Personal Neovim configuration based on the LazyVim framework.

# Tech Stack
- **Editors**: Neovim
- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Framework**: [LazyVim](https://www.lazyvim.org/)
- **Languages**: Lua
- **Key Plugins**: Mason (LSP/Tool manager), FZF (Fuzzy finder), Yanky (Clipboard history), DAP (Debugging), Snacks.nvim.

# Structure
- `init.lua`: Entry point.
- `lua/config/`: Core configurations (options, keymaps, autocmds).
- `lua/plugins/`: User-defined plugin configurations and overrides.
- `lazyvim.json`: Tracks enabled LazyVim extras and version info.
