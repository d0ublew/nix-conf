return {
  {
    "folke/tokyonight.nvim",
    opts = function(_)
      return {
        style = "moon",
        light_style = "day",
        transparent = vim.g.d0ublew_transparent,
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
          if not vim.g.d0ublew_transparent then
            return
          end
          -- set telescope-bg transparent
          hl.TelescopeNormal.bg = c.none
          hl.TelescopeBorder.bg = c.none
          hl.TelescopeSelectionCaret = {
            fg = c.blue,
            bg = c.blue,
          }
          hl.TelescopePromptBorder.bg = c.none
          hl.TelescopePromptTitle.bg = c.none

          hl.WinBar = {
            bg = c.none,
            fg = hl.StatusLine.fg,
          }

          hl.WinBarNC = {
            bg = c.none,
            fg = hl.StatusLine.fg,
          }

          -- hl.NavicText.bg = c.bg_statusline
          -- hl.NavicSeparator.bg = c.bg_statusline
        end,
      }
    end,
    config = function(_, opts)
      require("tokyonight").setup(opts)
    end,
  },
}
