return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {},
				always_divide_middle = true,
				globalstatus = false,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{ "branch" },
					{ "filename" },
				},
				lualine_c = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "error" },
						diagnostics_color = {
							error = "DiagnosticError",
						},
						format = function(d)
							return d.count > 0 and d.count .. " errors" or ""
						end,
					},
				},
				lualine_x = {
					{
						"fileformat",
						symbols = {
							unix = "LF",
							dos = "CRLF",
							mac = "CR",
						},
					},
					{
						function()
							local lang = vim.treesitter.language.get_lang(vim.api.nvim_buf_get_option(0, "filetype"))
							return lang and " " .. lang .. "🌲" or ""
						end,
					},
					{
						function()
							local clients = vim.lsp.get_active_clients()
							if next(clients) == nil then
								return ""
							end
							local names = {}
							for _, client in ipairs(clients) do
								if client.name ~= "null-ls" then
									table.insert(names, client.name)
								end
							end
							return #names > 0 and " " .. table.concat(names, ", ") .. "💡" or ""
						end,
					},
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = {},
		})
	end,
}
