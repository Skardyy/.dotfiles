return {
  'stevearc/conform.nvim',
  config = function()
    local formatters = {}
    for ft, tools in pairs(vim.g.lang_maps) do
      if tools.formatter then
        local fmt_list = type(tools.formatter) == "table" and tools.formatter or { tools.formatter }
        formatters[ft] = fmt_list
      end
    end
    require("conform").setup({
      formatters_by_ft = formatters,
      default_format_opts = {
        lsp_format = "fallback",
      },
    })
  end,
}
