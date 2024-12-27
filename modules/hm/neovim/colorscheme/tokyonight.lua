return {
  {
    "folke/tokyonight.nvim",
    opts = function(_)
      return {
        style = "storm",
        light_style = "day",
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
        on_highlights = function(hl, c)
          -- set telescope-bg transparent
          hl.TelescopeNormal.bg = c.none
          hl.TelescopeBorder.bg = c.none
          hl.TelescopeSelectionCaret = {
            fg = c.blue,
            bg = c.blue,
          }
          hl.TelescopePromptBorder.bg = c.none
          hl.TelescopePromptTitle.bg = c.none
        end,
      }
    end,
    config = function(_, opts)
      require("tokyonight").setup(opts)
    end,
  },
}
