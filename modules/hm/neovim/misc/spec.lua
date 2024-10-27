local lazy_keymap = require("util.keymaps").lazy_keymap
return {
	-- { "ThePrimeagen/git-worktree.nvim", lazy = true },
	{
		"nvim-pack/nvim-spectre",
		cmd = "Spectre",
		opts = { open_cmd = "noswapfile vnew" },
        -- stylua: ignore
        keys = {
            { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
        },
	},
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
	{
		"mbbill/undotree",
		event = "VeryLazy",
		keys = function()
			return {
				lazy_keymap("<leader>U", vim.cmd.UndotreeToggle, {
					mode = "n",
					desc = "Toggle Undotree",
				}),
			}
		end,
	},
	-- { "tpope/vim-sleuth", event = "VeryLazy" },
	{ "tpope/vim-unimpaired", event = "VeryLazy" },
	{ "tpope/vim-repeat", event = "VeryLazy" },
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

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = { spelling = true },
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.add({
				mode = { "n", "v" },
				{ "<leader>b", group = "buffer" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>g", group = "git" },
				{ "<leader>gh", group = "hunks" },
				{ "<leader>s", group = "search" },
				{ "<leader>u", group = "ui" },
				{ "<leader>x", group = "diagnostics/quickfix" },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
			})
			-- wk.setup(opts)
			-- wk.register(opts.defaults)
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

                -- stylua: ignore start
                map("n", "]h", gs.next_hunk, "Next Hunk")
                map("n", "[h", gs.prev_hunk, "Prev Hunk")
                map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
	},

	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			delay = 200,
			large_file_cutoff = 2000,
			large_file_overrides = {
				providers = { "lsp" },
			},
			min_count_to_highlight = 2,
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},

	-- library used by other plugins
	{ "nvim-lua/plenary.nvim", lazy = true },
}
