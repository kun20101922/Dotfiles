--color column
-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI"}, {
-- 	pattern = "*",
-- 	callback = function ()
-- 		local curr_col = vim.fn.virtcol(".")
--
-- 		vim.opt_local.colorcolumn = tostring(curr_col)
-- 	end,
-- })

--transparent background
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local highlights = { "Normal", "NormalNC", "NonText", "SignColumn", "EndOfBuffer" }
    for _, highlight in ipairs(highlights) do
      vim.api.nvim_set_hl(0, highlight, { bg = "NONE", ctermbg = "NONE" })
    end
  end,
})

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })



