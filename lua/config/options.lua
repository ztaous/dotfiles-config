-- Essential options
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Cursor Tracking
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number,line"

-- Keep cursor away from edges
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

--Split stability
vim.opt.splitkeep = "screen"

-- Cursor shapes by mode
vim.opt.guicursor = "n-v-c:block,i-ci:ver25,r-cr:hor20,o:hor50"

