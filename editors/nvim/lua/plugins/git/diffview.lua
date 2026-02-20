return {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = { "CodeDiff", "Diff" },
  keys = {
    { "<leader>do", "<cmd>CodeDiff<cr>", desc = "Open Diffview" }
  },
  config = function()
    require("codediff").setup({
      explorer = {
        width = 30,
        view_mode = "tree"
      },
      keymaps = {
        view = {
          next_hunk = "]d",
          prev_hunk = "[d",
        },
        conflict = {
          accept_incoming = "2",
          accept_current = "1",
          accept_both = "4",
          discard = "3",
        },
      },
    })
    vim.api.nvim_create_user_command("Diff", function(o)
      vim.cmd("CodeDiff " .. table.concat(o.fargs, " "))
    end, { nargs = "*" })
  end,
}
