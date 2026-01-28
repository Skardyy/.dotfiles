return {
  "esmuellert/codediff.nvim",
  cmd = { "CodeDiff", "Diff" },
  keys = {
    { "<leader>do", "<cmd>CodeDiff<cr>", desc = "Open Diffview" }
  },
  config = function()
    require("codediff").setup({
      keymaps = {
        conflict = {
          accept_incoming = "<leader>d1",
          accept_current = "<leader>d2",
          accept_both = "<leader>d3",
          discard = "<leader>d4",
        },
      },
    })

    vim.api.nvim_create_user_command("Diff", function(o)
      vim.cmd("CodeDiff " .. table.concat(o.fargs, " "))
    end, { nargs = "*" })

    vim.keymap.set("n", "<leader>dd", function()
      local options = {
        "Ours (current/right)",
        "Theirs (incoming/left)",
        "None",
        "Both"
      }
      vim.ui.select(options, {
        prompt = "Resolve conflict:",
      }, function(choice, idx)
        if not choice then return end

        local keys = { "<leader>d2", "<leader>d1", "<leader>d4", "<leader>d3" }

        vim.schedule(function()
          local key = vim.api.nvim_replace_termcodes(keys[idx], true, false, true)
          vim.api.nvim_feedkeys(key, "m", false)
        end)
      end)
    end, { desc = "Conflict resolution menu" })
  end,
}
