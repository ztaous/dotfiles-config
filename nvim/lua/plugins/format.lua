return {
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format()
        end,
        desc = "Format buffer",
      },
    },
    opts = function()
      return {
        default_format_opts = {
          lsp_format = "fallback",
          timeout_ms = 10000,
        },
        formatters = {
          ktlint = {
            cwd = require("conform.util").root_file({ ".editorconfig" }),
          },
        },
        formatters_by_ft = {
          java = { "google-java-format" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          go = { "gofmt" },
          rust = { "rustfmt" },
          python = { "ruff_format" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          lua = { "stylua" },
          sh = { "shfmt" },
          kotlin = { "ktlint" },
          sql = { "sqlfluff" },
        },
      }
    end,
  },
}
