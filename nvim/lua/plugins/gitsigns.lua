return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "▎" },
					topdelete = { text = "▎" },
					changedelete = { text = "▎" },
					untracked = { text = "▎" },
				},
				numhl = false,
				lnehl = false,
				watch_gitdir = { interval = 1000 },
				sign_priority = 6,
				update_debounce = 200,
				status_formatter = nil, -- Use default
			})
		end,
	},
}
