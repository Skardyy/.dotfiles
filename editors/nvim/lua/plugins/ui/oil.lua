-- buffer like file explorer
return {
  {
    "refractalize/oil-git-status.nvim",
    event = "VeryLazy",
    config = true
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local permission_hlgroups = {
        ["-"] = "NonText",
        ["r"] = "DiagnosticSignWarn",
        ["w"] = "DiagnosticSignError",
        ["x"] = "DiagnosticSignOk",
      }
      local oil_last_dir = nil

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
          { "size",  highlight = "Special", align = "right" },
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
          ["<CR>"] = function()
            oil_last_dir = require("oil").get_current_dir()
            vim.notify("Oil dir set: " .. oil_last_dir, vim.log.levels.INFO)
          end,
          ["<S-CR>"] = function()
            oil_last_dir = nil
            vim.notify("Oil dir cleared", vim.log.levels.INFO)
            oil.open(vim.fn.getcwd())
          end,
        },
      })
      local function open_oil_cwd()
        if oil.get_current_dir() then
          oil.close()
        else
          oil.open(oil_last_dir or vim.fn.getcwd())
          require("aerial").close()
        end
      end
      vim.keymap.set("n", "<leader>e", open_oil_cwd, { desc = "Open oil" })
    end,
  },
}
