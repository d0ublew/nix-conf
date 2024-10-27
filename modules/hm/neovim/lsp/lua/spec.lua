return {
	name = "lua_ls",
	config = {
		server_capabilities = {
			semanticTokensProvider = vim.NIL,
		},
		settings = {
			Lua = {
				workspace = {
					checkThirdParty = false,
				},
				completion = {
					callSnippet = "Replace",
				},
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	},
}
