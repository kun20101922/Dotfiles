return {
	'saghen/blink.cmp',
	-- optional: provides snippets for the snippet source
	dependencies = { 'rafamadriz/friendly-snippets' },

	-- use a release tag to download pre-built binaries
	version = '1.*',
	-- AND/OR build from source
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = { preset = 'enter' },
		appearance = {
			nerd_font_variant = 'mono'
		},
		completion = {

			-- default = {
			-- 	enabled = true,
			-- 	min_width = 15,
			-- 	max_height = 10,
			-- 	border = nil,
			-- 	winblend = 0,
			-- 	winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:None,Search:None',
			-- 	--winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
			--
			--
			-- 	-- keep the cursor X lines away from the top/bottom of the window
			-- 	scrolloff = 5,
			-- 	-- note that the gutter will be disabled when border ~= 'none'
			-- 	scrollbar = false,
			-- 	-- which directions to show the window,
			-- 	-- falling back to the next direction when there's not enough space
			-- 	direction_priority = { 's', 'n' },
			-- 	-- which direction previous/next items show up
			-- 	-- TODO: implement
			-- 	order = { n = 'bottom_up', s = 'top_down' },
			--
			-- },

			menu = {
				auto_show = true,
				scrollbar = false,
				scrolloff = 10,
				auto_show_delay_ms = 100,
				min_width = 40,
				winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:None,Search:None',
				max_height = 50,
				draw = {
					padding = 2,
					gap = 2,
					columns = {
						{ "kind_icon", gap = 2 },
						{ "label", "label_description", gap = 2 },
						{ "kind", gap = 2 },
						--{ "source_name", gap = 1 },
					},
					components = {
						kind_icon = {
							text = function(ctx)
								return require('lspkind').symbol_map[ctx.kind] or ''
							end,
						},
					},
				},
			},

			list = {

				selection = {
					preselect = true,
					auto_insert = true,
				}
			}
		},    
		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" }
	},
	opts_extend = { "sources.default",  }
}
