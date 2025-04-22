local transparent = function()
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
    },
    version = "v0.*",
    event = "VeryLazy",
    config = function()
      local opts = {
        keymap = { preset = "default", ["<C-k>"] = {}, ["<C-l>"] = { "show_signature", "hide_signature", "fallback" } },
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = "mono",
        },
        signature = {
          enabled = true,
          window = { border = "rounded" },
        },
        sources = {
          default = { "lsp", "path", "buffer" },
        },
        completion = {
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
      transparent()
    end,
  },

  -- {
  --   "hrsh7th/nvim-cmp",
  --   version = false, -- last release is way too old
  --   event = "InsertEnter",
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-buffer",
  --     "hrsh7th/cmp-path",
  --   },
  --   opts = function()
  --     vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
  --     local cmp = require("cmp")
  --     local defaults = require("cmp.config.default")()
  --     return {
  --       mapping = cmp.mapping.preset.insert({
  --         ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  --         ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  --         ["<C-u>"] = cmp.mapping.scroll_docs(-4),
  --         ["<C-d>"] = cmp.mapping.scroll_docs(4),
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --         ["<C-e>"] = cmp.mapping.abort(),
  --         ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --       }),
  --       sources = cmp.config.sources({
  --         { name = "nvim_lsp" },
  --         { name = "buffer" },
  --         { name = "path" },
  --         -- { name = "luasnip" },
  --       }),
  --       formatting = {
  --         format = function(_, item)
  --           local icons = require("config.icons").kinds
  --           if icons[item.kind] then
  --             item.kind = icons[item.kind] .. item.kind
  --           end
  --           return item
  --         end,
  --       },
  --       experimental = {
  --         ghost_text = {
  --           hl_group = "CmpGhostText",
  --         },
  --       },
  --       sorting = defaults.sorting,
  --       -- completion = {
  --       --   completeopt = "menu,menuone,noinsert",
  --       -- },
  --       -- snippet = {
  --       -- 	expand = function(args)
  --       -- 		require("luasnip").lsp_expand(args.body)
  --       -- 	end,
  --       -- },
  --     }
  --   end,
  -- },
}
