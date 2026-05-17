vim.opt.shiftwidth = 4

vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    local filepath = vim.api.nvim_buf_get_name(0)
    vim.fn.system({ "leptosfmt", "--quiet", filepath })
    vim.cmd("edit!")
  end,
})
