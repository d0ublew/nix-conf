return {
	-- Better `vim.notify()`
	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss all Notifications",
			},
			{
				"<C-l>",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss all Notifications",
			},
		},
		opts = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
		},
		init = function()
			vim.notify = require("notify")
		end,
	},

	-- better vim.ui
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},

	-- This is what powers LazyVim's fancy-looking
	-- tabs, which include filetype icons and close buttons.
	-- {
	--  "akinsho/bufferline.nvim",
	--  event = "VeryLazy",
	--  keys = {
	--      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
	--      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
	--  },
	--  opts = {
	--      options = {
	--        -- stylua: ignore
	--        close_command = function(n) require("mini.bufremove").delete(n, false) end,
	--        -- stylua: ignore
	--        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
	--          diagnostics = "nvim_lsp",
	--          always_show_bufferline = false,
	--          diagnostics_indicator = function(_, _, diag)
	--              local icons = require("config.icons").diagnostics
	--              local ret = (diag.error and icons.Error .. diag.error .. " " or "")
	--                  .. (diag.warning and icons.Warn .. diag.warning or "")
	--              return vim.trim(ret)
	--          end,
	--          offsets = {
	--              {
	--                  filetype = "neo-tree",
	--                  text = "Neo-tree",
	--                  highlight = "Directory",
	--                  text_align = "left",
	--              },
	--          },
	--      },
	--  },
	-- },

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			local branch = {
				"branch",
				icons_enabled = true,
				icon = "",
			}
			return {
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "|" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = true,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { branch, "diagnostics" },
					lualine_c = {
						"filename",
						{
							function()
								return require("nvim-navic").get_location()
							end,
							cond = function()
								return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
							end,
						},
					},
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			}
		end,
	},

	-- indent guides for Neovim
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { enabled = false },
			exclude = {
				filetypes = {
					"help",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
				},
			},
		},
	},

	-- lsp symbol navigation for lualine. This shows where
	-- in the code structure you are - within functions, classes,
	-- etc - in the statusline.
	{
		"SmiteshP/nvim-navic",
		lazy = true,
		init = function()
			vim.g.navic_silence = true
			require("util.lazyvim").lsp.on_attach(function(client, buffer)
				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, buffer)
				end
			end)
		end,
		opts = function()
			return {
				separator = " ",
				highlight = true,
				depth_limit = 5,
				icons = require("config.icons").kinds,
			}
		end,
	},

	-- icons
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- ui components
	{ "MunifTanjim/nui.nvim", lazy = true },

	{ "folke/zen-mode.nvim", opts = {} },
}
