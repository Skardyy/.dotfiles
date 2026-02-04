-- buffer like file explorer
return {
  {
    "SirZenith/oil-vcs-status",
    event = "VeryLazy",
    dependencies = { "stevearc/oil.nvim" },
    config = function()
      local status_const = require "oil-vcs-status.constant.status"
      local StatusType = status_const.StatusType

      require "oil-vcs-status".setup {
        status_hl_group = {
          [StatusType.Added]               = "String",
          [StatusType.Copied]              = "String",
          [StatusType.Deleted]             = "Error",
          [StatusType.Ignored]             = "Comment",
          [StatusType.Modified]            = "WarningMsg",
          [StatusType.Renamed]             = "Directory",
          [StatusType.TypeChanged]         = "Type",
          [StatusType.Unmodified]          = "Normal",
          [StatusType.Unmerged]            = "ErrorMsg",
          [StatusType.Untracked]           = "Comment",
          [StatusType.External]            = "Special",
          [StatusType.UpstreamAdded]       = "String",
          [StatusType.UpstreamCopied]      = "String",
          [StatusType.UpstreamDeleted]     = "Error",
          [StatusType.UpstreamIgnored]     = "Comment",
          [StatusType.UpstreamModified]    = "WarningMsg",
          [StatusType.UpstreamRenamed]     = "Directory",
          [StatusType.UpstreamTypeChanged] = "Type",
          [StatusType.UpstreamUnmodified]  = "Normal",
          [StatusType.UpstreamUnmerged]    = "ErrorMsg",
          [StatusType.UpstreamUntracked]   = "Comment",
          [StatusType.UpstreamExternal]    = "Special",
        },
      }
    end
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
          signcolumn = "yes",
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
