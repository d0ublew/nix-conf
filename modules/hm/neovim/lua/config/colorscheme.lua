local time = os.date("*t").hour
if time > 17 or time < 6 then
	vim.opt.background = "dark"
	-- vim.cmd([[ colorscheme github_dark ]])
else
	vim.opt.background = "light"
	-- vim.cmd([[ colorscheme github_light ]])
end

-- vim.cmd([[ colorscheme kanagawa ]])
-- vim.cmd([[ colorscheme catppuccin ]])
-- vim.cmd([[ colorscheme tokyonight ]])
