return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
		-- optional but recommended
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	},

	config = function() 
		require('telescope').setup{
			defaults = {
				mappings = {
					i = {
						["<C-h>"] = "which_key"
					}
				}
			},
			pickers = {
				find_files = {
					theme = "ivy",
				}
			},
			extensions = {
				themes = {
					layout_config = {
						horizontal = {
							width = 1,
							height = 1,
						}
					}
				}
			}
		}
	end	
}
