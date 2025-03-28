return {
  formatters = {
    { name = "stylua" },
  },
  servers = {
    {
      name = "lua_ls",
      config = {
        server_capabilities = {
          semanticTokensProvider = vim.NIL,
        },
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
              library = {
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
              },
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
    },
  },
}
