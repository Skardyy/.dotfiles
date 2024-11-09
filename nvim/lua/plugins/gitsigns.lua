return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "▎" },
          topdelete = { text = "▎" },
          changedelete = { text = "▎" },
          untracked = { text = "▎" },
        },
        signcolumn = true,
        numhl = false,
        word_diff = false,
        current_line_blame = false,
        watch_gitdir = { interval = 1000, follow_files = true },
        sign_priority = 6,
        update_debounce = 200,
        status_formatter = nil, -- Use default
      })
    end,
  },
}
