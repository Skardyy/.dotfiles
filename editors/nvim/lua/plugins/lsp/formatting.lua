return {
  'stevearc/conform.nvim',
  config = function()
    local formatters = {}
    for ft, tools in pairs(vim.g.lang_maps) do
      if tools.formatter then
        formatters[ft] = { tools.formatter }
      end
    end
    require("conform").setup({ formatters_by_ft = formatters })
  end,
}
