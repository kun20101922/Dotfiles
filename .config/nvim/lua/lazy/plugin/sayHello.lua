return {
	dir = "~/.config/nvim/lua/my-cool-plugin",
	config = function ()
		require("my-cool-plugin").setup()
	end
}
