return {
  {
    "williamboman/mason.nvim",
    commit = "fc98833b6da",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    commit = "1a31f824b9cd5b",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  }
}
