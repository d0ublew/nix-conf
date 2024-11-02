local on_attach = function(client, _)
	if client.name == "ruff_lsp" then
		client.server_capabilities.hoverProvider = false
	end
end

return {
	{
		name = "ruff_lsp",
		config = {
			on_attach = on_attach,
			init_options = {
				settings = {
					args = {},
				},
			},
		},
	},
	{
		name = "pyright",
		config = {
			settings = {
				pyright = {
					disableOrganizeImpors = true,
				},
				python = {
					analysis = {
						diagnosticSeverityOverrides = {
							reportUndefinedVariable = "none",
						},
					},
				},
			},
		},
	},
}