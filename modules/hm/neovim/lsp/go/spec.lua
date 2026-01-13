return {
  servers = {
    {
      name = "gopls",
      config = {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      },
    },
  },
  formatters = {
    {
      name = "gofumpt",
      config = {},
    },
    {
      name = "golines",
      config = {},
    },
  },
  linters = {
    {
      name = "golangcilint",
      config = {},
    },
  },
}
