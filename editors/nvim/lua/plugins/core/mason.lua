return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      local packages_map = {}
      for _, config in pairs(vim.g.lang_maps) do
        for _, key in ipairs({ "lsp", "linter", "formatter" }) do
          if config[key] then
            packages_map[config[key]] = true
          end
        end
      end
      local packages = vim.tbl_keys(packages_map)

      require('mason-tool-installer').setup {
        ensure_installed = packages
      }
    end
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    lazy = true,
    opts = {},
  }
}
