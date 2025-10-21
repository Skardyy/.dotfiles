-- best for PR Check / Merge Conflict
return {
  "sindrets/diffview.nvim",
  config = function()
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true, desc = "" }

    map("n", "<leader>do", "<cmd>DiffviewOpen<cr>", vim.tbl_extend("force", opts, { desc = "Open Diffview" }))
    map("n", "<leader>dc", "<cmd>DiffviewClose<cr>", vim.tbl_extend("force", opts, { desc = "Close Diffview" }))
    map("n", "<leader>dm", "<cmd>DiffviewOpen origin/main...HEAD<cr>",
      vim.tbl_extend("force", opts, { desc = "Diff vs main" }))
  end,
}
