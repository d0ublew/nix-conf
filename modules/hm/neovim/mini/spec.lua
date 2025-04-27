local function diag_hl_config()
  local statusline_hl = vim.api.nvim_get_hl(0, { name = "MiniStatuslineDevinfo", link = true })
  local lsp_diags = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }
  for _, v in pairs(lsp_diags) do
    local diag_hl = vim.api.nvim_get_hl(0, { name = v })
    vim.api.nvim_set_hl(0, "WW" .. v, { fg = diag_hl.fg, bg = statusline_hl.bg, bold = false })
  end
end

local function section_autoformat()
  if vim.bo.filetype == "oil" then
    return ""
  end
  local autoformat_global = vim.g.disable_autoformat and "g" or "G"
  local autoformat_buffer = vim.b.disable_autoformat and "b" or "B"
  return "[" .. autoformat_buffer .. " " .. autoformat_global .. "]"
end

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
    opts = {
      mappings = {
        add = "<localleader>sa", -- Add surrounding in Normal and Visual modes
        delete = "<localleader>sd", -- Delete surrounding
        find = "<localleader>sf", -- Find surrounding (to the right)
        find_left = "<localleader>sF", -- Find surrounding (to the left)
        highlight = "<localleader>sh", -- Highlight surrounding
        replace = "<localleader>sr", -- Replace surrounding
        update_n_lines = "<localleader>sn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
    -- keys = {
    --   { "s", "<nop>", mode = { "n", "v" } },
    -- },
    lazy = false,
  },
  {
    "echasnovski/mini.cursorword",
    opts = {},
    lazy = false,
  },
  {
    "echasnovski/mini.bracketed",
    opts = {
      diagnostic = { suffix = "d", options = { float = {
        border = "rounded",
      } } },
    },
    lazy = false,
  },
  {
    "echasnovski/mini.trailspace",
    opts = {},
    lazy = false,
  },
  {
    "echasnovski/mini.align",
    opts = {
      mappings = {
        start = "<localleader>ga",
        start_with_preview = "<localleader>gA",
      },
    },
    lazy = false,
  },

  {
    "echasnovski/mini.statusline",
    event = { "ColorScheme", "VeryLazy" },
    -- lazy = false,
    config = function()
      local MiniStatusline = require("mini.statusline")
      MiniStatusline.setup({
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 40 })
            local diff = MiniStatusline.section_diff({ trunc_width = 75 })
            local severity = vim.diagnostic.severity
            local icon = require("util.icon")
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
                -- ERROR = " ",
                -- WARN = " ",
                -- INFO = " ",
                -- HINT = " ",
                -- ERROR = "%#WWDiagnosticError# %#MiniStatuslineDevinfo#",
                -- WARN = "%#WWDiagnosticWarn# %#MiniStatuslineDevinfo#",
                -- INFO = "%#WWDiagnosticInfo# %#MiniStatuslineDevinfo#",
                -- HINT = "%#WWDiagnosticHint# %#MiniStatuslineDevinfo#",
                -- ERROR = "%#WWDiagnosticError#󰅚 ",
                -- WARN = "%#WWDiagnosticWarn#󰀪 ",
                -- INFO = "%#WWDiagnosticInfo# ",
                -- HINT = "%#WWDiagnosticHint#󰌶 ",
                ERROR = "%#WWDiagnosticError#" .. icon.lsp_diagnostics_sign[severity.ERROR] .. " ",
                WARN = "%#WWDiagnosticWarn#" .. icon.lsp_diagnostics_sign[severity.WARN] .. " ",
                INFO = "%#WWDiagnosticInfo#" .. icon.lsp_diagnostics_sign[severity.INFO] .. " ",
                HINT = "%#WWDiagnosticHint#" .. icon.lsp_diagnostics_sign[severity.HINT] .. " ",
              },
              -- icon = "|",
            })
            -- local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location = MiniStatusline.section_location({ trunc_width = 75 })
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
            local autoformat = section_autoformat()

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
              { hl = "MiniStatuslineFileinfo", strings = { autoformat, fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            })
          end,
        },
      })
      diag_hl_config()
      local aug = vim.api.nvim_create_augroup("d0ublew_ministatusline_diagnostic_hl", { clear = true })
      -- vim.api.nvim_create_autocmd({ "OptionSet" }, {
      --   callback = diag_hl,
      --   group = aug,
      --   desc = "Set mini.statusline diagnostic highlight when background option changes",
      --   pattern = "background",
      -- })
      vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        callback = diag_hl_config,
        group = aug,
        desc = "Set mini.statusline diagnostic highlight when colorscheme changes",
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

          -- `mini.surround` key
          { mode = "n", keys = "<localleader>" },
          { mode = "x", keys = "<localleader>" },
        },
        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
          { mode = "n", keys = "<localleader>s", desc = "surround" },
          { mode = "x", keys = "<localleader>s", desc = "surround" },
          -- Enhance this by adding descriptions for <Leader> mapping groups
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
