return {
  "Exafunction/windsurf.nvim",
  event = "InsertEnter",
  config = function()
    vim.api.nvim_set_hl(0, "CodeiumSuggestion", { fg = "#808080" })
    require("codeium").setup({
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
        idle_delay = 0,
        manual = false,
        key_bindings = {
          accept = "<C-l>"
        }
      }
    })
  end
}
