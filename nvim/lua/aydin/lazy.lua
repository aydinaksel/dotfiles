local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- Check if lazy.nvim is on the runtimepath (Nix-managed)
  local rtp_lazy = vim.fn.globpath(vim.o.runtimepath, "lua/lazy/init.lua", false, true)
  if #rtp_lazy > 0 then
    lazypath = vim.fn.fnamemodify(rtp_lazy[1], ":h:h:h")
  else
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
end

vim.opt.rtp:prepend(lazypath)

local nix_managed = #vim.fn.globpath(vim.o.runtimepath, "lua/telescope/init.lua", false, true) > 0

require("lazy").setup({
  spec = { import = "plugins" },
  rocks = { enabled = false },
  change_detection = { enabled = false },
  install = { missing = not nix_managed },
  defaults = { lazy = false },
  performance = {
    reset_packpath = not nix_managed,
    rtp = { reset = not nix_managed },
  },
})
