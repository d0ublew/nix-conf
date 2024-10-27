return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- "williamboman/mason.nvim",
			-- "williamboman/mason-lspconfig.nvim",

			{ "j-hui/fidget.nvim", opts = {} },
			{ "nvim-telescope/telescope.nvim" },

			-- Autoformatting
			"stevearc/conform.nvim",
		},
		config = function()
			-- Don't do LSP stuff if we're in Obsidian Edit mode
			if vim.g.obsidian then
				return
			end

			local capabilities = nil
			if pcall(require, "cmp_nvim_lsp") then
				capabilities = require("cmp_nvim_lsp").default_capabilities()
			end

			local lspconfig = require("lspconfig")
			local servers = {}
			local langs = { "nix", "lua" }
			for _, lang in pairs(langs) do
				local has_lang, lsp_lang = pcall(require, "plugins.lsp." .. lang)
				if has_lang then
					servers[lsp_lang.name] = lsp_lang.config
				end
			end
			-- local td = require("util.table_dump")
			-- vim.print(td(servers))

			for name, config in pairs(servers) do
				if config == true then
					config = {}
				end
				config = vim.tbl_deep_extend("force", {}, {
					capabilities = capabilities,
				}, config)

				lspconfig[name].setup(config)
			end

			local disable_semantic_tokens = {
				lua = true,
			}

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

					local settings = servers[client.name]
					if type(settings) ~= "table" then
						settings = {}
					end

					local builtin = require("telescope.builtin")

					vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
					vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
					vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
					vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

					vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
					vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
					vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = 0 })

					local filetype = vim.bo[bufnr].filetype
					if disable_semantic_tokens[filetype] then
						client.server_capabilities.semanticTokensProvider = nil
					end

					-- Override server capabilities
					if settings.server_capabilities then
						for k, v in pairs(settings.server_capabilities) do
							if v == vim.NIL then
								---@diagnostic disable-next-line: cast-local-type
								v = nil
							end

							client.server_capabilities[k] = v
						end
					end
				end,
			})

			-- Autoformatting Setup
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
				},
			})

			-- conform.formatters.injected = {
			--   options = {
			--     ignore_errors = false,
			--     lang_to_formatters = {
			--       sql = { "sleek" },
			--     },
			--   },
			-- }

			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function(args)
					-- local filename = vim.fn.expand "%:p"

					local extension = vim.fn.expand("%:e")
					if extension == "mlx" then
						return
					end

					require("conform").format({
						bufnr = args.buf,
						lsp_fallback = true,
						quiet = true,
					})
				end,
			})

			-- require("lsp_lines").setup()
			vim.diagnostic.config({ virtual_text = true, virtual_lines = false })

			vim.keymap.set("", "gl", function()
				local config = vim.diagnostic.config() or {}
				if config.virtual_text then
					vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
				else
					vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
				end
			end, { desc = "Toggle lsp_lines" })
		end,
	},
}
