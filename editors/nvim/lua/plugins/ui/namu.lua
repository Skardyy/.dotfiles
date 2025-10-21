-- zed like symbol fuzzy search
return {
  "bassamsdata/namu.nvim",
  config = function()
    local allow_kinds = {
      "Function",
      "Method",
      "Class",
      -- "Module",
      -- "Property",
      -- "Variable",
      -- "Constant",
      "Enum",
      "Interface",
      -- "Field",
      "Struct",
    }
    require("namu").setup({
      namu_symbols = {
        options = {
          movement = {
            next = { "<Tab>", "<C-n>", "<DOWN>" }
          },
          multiselect = {
            enabled = false
          },
          AllowKinds = {
            default = allow_kinds,
            go = allow_kinds,
            rust = allow_kinds,
            lua = allow_kinds,
            python = allow_kinds,
          }
        }
      },
      colorscheme = {
        enable = true,
        options = {
          persist = true,
          write_shada = false,
        },
      },
    })

    vim.api.nvim_set_keymap("n", "<leader>o", ":Namu symbols<CR>",
      { noremap = false, silent = true, desc = "Find symbols" })
  end,
}
