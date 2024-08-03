return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true })
		require("neo-tree").setup({
			window = {
				mappings = {
					["l"] = "open",
					["h"] = "close_node",
					["<CR>"] = "open",
				},
			},
		})
	end,
}
