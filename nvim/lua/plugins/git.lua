return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            {
                "]c",
                function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        require("gitsigns").nav_hunk("next")
                    end
                end,
                desc = "Next Git hunk",
            },
            {
                "[c",
                function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        require("gitsigns").nav_hunk("prev")
                    end
                end,
                desc = "Previous Git hunk",
            },
            {
                "<leader>gh",
                function()
                    require("gitsigns").preview_hunk()
                end,
                desc = "Git hunk preview",
            },
            {
                "<leader>gs",
                function()
                    require("gitsigns").stage_hunk()
                end,
                desc = "Git stage hunk",
            },
            {
                "<leader>gS",
                function()
                    require("gitsigns").stage_buffer()
                end,
                desc = "Git stage file",
            },
            {
                "<leader>gr",
                function()
                    require("gitsigns").reset_hunk()
                end,
                desc = "Git reset hunk",
            },
        },
    },

    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gvdiffsplit", "Gdiffsplit", "Gwrite", "Gread", "Gcommit", "Gblame" },
        keys = {
            { "<leader>g.", "<cmd>Git<cr>", desc = "Git: status" },
            { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git: commit" },
            { "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Git: diff" },
            { "<leader>gm", "<cmd>Git mergetool<cr>", desc = "Git: mergetool" },
            { "<leader>gB", "<cmd>Gblame<cr>", desc = "Git: blame" },
        },
    },
}
