local map = vim.keymap.set

-- Menus
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Mason" })

-- Buffers (b*)
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Buffer: delete" })
map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Buffer: alternate" })

-- Tabs / workspaces (t*)
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "Tab: new" })
map("n", "<leader>tq", "<cmd>tabclose<cr>", { desc = "Tab: close" })
