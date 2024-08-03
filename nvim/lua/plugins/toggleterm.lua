return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      direction = "float",
      shell = os.getenv("SHELL") or "pwsh",
    })
    vim.api.nvim_set_keymap("n", "<Leader>t", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
    function _G.set_terminal_keymaps()
      local opts = { noremap = true }
      vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
    end

    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
