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

    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeDiffOpen",
      callback = function()
        vim.keymap.set("n", "<C-CR>", function()
          local path = vim.api.nvim_buf_get_name(0)
          if vim.fn.filereadable(path) == 0 then return end
          vim.cmd("tabclose")
          vim.cmd("edit " .. vim.fn.fnameescape(path))
        end, { desc = "Jump to real file from diff" })
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeDiffClose",
      callback = function()
        pcall(vim.keymap.del, "n", "<C-CR>")
      end,
    })
  end,
}
