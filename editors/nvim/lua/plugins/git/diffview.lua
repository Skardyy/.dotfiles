-- best for PR Check / Merge Conflict
return {
  "sindrets/diffview.nvim",
  config = function()
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true, desc = "" }

    vim.api.nvim_create_user_command("Diff", function(o)
      vim.cmd("DiffviewOpen " .. table.concat(o.fargs, " "))
    end, { nargs = "*" })
    map("n", "<leader>do", "<cmd>DiffviewOpen<cr>", vim.tbl_extend("force", opts, { desc = "Open Diffview" }))
    map("n", "<leader>dc", "<cmd>DiffviewClose<cr>", vim.tbl_extend("force", opts, { desc = "Close Diffview" }))
    map("n", "<leader>dm", "<cmd>DiffviewOpen origin/main...HEAD<cr>",
      vim.tbl_extend("force", opts, { desc = "Diff vs main" }))
  end,
}
