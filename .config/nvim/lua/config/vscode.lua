if vim.g.vscode then 
	local options = {
		guicursor = "i-ci-ve:ver25",
		relativenumber = false,
		number = true;
		cursorline = true,
	}
	for k, v in pairs(options) do
		vim.opt[k] = v
	end


		local keymap = vim.keymap.set

		--- file expoler
		keymap('n', '<leader>e', "<cmd>lua require('vscode').action('workbench.action.toggleSidebarVisibility')<CR>")

		-- move line
		keymap('n', '<C-h>', "<cmd>lua require('vscode').action('workbench.action.navigateLeft')<CR>")
		keymap('n', '<C-j>', "<cmd>lua require('vscode').action('workbench.action.navigateDown')<CR>")
		keymap('n', '<C-k>', "<cmd>lua require('vscode').action('workbench.action.navigateUp')<CR>")
		keymap('n', '<C-l>', "<cmd>lua require('vscode').action('workbench.action.navigateRight')<CR>")

		-- move bufferline
		keymap('n', 'L', "<cmd>lua require('vscode').action('workbench.action.nextEditor')<CR>")
		keymap('n', 'H', "<cmd>lua require('vscode').action('workbench.action.previousEditor')<CR>")

end

