return {
  "ej-shafran/compile-mode.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    vim.g.compile_mode = {}
    vim.api.nvim_set_hl(0, "CompileModeError", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "CompileModeInfo", { link = "DiagnosticInfo" })
    vim.api.nvim_set_hl(0, "CompileModeWarning", { link = "DiagnosticWarn" })
    vim.api.nvim_set_hl(0, "CompileModeMessage", { link = "DiagnosticHint" })
    vim.api.nvim_set_hl(0, "CompileModeMessageRow", { link = "DiagnosticVirtualTextInfo" })
    vim.api.nvim_set_hl(0, "CompileModeMessageCol", { link = "DiagnosticVirtualTextHint" })
    vim.api.nvim_set_hl(0, "CompileModeCommandOutput", { link = "Normal" })
    vim.api.nvim_set_hl(0, "CompileModeOutputFile", { link = "Directory" })
    vim.api.nvim_set_hl(0, "CompileModeCheckResult", { link = "DiagnosticOk" })
    vim.api.nvim_set_hl(0, "CompileModeCheckTarget", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "CompileModeDirectoryMessage", { link = "Comment" })
    vim.api.nvim_set_hl(0, "CompileModeErrorLocus", { link = "DiagnosticUnderlineError" })


    vim.keymap.set("n", "<leader>co", function()
      vim.fn.feedkeys(":Compile ", "n")
    end, { desc = "Compile" })
    vim.keymap.set("n", "<leader>ci", "<CMD>Recompile<CR>", { desc = "Recompile" })

    vim.keymap.set("n", "<leader>cc", function()
      local bufnr = vim.fn.bufnr("*compilation*")
      if bufnr ~= -1 then
        vim.cmd("bdelete " .. bufnr)
      end
    end, { desc = "Close compile buffer" })

    vim.keymap.set("n", "<leader>cq", function()
      require("compile-mode").send_to_qflist()
      local bufnr = vim.fn.bufnr("*compilation*")
      if bufnr ~= -1 then
        vim.cmd("bdelete " .. bufnr)
      end
      local win = vim.api.nvim_get_current_win()
      vim.cmd("copen")
      vim.api.nvim_set_current_win(win)
    end, { desc = "Compile errors to quickfix" })
  end
}
