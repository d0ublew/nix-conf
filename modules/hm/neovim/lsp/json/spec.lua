return {
  formatters = {
    "jq",
  },
  servers = {
    {
      name = "jsonls",
      config = {
        server_capabilities = {
          documentFormattingProvider = false,
        },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
    },
  },
}
