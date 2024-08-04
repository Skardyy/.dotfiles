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
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local builtin = require("telescope.builtin")
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

      vim.keymap.set("n", "<leader>fb", builtin.git_branches, { desc = "Git Branches" })
      vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
      vim.keymap.set("n", "<leader>fc", builtin.git_commits, { desc = "Git Commits" })
      vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "LSP Document Symbols" })
      vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })

      -- Fzf-cd
      local function cd_to_file_directory(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        local file_path = selection.path
        local dir_path = vim.fn.fnamemodify(file_path, ":h")
        vim.cmd.cd(dir_path)
        print("Changed to directory: " .. dir_path)
      end
      local function find_and_cd()
        builtin.find_files({
          prompt_title = "< Find and CD >",
          cwd = vim.fn.expand("~"), -- Start from home directory
          file_ignore_patterns = {
            "^%.git/",
            "^%.cache/",
            "^%.local/",
            -- Add other patterns as needed
          },
          attach_mappings = function(_, map)
            map("i", "<CR>", cd_to_file_directory)
            map("n", "<CR>", cd_to_file_directory)
            return true
          end,
        })
      end

      vim.keymap.set("n", "<leader>fo", find_and_cd, { desc = "Find and CD" })
    end,
  },
}
