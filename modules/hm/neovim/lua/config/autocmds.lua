local function augroup(name)
  return vim.api.nvim_create_augroup("d0ublew_" .. name, { clear = true })
end

-- show cursor line only in active window
-- vim.api.nvim_create_autocmd({ "InsertLeave" }, {
-- 	callback = function()
-- 		local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
-- 		if ok and cl then
-- 			vim.wo.cursorline = true
-- 			vim.api.nvim_win_del_var(0, "auto-cursorline")
-- 		end
-- 	end,
-- })
-- vim.api.nvim_create_autocmd({ "InsertEnter" }, {
-- 	callback = function()
-- 		local cl = vim.wo.cursorline
-- 		if cl then
-- 			vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
-- 			vim.wo.cursorline = false
-- 		end
-- 	end,
-- })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = augroup("highlight_yank"),
  pattern = "*",
})
