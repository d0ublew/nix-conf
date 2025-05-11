local transparent = function()
  if not vim.g.d0ublew_transparent then
    return
  end
  vim.api.nvim_set_hl(0, "TroubleNormal", { bg = "NONE" })
end

local aug = vim.api.nvim_create_augroup("d0ublew_trouble_hl", { clear = true })

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    transparent()
  end,
  group = aug,
})

return {
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "]]",
        function()
          require("trouble").next("diagnostics")
          require("trouble").jump_only("diagnostics")
        end,
        desc = "Diagnostics Next (Trouble)",
      },
      {
        "[[",
        function()
          require("trouble").prev("diagnostics")
          require("trouble").jump_only("diagnostics")
        end,
        desc = "Diagnostics Previous (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}
