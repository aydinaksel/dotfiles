return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "terraform", "lua", "rust", "apex", "html", "css", "python",
        "javascript", "soql", "sosl", "sql",
      }
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
          pcall(vim.treesitter.start, event.buf)
        end,
      })
    end
  }
}
