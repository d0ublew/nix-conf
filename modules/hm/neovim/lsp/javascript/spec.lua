return {
  servers = {
    {
      name = "biome",
      config = true,
    },
    {
      name = "ts_ls",
      config = {
        server_capabilities = {
          documentFormattingProvider = false,
        },
      },
    },
  },
  formatters = {
    "biome",
    "biome-check",
  },
}
