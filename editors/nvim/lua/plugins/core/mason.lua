return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      local packages_map = {}
      for _, config in pairs(vim.g.lang_maps) do
        if config.lsp and not config.lsp.global then
          packages_map[config.lsp.name] = true
        end
        for _, key in ipairs({ "linter", "formatter" }) do
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
