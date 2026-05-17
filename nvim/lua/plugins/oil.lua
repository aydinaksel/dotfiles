return {
  {
    "stevearc/oil.nvim",
    ---@module "oil"
    ---@type oil.SetupOpts
    lazy = false,
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    config = function(_, opts)
      require("oil").setup(opts)
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.api.nvim_create_autocmd("UIEnter", {
        callback = function()
          vim.schedule(function()
            local argument = vim.fn.argv(0)
            if argument == "" then
              require("oil").open(vim.fn.getcwd())
            elseif vim.fn.isdirectory(argument) == 1 then
              require("oil").open(argument)
            end
          end)
        end,
      })
    end
  },
}
