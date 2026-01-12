return {
  {
    "saghen/blink.cmp",
    dependencies = {
      { "rafamadriz/friendly-snippets" },
      {
        "xzbdmw/colorful-menu.nvim",
        config = function()
          require("colorful-menu").setup()
        end,
      },
      { "fang2hou/blink-copilot" },
    },
    version = "v0.*",
    event = "VeryLazy",
    config = function()
      local opts = {
        keymap = {
          preset = "default",
          ["<C-k>"] = {},
          ["<C-l>"] = { "show_signature", "hide_signature", "fallback" },
        },
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = "mono",
        },
        signature = {
          enabled = true,
          window = { border = "rounded" },
        },
        sources = {
          default = { "lsp", "path", "buffer", "copilot" },
          providers = {
            copilot = {
              name = "copilot",
              module = "blink-copilot",
              async = true,
            },
          },
        },
        completion = {
          ghost_text = {
            enabled = false,
            show_with_menu = false,
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 0,
            window = { border = "rounded" },
          },
          menu = {
            border = "rounded",
            draw = {
              -- columns = {
              --   { "kind_icon" },
              --   { "label", "label_description", gap = 1 },
              --   { "kind" },
              -- },
              columns = {
                { "kind_icon" },
                { "label", gap = 1 },
                { "kind" },
              },
              components = {
                label = {
                  text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                  end,
                },
              },
            },
          },
        },
      }
      require("blink.cmp").setup(opts)
      local transparent = function()
        if not vim.g.d0ublew_transparent then
          return
        end
        vim.api.nvim_set_hl(0, "BlinkCmpBorder", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelp", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { bg = "NONE" })
      end

      local aug = vim.api.nvim_create_augroup("d0ublew_blink_cmp_hl", { clear = true })

      vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        pattern = "*",
        callback = function()
          transparent()
        end,
        group = aug,
      })

      transparent()
    end,
  },
}
