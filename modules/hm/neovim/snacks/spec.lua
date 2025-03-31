return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      -- dim = { enabled = true },
      indent = { enabled = true },
      statuscolumn = { enabled = true, left = { "sign", "mark" } },
      zen = {
        enabled = true,
        toggles = {
          dim = false,
        },
        show = {
          statusline = true, -- can only be shown when using the global statusline
          tabline = true,
        },
      },
      quickfile = { enabled = true },
      input = { enabled = true },
    },
    keys = {
      { "<leader>z", "<cmd>lua Snacks.zen()<CR>", "Toggle zen mode" },
    },
  },
}
