return {
  servers = {
    {
      name = "biome",
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
    { name = "biome" },
    { name = "biome-check" },
    { name = "biome-organize-imports" },
  },
}
