return {
    {
        "mason-org/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup({ PATH = "prepend" })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason-org/mason.nvim" },
        config = function()
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                        hint = { enable = true },
                    },
                },
            })

            local group = vim.api.nvim_create_augroup("user_lsp", { clear = true })
            vim.api.nvim_create_autocmd("LspAttach", {
                group = group,
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then
                        return
                    end

                    local function map(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                    end

                    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                    map("n", "gr", vim.lsp.buf.references, "References")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")

                    if client:supports_method("textDocument/completion") then
                        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
                        map("i", "<C-Space>", vim.lsp.completion.get, "Trigger completion")
                    end

                    if client:supports_method("textDocument/formatting") then
                        map("n", "<leader>cf", function()
                            vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1500 })
                        end, "Format buffer")
                    end

                    if client:supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    end
                end,
            })

            vim.lsp.enable({ "clangd", "pyright", "vtsls", "lua_ls" })
        end,
    },
}
