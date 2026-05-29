local M = {}

function M.open_terminal()
	
	local buf = vim.api.nvim_create_buf(false, true)

	local width = math.ceil(vim.o.columns * 0.8)
	local height = math.ceil(vim.o.lines * 0.8)
	local row = math.ceil((vim.o.lines - height) / 2)
	local col = math.ceil((vim.o.columns - width) / 2)
	
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "none"

	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	vim.api.nvim_win_set_option(win, 'winhl', "NormalFloat:None,FloatBorder:None")

	vim.fn.termopen(vim.o.shell)

	vim.cmd('startinsert')
end

return M
