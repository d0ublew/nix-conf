return {
  -- {
  --   "echasnovski/mini.pick",
  --   opts = {},
  --   lazy = false,
  -- },
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
    "echasnovski/mini.statusline",
    lazy = false,
    config = function()
      local MiniStatusline = require("mini.statusline")
      MiniStatusline.setup({
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 40 })
            local diff = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({
              trunc_width = 75,
              signs = {
                -- ERROR = "󰅚 ",
                -- WARN = "󰀪 ",
                -- INFO = "󰋽 ",
                -- HINT = "󰌶 ",
                -- ERROR = "%#DiagnosticError#󰅚 %#MiniStatuslineDevinfo#",
                -- WARN = "%#DiagnosticWarn#󰀪 %#MiniStatuslineDevinfo#",
                -- INFO = "%#DiagnosticInfo#󰋽 %#MiniStatuslineDevinfo#",
                -- HINT = "%#DiagnosticHint#󰌶 %#MiniStatuslineDevinfo#",
                ERROR = " ",
                WARN = " ",
                INFO = " ",
                HINT = " ",
              },
            })
            -- local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location = MiniStatusline.section_location({ trunc_width = 75 })
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              {
                hl = "MiniStatuslineDevinfo",
                strings = {
                  git,
                  diff,
                  diagnostics,
                  -- lsp,
                },
              },
              "%<", -- Mark general truncate point
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=", -- End left alignment
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            })
          end,
        },
      })
    end,
  },

  {
    "echasnovski/mini.hipatterns",
    lazy = false,
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
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
  { "echasnovski/mini.icons", opts = {}, version = false, lazy = false },
}
