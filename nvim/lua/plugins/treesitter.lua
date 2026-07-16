return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function()
      vim.opt.runtimepath:prepend("@treesitterRuntime@")
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
          pcall(vim.treesitter.start, event.buf)
        end,
      })
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          pcall(vim.treesitter.start, buf)
        end
      end
    end
  }
}
