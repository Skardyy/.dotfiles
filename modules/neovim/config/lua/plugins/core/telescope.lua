return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      'nvim-lua/plenary.nvim',
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
      },
      "fdschmidt93/telescope-egrepify.nvim",
    },
    event = "VeryLazy",
    cmd = "Telescope",
    keys = {
      { "<leader>g", "<cmd>Telescope egrepify<cr>",   desc = "Live Grep (grouped)" },
      { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_cursor({}) },
          egrepify = {
            title = true,
            lnum = true,
            col = false,
            filename_hl = "Function",
            results_ts_hl = false,
          },
        },
      })
      telescope.load_extension("ui-select")
      telescope.load_extension("fzf")
      telescope.load_extension("egrepify")

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "TelescopePrompt",
        callback = function(args)
          vim.schedule(function()
            local picker = require("telescope.actions.state").get_current_picker(args.buf)
            if picker and picker.highlighter then
              picker.highlighter.clear_display = function() end
            end
          end)
        end,
      })
    end,
  },
}
