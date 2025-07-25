return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  config = function()
    local oil = require("oil")
    oil.setup({
      default_file_explorer = true,
      columns = {
        "icon",
      },
      view_options = {
        show_hidden = true,
      },
      cleanup_delay_ms = 0,
      keymaps = {
        ["l"] = "actions.select",
        ["<BS>"] = "actions.preview",
        ["h"] = "actions.parent",
        ["<CR>"] = "actions.cd",
      },
    })
    local function open_oil_cwd()
      if oil.get_current_dir() then
        oil.close()
      else
        oil.open(vim.fn.getcwd())
      end
    end
    vim.keymap.set("n", "<leader>e", open_oil_cwd, { desc = "Open oil" })
  end,
}
