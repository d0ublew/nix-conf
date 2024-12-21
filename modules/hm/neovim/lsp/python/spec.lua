local on_attach = function(client, _)
  if client.name == "ruff" then
    client.server_capabilities.hoverProvider = false
  end
end

return {
  formatters = {
    "ruff_fix",
    "ruff_format",
    "ruff_organize_imports",
  },
  servers = {
    {
      name = "ruff",
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
  },
}
