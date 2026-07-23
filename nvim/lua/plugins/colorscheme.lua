return {
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      local path = vim.fn.stdpath("state") .. "/colorscheme"
      local colorscheme = "default"

      if vim.fn.filereadable(path) == 1 then
        colorscheme = vim.fn.readfile(path)[1]
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("colorscheme_persistence", { clear = true }),
        callback = function(args)
          vim.fn.writefile({ args.match }, path)
        end,
      })

      if not pcall(vim.cmd.colorscheme, colorscheme) then
        vim.cmd.colorscheme("default")
      end
    end,
  },
}
