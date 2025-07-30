-- lua/plugins/rose-pine.lua
return {
  "rose-pine/neovim",
  name = "rose-pine",
  opts = {
    variant = "auto",
    dark_variant = "moon",
    dim_inactive_windows = true,
    styles = {
      transparency = vim.g.d0ublew_transparent,
      italic = false,
    },
    before_highlight = function(group, highlight, palette)
      -- Disable all undercurls
      -- if highlight.undercurl then
      --   highlight.undercurl = false
      -- end

      -- Change palette colour
      -- if highlight.fg == palette.pine then
      --     highlight.fg = palette.foam
      -- end
    end,
    highlight_groups = {
      TelescopeBorder = { fg = "highlight_high", bg = "none" },
      TelescopeNormal = { bg = "none" },
      TelescopePromptNormal = { bg = "none" },
      TelescopeResultsNormal = { fg = "subtle", bg = "none" },
      TelescopeSelection = { fg = "text", bg = "base" },
      TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
    },
  },
  -- config = function(_, opts)
  --   require("rose-pine").setup(opts)
  -- end,
}
