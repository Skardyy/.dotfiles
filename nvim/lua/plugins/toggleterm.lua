return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<Leader>t]],
      direction = "float",
      shell = os.getenv("SHELL") or "pwsh",
    })
  end,
}
