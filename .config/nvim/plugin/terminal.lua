vim.api.nvim_create_user_command('FloatTerm', function ()
	require("tools_nvim.terminal").open_terminal()
end, {})



