return {
  formatters = {
    { name = "jq" },
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
            schemas = require("schemastore").json.schemas({
              extra = {
                {
                  description = "Pentest Report JSON Schema",
                  fileMatch = { "pentest-report.json" },
                  name = "pentest-report.json",
                  url = "file:///Users/williamwijaya/ws/pentest-1.4-schema.json", -- or '/path/to/your/schema.json'
                },
                {
                  description = "Opencode Config JSON Schema",
                  fileMatch = "opencode.json",
                  name = "opencode.json",
                  url = "https://opencode.ai/config.json",
                },
              },
            }),
            validate = { enable = true },
          },
        },
      },
    },
  },
}
