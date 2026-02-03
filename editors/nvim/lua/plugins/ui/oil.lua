-- buffer like file explorer
return {
  {
    "refractalize/oil-git-status.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    },
    config = true,
  },
  {
    "JezerM/oil-lsp-diagnostics.nvim",
    dependencies = { "stevearc/oil.nvim" },
    opts = {
      count = false,
      diagnostic_symbols = {
        error = "󰅙",
        warn = "",
        info = "",
        hint = "",
      },
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function()
      local permission_hlgroups = {
        ["-"] = "NonText",
        ["r"] = "DiagnosticSignWarn",
        ["w"] = "DiagnosticSignError",
        ["x"] = "DiagnosticSignOk",
      }

      local oil = require("oil")
      oil.setup({
        default_file_explorer = true,
        columns = {
          {
            "permissions",
            highlight = function(permission_str)
              local hls = {}
              for i = 1, #permission_str do
                local char = permission_str:sub(i, i)
                table.insert(hls, { permission_hlgroups[char], i - 1, i })
              end
              return hls
            end,
          },
          { "size",  highlight = "Special" },
          { "mtime", highlight = "Number" },
          {
            "icon",
            add_padding = false,
          },
        },
        win_options = {
          signcolumn = "yes:2",
        },
        view_options = {
          show_hidden = true,
        },
        confirmation = {
          border = "rounded",
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
          require("aerial").close() -- make sure aerial isn't visible (it doesn't contain symbols anyways)
        end
      end
      vim.keymap.set("n", "<leader>e", open_oil_cwd, { desc = "Open oil" })
    end,
  },
}
