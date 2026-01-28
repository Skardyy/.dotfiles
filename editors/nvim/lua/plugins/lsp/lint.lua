return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost", "InsertLeave" },
  config = function()
    local lint = require("lint")

    local linters = {}
    for ft, tools in pairs(vim.g.lang_maps) do
      if tools.linter then
        local lint_list = type(tools.linter) == "table" and tools.linter or { tools.linter }
        linters[ft] = lint_list
      end
    end
    lint.linters_by_ft = linters

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
