return {
  servers = {
    {
      name = "kotlin_language_server",
      config = {},
    },
  },
  formatters = {
    -- {
    --   name = "ktlint",
    --   config = {
    --     args = {
    --       "--format",
    --       "--stdin-path",
    --       "$FILENAME",
    --       "--log-level=none",
    --     },
    --   },
    -- },
    {
      name = "ktfmt",
      config = { prepend_args = { "--kotlinlang-style" } },
    },
  },
  linters = {
    {
      name = "ktlint",
      config = {
        parser = function(output)
          local lines = {}
          for line in output:gmatch("([^\r\n]+)") do
            if line:find("^Picked up JAVA_TOOL_OPTIONS:") == nil then
              table.insert(lines, line)
            end
          end
          local clean_output = table.concat(lines, "\n")
          local ktlint_output = vim.json.decode(clean_output)
          if vim.tbl_isempty(ktlint_output) then
            return {}
          end
          local diagnostics = {}
          for _, error in pairs(ktlint_output[1].errors) do
            table.insert(diagnostics, {
              lnum = error.line - 1,
              col = error.column - 1,
              end_lnum = error.line - 1,
              end_col = error.column - 1,
              message = error.message,
              severity = vim.diagnostic.severity.WARN,
              source = "ktlint",
            })
          end
          return diagnostics
        end,
      },
    },
  },
}
