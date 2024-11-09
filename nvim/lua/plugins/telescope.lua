return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = "telescope.nvim",
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    dependencies = "telescope.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    cmd = "Telescope",
    keys = {
      { "<leader>fb", "<cmd>Telescope buffers<cr>",               desc = "Buffers" },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>",             desc = "Live Grep" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>",            desc = "Find Files" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",             desc = "Help Tags" },
      { "<leader>fc", "<cmd>Telescope git_commits<cr>",           desc = "Git Commits" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",  desc = "LSP Document Symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "LSP Workspace Symbols" },
      -- Custom functions need to be handled in the config
      { "<leader>ft", function() _G.telescope_find_term() end,    desc = "Terminals" },
      { "<leader>fo", function() _G.telescope_find_dir() end,     desc = "Find Directory" },
    },
    tag = "0.1.5",
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      -- Find directory
      function _G.telescope_find_dir(opts)
        opts = opts or {}
        pickers
            .new(opts, {
              prompt_title = "Find Directory",
              finder = finders.new_oneshot_job({ "fd", "-t", "d", ".", vim.fn.expand("~") }),
              sorter = conf.generic_sorter(opts),
              attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                  local selection = action_state.get_selected_entry()
                  if selection ~= nil then
                    actions.close(prompt_bufnr)
                    vim.cmd("cd " .. selection[1])
                  end
                end)
                return true
              end,
            })
            :find()
      end

      function _G.telescope_find_term()
        builtin.buffers({
          default_text = "term://",
        })
      end

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
    end,
  },
}
