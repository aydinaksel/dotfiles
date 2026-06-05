return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
          pcall(vim.treesitter.start, event.buf)
        end,
      })
    end
  }
}
