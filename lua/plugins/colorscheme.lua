return {
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme("nordfox")
    end,
  },
}
