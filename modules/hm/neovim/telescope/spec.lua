local builtin = require("telescope.builtin")
pcall(require("telescope").load_extension, "ui-select")

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		keys = {
			{ "<leader>T", "<cmd>Telescope<cr>", desc = "Open Telescope" },
			{ "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
			{ "<leader>/", builtin.current_buffer_fuzzy_find, desc = "Search current buffer" },
			-- find
			{ "<leader>ff", builtin.find_files, desc = "Find Files (root dir)" },
			{
				"<leader>fR",
				function()
					builtin.oldfiles({ cwd = vim.loop.cwd() })
				end,
				desc = "Recent (cwd)",
			},
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Open Help" },
			{ "<leader>fc", "<cmd>Telescope command_history<cr>", desc = "Command History" },

			-- git
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },

			-- search
			{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
			{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
			{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
			{ "<leader>sg", builtin.live_grep, desc = "Grep (root dir)" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
			{
				"<leader>st",
				function()
					builtin.colorscheme({ enable_preview = true })
				end,
				desc = "Colorscheme with preview",
			},
			{
				"<leader>ss",
				function()
					builtin.lsp_document_symbols({
						symbols = {
							"Class",
							"Function",
							"Method",
							"Constructor",
							"Interface",
							"Module",
							"Struct",
							"Trait",
							"Field",
							"Property",
						},
					})
				end,
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				function()
					builtin.lsp_dynamic_workspace_symbols({
						symbols = {
							"Class",
							"Function",
							"Method",
							"Constructor",
							"Interface",
							"Module",
							"Struct",
							"Trait",
							"Field",
							"Property",
						},
					})
				end,
				desc = "Goto Symbol (Workspace)",
			},
		},
		opts = {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				mappings = {
					i = {
						["<A-t>"] = function(...)
							return require("trouble.providers.telescope").open_with_trouble(...)
						end,
						-- ["<a-t>"] = function(...)
						--      return require("trouble.providers.telescope").open_selected_with_trouble(...)
						-- end,
						-- ["<a-i>"] = function()
						--     local action_state = require("telescope.actions.state")
						--     local line = action_state.get_current_line()
						--     Util.telescope("find_files", { no_ignore = true, default_text = line })()
						-- end,
						-- ["<A-.>"] = function()
						--     local action_state = require("telescope.actions.state")
						--     local line = action_state.get_current_line()
						--     Util.telescope("find_files", { hidden = true, default_text = line })()
						-- end,
						["<C-s>"] = function(...)
							return require("telescope.actions").cycle_history_next(...)
						end,
						["<C-r>"] = function(...)
							return require("telescope.actions").cycle_history_prev(...)
						end,
						["<C-f>"] = function(...)
							return require("telescope.actions").preview_scrolling_down(...)
						end,
						["<C-b>"] = function(...)
							return require("telescope.actions").preview_scrolling_up(...)
						end,
					},
					n = {
						["q"] = function(...)
							return require("telescope.actions").close(...)
						end,
					},
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		},
	},
}
