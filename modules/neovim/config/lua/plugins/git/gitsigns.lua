return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▎" },
        topdelete = { text = "▎" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
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
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
      vim.api.nvim_create_user_command("Stage", function(args)
        if args.range > 0 then
          require("gitsigns").stage_hunk({ args.line1, args.line2 })
        else
          require("gitsigns").stage_hunk()
        end
      end, { range = true })
    end,
  }
}
