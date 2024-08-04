return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

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
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")

      -- Find directory
      local function telescope_find_dir(opts)
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

      vim.keymap.set("n", "<leader>fb", builtin.git_branches, { desc = "Git Branches" })
      vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
      vim.keymap.set("n", "<leader>fc", builtin.git_commits, { desc = "Git Commits" })
      vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "LSP Document Symbols" })
      vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })

      vim.keymap.set("n", "<leader>fo", telescope_find_dir, { desc = "Find Directory" })
    end,
  },
}
