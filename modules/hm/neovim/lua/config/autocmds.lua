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
  desc = "Highlight when yanking",
  pattern = "*",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_cursor_position"),
  pattern = "*",
  desc = "Remember last cursor position",
  callback = function()
    local ft = vim.opt.filetype:get()
    if ft == "fugitive" or ft == "gitcommit" or ft == "gitrebase" then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
