return {
  {
    "rebelot/heirline.nvim",
    dependencies = {
      "Zeioth/heirline-components.nvim"
    },
    config = function()
      local heirline = require("heirline")
      local lib = require("heirline-components.all")
      heirline.load_colors(lib.hl.get_colors())

      heirline.setup({
        statusline = {
          { provider = "  " },
          lib.component.file_info({ filename = {}, filetype = false }),
          {
            lib.component.git_branch(),
            hl = { link = "@variable" } -- Use theme's foreground
          },
          lib.component.git_diff(),
          lib.component.fill(),
          lib.component.diagnostics(),
          lib.component.treesitter(),
          lib.component.lsp(),
          lib.component.nav(),
        }
      })

      lib.init.subscribe_to_events()
    end
  }
}
