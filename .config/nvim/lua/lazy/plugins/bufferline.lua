return {
	'akinsho/bufferline.nvim', version = "*", 
	dependencies = 'nvim-tree/nvim-web-devicons',
	config = function ()
		require("bufferline").setup {
			options = {
				mode = "none",                    
				themable = true,
				numbers = "none",                    
				close_command = "bdelete! %d",       
				right_mouse_command = "bdelete! %d",
				left_mouse_command = "buffer %d",
				middle_mouse_command = nil,

				buffer_close_icon = '󰅖',
				modified_icon = '●',
				close_icon = '',
				left_trunc_marker = '',
				right_trunc_marker = '',

				show_buffer_icons = true,            
				show_buffer_close_icons = true,
				show_close_icon = true,
				show_tab_indicators = true,
				show_duplicate_prefix = true,
				color_icons = true,                 
				separator_style = "thin",            
				always_show_bufferline = false,
				hover = {
					enabled = true,
					delay = 150,
					reveal = { "close" },
				},

				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "center",
						separator = true,
					},
				},

				diagnostics = "nvim_lsp",            
				diagnostics_indicator = function(count, level)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,
			},
		}
	end
}


