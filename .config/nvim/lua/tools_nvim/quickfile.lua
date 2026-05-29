local M = {}

function M.quick_switch()

	local oldfiles = vim.v.oldfiles
	local targets = {}
	for i = 1, math.min(40, #oldfiles) do
		table.insert(targets, oldfiles[i])
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, targets)

	local width = 60
	local height = #targets
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = (vim.o.lines - height) / 2,
		col = (vim.o.columns - width) / 2,
		style = "minimal",
		border = "none",
		title = "Recent Files (Enter !!!!!!!!!!!!!!!!1) ",
		title_pos = "center"

	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	local function close_window()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end


	vim.api.nvim_win_set_option(win, 'winhl', "NormalFloat:None,FloatBorder:None")

	vim.keymap.set('n', '<cr>', function ()
		local cursor = vim.api.nvim_win_get_cursor(win)
		local selected_file = targets[cursor[1]]
		close_window()
		vim.cmd('edit' .. selected_file)
	end, { buffer = buff })

	vim.keymap.set('n', 'q', close_window, { buffer = buf})
	vim.keymap.set('n', '<Esc>', close_window, { buffer = buf})

end

return M
