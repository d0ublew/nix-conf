return {
  servers = {
    {
      name = "clangd",
      config = {
        settings = {
          clangd = {
            InlayHints = {
              Designators = true,
              Enabled = true,
              ParameterNames = true,
              DeducedTypes = true,
            },
            fallbackFlags = { "-std=c++20" },
          },
        },
      },
    },
  },
  formatters = {
    {
      name = "clang-format",
      config = {},
    },
  },
}
