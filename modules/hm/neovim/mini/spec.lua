return {
  {
    "echasnovski/mini.pairs",
    opts = {},
    lazy = false,
  },
  {
    "echasnovski/mini.ai",
    opts = {},
    lazy = false,
  },
  {
    "echasnovski/mini.surround",
    opts = {},
    lazy = false,
  },
  {
    "echasnovski/mini.cursorword",
    opts = {},
    lazy = false,
  },
  {
    "echasnovski/mini.bracketed",
    opts = {},
    lazy = false,
  },
  {
    "echasnovski/mini.trailspace",
    opts = {},
    lazy = false,
  },
  {
    "echasnovski/mini.align",
    opts = {},
    lazy = false,
  },

  {
    "echasnovski/mini.clue",
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        window = { delay = 100 },
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },

          -- `mini.bracketed` key
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
        },
        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
          { mode = "n", keys = "<leader>f", desc = "file/find" },
          { mode = "n", keys = "<leader>g", desc = "git" },
          { mode = "n", keys = "<leader>s", desc = "search" },
          { mode = "n", keys = "<leader>t", desc = "tab" },
          { mode = "n", keys = "<leader>u", desc = "ui" },

          { mode = "n", keys = "]b", postkeys = "]" },
          { mode = "n", keys = "]w", postkeys = "]" },

          { mode = "n", keys = "[b", postkeys = "[" },
          { mode = "n", keys = "[w", postkeys = "[" },
        },
      })
    end,
    lazy = false,
  },

  -- {
  --   "echasnovski/mini.completion",
  --   opts = {},
  --   event = "InsertEnter",
  -- },
  { "echasnovski/mini.icons", opts = {}, version = false },
}
