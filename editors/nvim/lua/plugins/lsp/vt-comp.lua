return {
  "Exafunction/windsurf.nvim",
  config = function()
    require("codeium").setup({
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
        idle_delay = 0,
        key_bindings = {
          accept = "<C-l>"
        }
      }
    })
  end
}
