return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    -- Lazy-load the explorer only when in use
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeCollapse" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    },

    opts = {
      hijack_netrw = true,
      view = {
        width = 34,
        preserve_window_proportions = true,
      },
      actions = {
        open_file = {
          quit_on_open = true,
          resize_window = false,
        },
      },

      renderer = { group_empty = true },
      filters = { dotfiles = false },

      -- Keep the explorer rooted correctly as you move between files/projects
      sync_root_with_cwd = true, -- follow cwd
      update_focused_file = {
        enable = true,
        update_root = false, -- prevents auto-zoom into file’s folder
      },
    },
  },
}
