return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
	  {
		"<leader>ff",
		function()
		  local root = require("config.root").get(0)
		  require("telescope.builtin").find_files({ cwd = root })
		end,
		desc = "Find files",
	  },
	  {
		"<leader>fg",
		function()
		  local root = require("config.root").get(0)
		  require("telescope.builtin").live_grep({ cwd = root })
		end,
		desc = "Find grep",
	  },
	  { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Find recent" },
	  { "<leader>fb", function() require("telescope.builtin").buffers({ initial_mode = "normal" }) end, desc = "Find buffers" },

	  { "<leader>Ls", function() require("telescope.builtin").lsp_document_symbols() end, desc = "LSP symbols (doc)" },
	  { "<leader>LS", function() require("telescope.builtin").lsp_workspace_symbols() end, desc = "LSP symbols (workspace)" },
	},
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          initial_mode = "insert",
          mappings = { n = { ["d"] = actions.delete_buffer } },
        },
      })
    end
  },
}
