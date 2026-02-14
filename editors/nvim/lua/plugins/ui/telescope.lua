-- fuzzy finders
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      'nvim-lua/plenary.nvim',
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
      }
    },
    event = "VeryLazy",
    cmd = "Telescope",
    keys = {
      { "<leader>g", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
      { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_cursor({}),
          },
        },
      })
      telescope.load_extension("ui-select")
      telescope.load_extension("fzf")
    end,
  },
}
