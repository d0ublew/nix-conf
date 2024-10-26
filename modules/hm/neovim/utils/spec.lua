return {
	-- { "ThePrimeagen/git-worktree.nvim", lazy = true },
	{
		"stevearc/oil.nvim",
		lazy = false,
		opts = {
			columns = {
				-- "icon",
			},
			cleanup_delay_ms = 0,
			keymaps = {
				["<A-p>"] = "actions.preview",
				["<A-u>"] = "actions.preview_scroll_up",
				["<A-d>"] = "actions.preview_scroll_down",
				["<A-y>"] = "actions.copy_entry_path",
			},
		},
		keys = function()
			local lazy_keymap = require("util.keymaps").lazy_keymap
			local oil = require("oil")
			return {
				lazy_keymap("-", "<cmd>Oil<cr>", {
					mode = "n",
					desc = "Open Oil File Explorer",
				}),
				lazy_keymap('<A-">', function()
					oil.set_columns({
						"permissions",
					})
				end, {
					mode = "n",
					desc = "Show permissions (oil)",
				}),
				lazy_keymap("<A-'>", function()
					oil.set_columns({})
				end, {
					mode = "n",
					desc = "Hide permissions (oil)",
				}),
			}
		end,
	},
	-- { "tpope/vim-vinegar" },
	-- { "mbbill/undotree", event = "VeryLazy" },
	-- { "tpope/vim-sleuth", event = "VeryLazy" },
	-- { "tpope/vim-unimpaired", event = "VeryLazy" },
	-- { "tpope/vim-repeat", event = "VeryLazy" },
	-- { "weilbith/nvim-code-action-menu", lazy = true, cmd = "CodeActionMenu" },
	-- {
	-- 	"norcalli/nvim-colorizer.lua",
	-- 	event = { "VeryLazy" },
	-- 	config = function()
	-- 		require("colorizer").setup()
	-- 	end,
	-- },
	-- {
	-- 	"tpope/vim-dadbod",
	-- 	lazy = true,
	-- 	cmd = "DB",
	-- },
	-- {
	-- 	"iamcco/markdown-preview.nvim",
	-- 	build = "cd app && npm install",
	-- 	config = function()
	-- 		vim.g.mkdp_filetypes = { "markdown" }
	-- 	end,
	-- 	ft = { "markdown" },
	-- },
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		keys = function()
			local lazy_keymap = require("util.keymaps").lazy_keymap
			return {
				lazy_keymap("<leader>gg", vim.cmd.Git, {
					mode = "n",
					desc = "Open fugitive",
				}),
				lazy_keymap("<leader>gdh", "<cmd>diffget //2<CR>", {
					mode = "n",
					desc = "Get left",
				}),
				lazy_keymap("<leader>gdl", "<cmd>diffget //3<CR>", {
					mode = "n",
					desc = "Get right",
				}),
			}
		end,
	},

	-- library used by other plugins
	{ "nvim-lua/plenary.nvim", lazy = true },
}
