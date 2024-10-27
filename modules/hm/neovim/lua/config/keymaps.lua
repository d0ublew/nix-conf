-- local Util = require("util.lazyvim")
local status_ok_km, keymap = pcall(require, "util.keymaps")

if not status_ok_km then
	return
end

local nnoremap = keymap.nnoremap
local vnoremap = keymap.vnoremap
local xnoremap = keymap.xnoremap
local onoremap = keymap.onoremap
local cmap = keymap.cmap

cmap("<C-a>", "<home>", { desc = "Go to beginning of line" })
cmap("<C-e>", "<end>", { desc = "Go to end of line" })

local status_ok_toggle, toggle = pcall(require, "util.toggle")
if status_ok_toggle then
	nnoremap("<leader>mm", toggle.toggle_bg, { desc = "Toggle Light/Dark Mode" })
end

nnoremap("<esc>", "<cmd>noh<CR><esc>", { desc = "Escape and clear hlsearch" })
nnoremap("k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
nnoremap("j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")
-- nnoremap("n", "nzzzv")
-- nnoremap("N", "Nzzzv")

-- nnoremap("-", vim.cmd.Ex, { desc = "Open NetRW" })
nnoremap("<leader>.", function()
	local basename = vim.fn.expand("%:p:h")
	if vim.bo.filetype == "oil" then
		basename = string.sub(basename, 7, -1)
	end
	vim.fn.chdir(basename)
	vim.notify("Set cwd to " .. basename)
end, { desc = "Set cwd to current file basename" })

-- vim.keymap.set({ "n", "v" }, "<leader>cf", function()
-- 	Util.format({ force = true })
-- end, { desc = "Format" })

-- stylua: ignore start
-- nnoremap("<leader>U", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
-- nnoremap("<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle line wrap" })
-- nnoremap("<leader>ul", function() Util.toggle.number() end, { desc = "Toggle line number" })
-- nnoremap("<leader>uL", function() Util.toggle("relativenmber") end, { desc = "Toggle relative line number" })
-- nnoremap("<leader>uf", function() Util.format.toggle(true) end, { desc = "Toggle format on Save" })
-- nnoremap("<leader>uF", function() Util.format.toggle() end, { desc = "Toggle format on Save (global)" })
-- nnoremap("<leader>ud", function() Util.toggle.diagnostics() end, { desc = "Toggle diagnostics" })
-- stylua: ignore start

-- local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
-- nnoremap("<leader>uc", function()
-- 	Util.toggle("conceallevel", false, { 0, conceallevel })
-- end, { desc = "Toggle Conceal" })
-- if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
-- 	nnoremap("<leader>uh", function()
-- 		Util.toggle.inlay_hints()
-- 	end, { desc = "Toggle Inlay Hints" })
-- end
-- nnoremap("<leader>uT", function()
-- 	if vim.b.ts_highlight then
-- 		vim.treesitter.stop()
-- 	else
-- 		vim.treesitter.start()
-- 	end
-- end, { desc = "Toggle Treesitter Highlight" })

nnoremap("<leader>h", "<cmd>wincmd h<CR>", { desc = "Select left window" })
nnoremap("<leader>j", "<cmd>wincmd j<CR>", { desc = "Select lower window" })
nnoremap("<leader>k", "<cmd>wincmd k<CR>", { desc = "Select upper window" })
nnoremap("<leader>l", "<cmd>wincmd l<CR>", { desc = "Select right window" })

-- if Util.has("bufferline.nvim") then
-- 	nnoremap("<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
-- 	nnoremap("<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
-- 	nnoremap("[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
-- 	nnoremap("]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
-- 	-- nnoremap("<S-tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
-- 	-- nnoremap("<tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
-- else
-- 	nnoremap("<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
-- 	nnoremap("<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
-- 	nnoremap("[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
-- 	nnoremap("]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
-- 	-- nnoremap("<tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })
-- 	-- nnoremap("<S-tab>", "<cmd>tabprevious<CR>", { desc = "Prev tab" })
-- end

nnoremap("<tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })
nnoremap("<S-tab>", "<cmd>tabprevious<CR>", { desc = "Prev tab" })
nnoremap("<leader><tab>", "<cmd>e #<CR>", { desc = "Switch to last buffer" })
nnoremap("<leader>te", "<cmd>tabedit<CR>", { desc = "New tab" })

nnoremap("co", "<cmd>copen<CR>", { desc = "Open quickfix list" })
nnoremap("cc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })
nnoremap("cn", "<cmd>cnext<CR>", { desc = "Next quickfix list" })
nnoremap("cp", "<cmd>cprev<CR>", { desc = "Prev quickfix list" })

--[[ nnoremap("<leader>j", "<cmd>lprev<CR>zz") ]]
--[[ nnoremap("<leader>k", "<cmd>lnext<CR>zz") ]]

-- nnoremap("<leader>sr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<left><left><left>")
nnoremap("<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "chmod +x" })

vnoremap("<C-j>", "J", { desc = "Join lines" })
vnoremap("J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vnoremap("K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

vnoremap("<", "<gv", { desc = "Increase line indentation" })
vnoremap(">", ">gv", { desc = "Decrease line indentation" })

vnoremap("<leader>p", '"_dP', { desc = "Paste and retain yank buffer" })

vnoremap("<S-l>", "$")
vnoremap("<S-h>", "^")

nnoremap("n", "'Nn'[v:searchforward] .. 'zzvv'", { expr = true, desc = "Next search result" })
xnoremap("n", "'Nn'[v:searchforward] .. 'zzvv'", { expr = true, desc = "Next search result" })
onoremap("n", "'Nn'[v:searchforward] .. 'zzvv'", { expr = true, desc = "Next search result" })
nnoremap("N", "'nN'[v:searchforward] .. 'zzvv'", { expr = true, desc = "Prev search result" })
xnoremap("N", "'nN'[v:searchforward] .. 'zzvv'", { expr = true, desc = "Prev search result" })
onoremap("N", "'nN'[v:searchforward] .. 'zzvv'", { expr = true, desc = "Prev search result" })

-- diagnostic
-- local diagnostic_goto = function(next, severity)
-- 	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
-- 	severity = severity and vim.diagnostic.severity[severity] or nil
-- 	return function()
-- 		go({ severity = severity })
-- 	end
-- end
-- nnoremap("]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
-- nnoremap("[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
-- nnoremap("]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
-- nnoremap("[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
-- nnoremap("]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
-- nnoremap("[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
