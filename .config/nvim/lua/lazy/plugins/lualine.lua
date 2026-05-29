return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		local lazy_status = require('lazy.status')


		require('lualine').setup({
			options = {
				icons_enabled = true,
				theme = 'auto',
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
				component_separators = { left = '', right = '' },
				section_separators = { left = '', right = '' },
			},
			sections = {
				lualine_a = {
					''
				},
				lualine_b = {
					{ 'branch', icon = '' },
					'diff',
					{
						'diagnostics',
						sources = { 'nvim_diagnostic' },
						symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
						colored = true,
					},
				},
				lualine_c = {
					{
						function()
							local devicons = require('nvim-web-devicons')
							local filename = vim.fn.expand('%:t')
							local extension = vim.fn.expand('%:e')
							local icon, _ = devicons.get_icon_color(filename, extension, { default = true })
							return icon and icon .. ' ' .. filename or filename
						end,
						color = function()
							local devicons = require('nvim-web-devicons')
							local filename = vim.fn.expand('%:t')
							local extension = vim.fn.expand('%:e')
							local _, icon_color = devicons.get_icon_color(filename, extension, { default = true })
							return { fg = icon_color }
						end,
						padding = { left = 1, right = 1 },
					},
				},
				lualine_x = { 'encoding', 'fileformat', 'filetype',  },
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						return " " .. os.date("%R")
					end,
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { 'filename' },
				lualine_x = { 'location' },
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { 'nvim-tree', 'quickfix' },
		})
	end,
}
