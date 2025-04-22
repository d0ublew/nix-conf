return {
  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
      {
        "<C-l>",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      vim.notify = require("notify")
    end,
  },

  -- better vim.ui
  -- {
  --   "stevearc/dressing.nvim",
  --   lazy = true,
  --   init = function()
  --     ---@diagnostic disable-next-line: duplicate-set-field
  --     vim.ui.select = function(...)
  --       require("lazy").load({ plugins = { "dressing.nvim" } })
  --       return vim.ui.select(...)
  --     end
  --     ---@diagnostic disable-next-line: duplicate-set-field
  --     vim.ui.input = function(...)
  --       require("lazy").load({ plugins = { "dressing.nvim" } })
  --       return vim.ui.input(...)
  --     end
  --   end,
  -- },

  -- This is what powers LazyVim's fancy-looking
  -- tabs, which include filetype icons and close buttons.
  -- {
  --  "akinsho/bufferline.nvim",
  --  event = "VeryLazy",
  --  keys = {
  --      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
  --      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
  --  },
  --  opts = {
  --      options = {
  --        -- stylua: ignore
  --        close_command = function(n) require("mini.bufremove").delete(n, false) end,
  --        -- stylua: ignore
  --        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
  --          diagnostics = "nvim_lsp",
  --          always_show_bufferline = false,
  --          diagnostics_indicator = function(_, _, diag)
  --              local icons = require("config.icons").diagnostics
  --              local ret = (diag.error and icons.Error .. diag.error .. " " or "")
  --                  .. (diag.warning and icons.Warn .. diag.warning or "")
  --              return vim.trim(ret)
  --          end,
  --          offsets = {
  --              {
  --                  filetype = "neo-tree",
  --                  text = "Neo-tree",
  --                  highlight = "Directory",
  --                  text_align = "left",
  --              },
  --          },
  --      },
  --  },
  -- },

  -- statusline
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   event = "VeryLazy",
  --   -- dependencies = {
  --   --   { "SmiteshP/nvim-navic" },
  --   -- },
  --   opts = function()
  --     local branch = {
  --       "branch",
  --       icons_enabled = true,
  --       icon = "",
  --     }
  --     return {
  --       options = {
  --         icons_enabled = true,
  --         theme = "auto",
  --         component_separators = { left = "", right = "|" },
  --         section_separators = { left = "", right = "" },
  --         disabled_filetypes = {
  --           statusline = {},
  --           winbar = {},
  --         },
  --         ignore_focus = {},
  --         always_divide_middle = true,
  --         globalstatus = true,
  --         refresh = {
  --           statusline = 150,
  --           tabline = 1000,
  --           winbar = 250,
  --         },
  --       },
  --       sections = {
  --         lualine_a = { "mode" },
  --         lualine_b = { branch, "diagnostics" },
  --         lualine_c = {
  --           "filename",
  --           -- {
  --           --   function()
  --           --     return require("nvim-navic").get_location()
  --           --   end,
  --           --   cond = function()
  --           --     return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
  --           --   end,
  --           --   color = "lualine_c_normal",
  --           -- },
  --         },
  --         lualine_x = {
  --           "encoding",
  --           "fileformat",
  --           "filetype",
  --         },
  --         lualine_y = { "progress" },
  --         lualine_z = { "location" },
  --       },
  --       inactive_sections = {
  --         lualine_a = {},
  --         lualine_b = {},
  --         lualine_c = { "filename" },
  --         lualine_x = { "location" },
  --         lualine_y = {},
  --         lualine_z = {},
  --       },
  --       tabline = {},
  --       winbar = {
  --         -- lualine_c = {
  --         --   {
  --         --     function()
  --         --       return require("nvim-navic").get_location()
  --         --     end,
  --         --     cond = function()
  --         --       return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
  --         --     end,
  --         --     color = "lualine_c_normal",
  --         --   },
  --         -- },
  --       },
  --       inactive_winbar = {},
  --       extensions = {},
  --     }
  --   end,
  -- },

  -- indent guides for Neovim
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   event = { "BufReadPost", "BufNewFile" },
  --   main = "ibl",
  --   opts = {
  --     indent = {
  --       char = "│",
  --       tab_char = "│",
  --     },
  --     scope = { enabled = false },
  --     exclude = {
  --       filetypes = {
  --         "help",
  --         "Trouble",
  --         "trouble",
  --         "lazy",
  --         "mason",
  --         "notify",
  --       },
  --     },
  --   },
  -- },

  -- lsp symbol navigation for lualine. This shows where
  -- in the code structure you are - within functions, classes,
  -- etc - in the statusline.
  -- {
  --   "SmiteshP/nvim-navic",
  --   -- lazy = true,
  --   event = "LspAttach",
  --   init = function()
  --     vim.g.navic_silence = true
  --     -- local on_attach = function(client, buffer)
  --     --   if client.server_capabilities.documentSymbolProvider then
  --     --     require("nvim-navic").attach(client, buffer)
  --     --   end
  --     -- end
  --     -- vim.api.nvim_create_autocmd("LspAttach", {
  --     --   callback = function(args)
  --     --     local buffer = args.buf
  --     --     local client = vim.lsp.get_client_by_id(args.data.client_id)
  --     --     on_attach(client, buffer)
  --     --   end,
  --     -- })
  --   end,
  --   opts = function()
  --     return {
  --       separator = " > ",
  --       highlight = true,
  --       depth_limit = 5,
  --       icons = require("config.icons").kinds,
  --       lsp = {
  --         auto_attach = true,
  --       },
  --     }
  --   end,
  -- },

  {
    "Bekaboo/dropbar.nvim",
    -- dependencies = {
    --   "nvim-telescope/telescope-fzf-native.nvim",
    -- },
    -- event = { "LspAttach", "BufWinEnter" },
    event = { "VeryLazy" },
    config = function()
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
      -- vim.ui.select = require("dropbar.utils.menu").select
      require("dropbar").setup({
        bar = {
          enable = function(buf, win, _)
            if
              not vim.api.nvim_buf_is_valid(buf)
              or not vim.api.nvim_win_is_valid(win)
              or vim.fn.win_gettype(win) ~= ""
              or vim.wo[win].winbar ~= ""
              or vim.bo[buf].ft == "help"
            then
              return false
            end

            local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
            if stat and stat.size > 1024 * 1024 then
              return false
            end

            return vim.bo[buf].ft == "markdown"
              or vim.bo[buf].ft == "oil" -- enable in oil buffers
              or vim.bo[buf].ft == "fugitive" -- enable in fugitive buffers
              or pcall(vim.treesitter.get_parser, buf)
              or not vim.tbl_isempty(vim.lsp.get_clients({
                bufnr = buf,
                method = "textDocument/documentSymbol",
              }))
          end,
        },
        sources = {
          path = {
            relative_to = function(buf, win)
              -- Show full path in oil or fugitive buffers
              local bufname = vim.api.nvim_buf_get_name(buf)
              if vim.startswith(bufname, "oil://") or vim.startswith(bufname, "fugitive://") then
                local root = bufname:gsub("^%S+://", "", 1)
                while root and root ~= vim.fs.dirname(root) do
                  root = vim.fs.dirname(root)
                end
                return root
              end

              local ok, cwd = pcall(vim.fn.getcwd, win)
              return ok and cwd or vim.fn.getcwd()
            end,
          },
        },
      })
    end,
  },

  -- icons
  -- { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

  -- {
  --   "folke/zen-mode.nvim",
  --   cmd = "ZenMode",
  --   keys = {
  --     {
  --       "<leader>z",
  --       function()
  --         require("zen-mode").toggle({
  --           window = {
  --             width = 0.80,
  --           },
  --         })
  --       end,
  --       desc = "Toggle zen mode",
  --     },
  --   },
  -- },
}
