return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>fb", builtin.git_branches, { desc = "Git Branches" })
			vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "Live Grep" })
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
			vim.keymap.set("n", "<leader>fc", builtin.git_commits, { desc = "Git Commits" })
			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "LSP Document Symbols" })
			vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })

			require("telescope").load_extension("ui-select")
		end,
	},
}
