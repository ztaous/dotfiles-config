# Neovim

Neovim configuration used by this dotfiles repository.

## Requirements

- Neovim 0.11 or newer
- Git
- ripgrep (`rg`)
- fd
- A Nerd Font for file icons, if wanted

## Setup

Run `./run.sh nvim` from the root of the dotfiles repository, then open
Neovim. lazy.nvim installs missing plugins on the first start.

Language servers are configured for C, C++, Java, Python, Rust, SQL,
JavaScript, TypeScript, and Lua. Mason automatically installs `jdtls`,
`pyright`, `rust-analyzer`, `sqls`, `vtsls`, and `lua-language-server`;
`clangd` must be available on `PATH`.

## Keybindings

The leader key is `Space`.

### Files

- `<leader>e`: toggle the file explorer
- `<leader>ff`: find files
- `<leader>fg`: search text
- `<leader>fr`: open recent files
- `<leader>fb`: search open buffers
- `<leader>Ls`: search symbols in the current file
- `<leader>LS`: search symbols in the workspace

### Buffers and tabs

- `<leader>bb`: open the alternate buffer
- `<leader>bd`: delete the current buffer
- `<leader>tn`: create a tab
- `<leader>tc`: close the current tab

### Code

- `gd`: go to definition
- `gr`: list references
- `K`: show information for the item under the cursor
- `<leader>rn`: rename a symbol
- `<leader>ca`: show code actions
- `<leader>cd`: show the diagnostic under the cursor
- `<leader>cD`: list diagnostics
- `[d` / `]d`: previous or next diagnostic
- `<C-Space>`: request completion
- `<C-n>` / `<C-p>`: move through completion results
- `<C-y>`: accept a completion
- `<leader>cf`: format the current buffer

### Git

- `[c` / `]c`: previous or next hunk
- `<leader>gh`: preview a hunk
- `<leader>gs`: stage a hunk
- `<leader>gS`: stage the current file
- `<leader>gr`: reset a hunk
- `<leader>g.`: open Git status
- `<leader>gc`: commit
- `<leader>gd`: diff the current file
- `<leader>gD`: diff all repository changes
- `gt` / `gT`: next or previous diff tab
- `<leader>gm`: open merge conflicts in Fugitive's mergetool
- `<leader>gB`: show blame

### Tools

- `<leader>l`: open Lazy
- `<leader>m`: open Mason

## Formatters

- Java: Eclipse JDT through `jdtls` (four-space indentation)
- C and C++: `clang-format`
- Go: `gofmt`
- Rust: `rustfmt`
- Python: `ruff`
- JavaScript and TypeScript: `prettier`
- Lua: `stylua`
- Bash: `shfmt`
- Kotlin: `ktlint`
- SQL: `sqlfluff`

## Plugins

- **lazy.nvim**: plugin installation
- **nightfox.nvim, rose-pine, gruvbox.nvim, melange-nvim, and kanagawa.nvim**:
  optional colorschemes
- **nvim-tree**: file explorer
- **telescope.nvim**: file, text, buffer, and symbol search
- **nvim-treesitter**: syntax parsing
- **which-key.nvim**: keybinding hints
- **mason.nvim, mason-lspconfig.nvim, and nvim-lspconfig**: language servers
  and development tools
- **conform.nvim**: formatting
- **gitsigns.nvim and vim-fugitive**: Git
- **nvim-autopairs and nvim-surround**: pairs and surrounding edits

> The built-in colorscheme is used by default. A colorscheme selected with
`:colorscheme` is restored on the next start.
