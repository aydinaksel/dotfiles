vim.opt.shiftwidth = 4

vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    if not content:find("view!") and not content:find("#%[component") then
      return
    end
    local filepath = vim.api.nvim_buf_get_name(0)
    vim.fn.system({ "leptosfmt", "--quiet", filepath })
    vim.cmd("edit!")
  end,
})
