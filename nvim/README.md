# neovim-config

A Neovim setup for everyday development.

## Requirements

- Neovim 0.11+
- Git
- ripgrep (`rg`) for text search
- fd for file finding
- Optional: a Nerd Font for file icons

## Installation

Clone the repository into the Neovim configuration directory:

- Linux/macOS: `~/.config/nvim`
- Windows: `%LOCALAPPDATA%\nvim`

Open Neovim and run `:Lazy sync`.

Language servers are configured for C/C++, Python, JavaScript/TypeScript, and Lua. Open `:Mason` to install `clangd`, `pyright`, `vtsls`, and `lua-language-server` when they are not already available.

## Plugins

- **lazy.nvim**: plugin management
- **nightfox.nvim**: optional colorschemes
- **nvim-tree**: file explorer
- **telescope.nvim**: file, text, buffer, and symbol finding
- **nvim-treesitter**: syntax highlighting
- **mason.nvim + nvim-lspconfig**: language-server installation and configuration
- **gitsigns.nvim + vim-fugitive**: Git signs, hunks, status, diff, commit, and blame
- **nvim-autopairs + nvim-surround**: automatic pairs and surrounding edits

Completion, snippets, comments, diagnostics, and LSP formatting use Neovim's built-in functionality.

## Keybindings

The leader key is `Space`.

### Navigation

- `<leader>e`: toggle the file explorer
- `<leader>ff`: find project files
- `<leader>fg`: search project text
- `<leader>fr`: open recent files
- `<leader>fb`: search open buffers
- `<leader>Ls`: search document symbols
- `<leader>LS`: search workspace symbols

### Buffers and Tabs

- `<leader>bb`: alternate buffer
- `<leader>bd`: delete buffer
- `<leader>tn`: create tab
- `<leader>tc`: close tab

### LSP and Completion

- `gd`: go to definition
- `gr`: list references
- `K`: show hover information
- `<leader>rn`: rename symbol
- `<leader>ca`: show code actions
- `<leader>cf`: format the buffer when supported
- `[d` / `]d`: previous or next diagnostic
- `<C-Space>`: request completion
- `<C-n>` / `<C-p>`: navigate completion results
- `<C-y>`: accept completion

### Git

- `[c`: previous hunk
- `]c`: next hunk
- `<leader>gh`: preview hunk
- `<leader>gs`: stage hunk
- `<leader>gS`: stage file
- `<leader>gr`: reset hunk
- `<leader>g.`: open Fugitive status
- `<leader>gc`: commit
- `<leader>gd`: open vertical diff
- `<leader>gm`: open merge conflicts in Fugitive's mergetool
- `<leader>gB`: show blame

### Management

- `<leader>l`: open Lazy
- `<leader>m`: open Mason

## Behavior

- The built-in Neovim colorscheme is the default.
- A colorscheme selected with `:colorscheme` is restored on the next start.
- Telescope detects the current project root without changing Neovim's global working directory.
- Treesitter parsers are installed for the configured languages.
- Inlay hints are enabled when supported by the attached language server.
- Formatting is manual; format-on-save is not enabled.
