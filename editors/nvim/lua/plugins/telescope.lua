return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = "telescope.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = true,
    cmd = "Telescope",
    keys = {
      { "<leader>g", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
      { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    },
    tag = "0.1.8",
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_cursor({}),
          },
        },
      })
      telescope.load_extension("ui-select")
    end,
  },
}
