---@type LazySpec
return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup {
        keymaps = {
          accept_suggestion = "<C-l>",
        },
        disable_keymaps = false,
      }
    end,
  },
}
