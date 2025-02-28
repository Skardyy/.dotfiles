return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = "telescope.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    cmd = "Telescope",
    keys = {
      { "<leader>fb", "<cmd>Telescope buffers<cr>",        desc = "Buffers" },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>",      desc = "Live Grep" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>",     desc = "Find Files" },
      { "<leader>fc", "<cmd>Telescope git_commits<cr>",    desc = "Git Commits" },
      { "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "LSP references" },
    },
    tag = "0.1.5",
    config = function()
      local telescope = require("telescope")

      telescope.load_extension("ui-select")
      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
    end,
  },
}
