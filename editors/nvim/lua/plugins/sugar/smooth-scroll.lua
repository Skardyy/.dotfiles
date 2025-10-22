return {
	"declancm/cinnamon.nvim",
	version = "*",
	config = function()
		local is_gui_mode = vim.fn.has("gui_running") == 1
		if not is_gui_mode then
			require("cinnamon").setup({
				keymaps = {
					basic = true,
					extra = true,
				},
				options = {
					mode = "window",
					max_delta = {
						time = 100,
					},
				},
			})
		end
	end,
}
