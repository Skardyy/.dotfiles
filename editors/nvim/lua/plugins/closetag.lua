return {
  "windwp/nvim-ts-autotag",
  event = "InsertEnter",
  config = function()
    vim.g.closetag_filetypes = "html,xhtml,phtml,xml,javascript,typescript,javascriptreact,typescriptreact,"
    require("nvim-ts-autotag").setup()
  end,
}
