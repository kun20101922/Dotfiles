
vim.api.nvim_create_user_command("QuickSwitch", function ()
	require("tools_nvim.quickfile").quick_switch()
end, {})
