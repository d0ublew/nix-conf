-- lua/plugins/rose-pine.lua
return {
  "rose-pine/neovim",
  name = "rose-pine",
  opts = {
    variant = "auto",
    dark_variant = "moon",
    styles = {
      transparency = true,
    },
  },
  -- config = function(_, opts)
  --   require("rose-pine").setup(opts)
  -- end,
}
