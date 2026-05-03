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


    vim.keymap.set("n", "<leader>c", function()
      vim.fn.feedkeys(":Compile ", "n")
    end, { desc = "Compile" })

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*compilation*",
      callback = function(ev)
        vim.keymap.set("n", "<C-q>", function()
          require("compile-mode").send_to_qflist()
          local compile_win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_close(compile_win, true)
          vim.cmd("copen")
          vim.api.nvim_set_current_win(get_main_win())
        end, { buffer = ev.buf, desc = "Compile errors to quickfix" })
      end,
    })
  end
}
