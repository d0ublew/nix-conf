local diag_vline_transparent = function()
  local dvth = "DiagnosticVirtualTextHint"
  local dvti = "DiagnosticVirtualTextInfo"
  local dvtw = "DiagnosticVirtualTextWarn"
  local dvte = "DiagnosticVirtualTextError"
  local hint_hl = vim.api.nvim_get_hl(0, { name = dvth, link = true })
  local info_hl = vim.api.nvim_get_hl(0, { name = dvti, link = true })
  local warn_hl = vim.api.nvim_get_hl(0, { name = dvtw, link = true })
  local error_hl = vim.api.nvim_get_hl(0, { name = dvte, link = true })
  vim.api.nvim_set_hl(0, dvth, { bg = "NONE", fg = hint_hl.fg })
  vim.api.nvim_set_hl(0, dvti, { bg = "NONE", fg = info_hl.fg })
  vim.api.nvim_set_hl(0, dvtw, { bg = "NONE", fg = warn_hl.fg })
  vim.api.nvim_set_hl(0, dvte, { bg = "NONE", fg = error_hl.fg })
end

local aug = vim.api.nvim_create_augroup("d0ublew_diag_vline", { clear = true })

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    diag_vline_transparent()
  end,
  group = aug,
})

local servers = {}
local formatters = {}
local formatters_by_ft = {}

local function extract_lang(fpath)
  local fname = fpath:match("^.+/(.+)$") or fpath
  local lang = fname:match("^(.*)%.") or fname
  return lang
end

local function get_configs()
  for _, fpath in ipairs(vim.api.nvim_get_runtime_file("lua/plugins/lsp/*.lua", true)) do
    local lang = extract_lang(fpath)
    local lsp_cfgs = require("plugins.lsp." .. lang)
    for _, lsp_cfg in pairs(lsp_cfgs.servers) do
      servers[lsp_cfg.name] = lsp_cfg.config
    end
    if lsp_cfgs.formatters ~= nil then
      local fmts = {}
      for _, fmt_cfg in ipairs(lsp_cfgs.formatters) do
        table.insert(fmts, fmt_cfg.name)
        if fmt_cfg["config"] ~= nil and next(fmt_cfg.config) ~= nil then
          formatters[fmt_cfg.name] = fmt_cfg.config
        end
      end
      formatters_by_ft[lang] = fmts
      if lang == "javascript" then
        formatters_by_ft["javascriptreact"] = fmts
        formatters_by_ft["typescript"] = fmts
        formatters_by_ft["typescriptreact"] = fmts
      end
    end
  end
  -- local table_dump = require("util.table_dump")
  -- vim.print(table_dump(formatters_by_ft))
  -- vim.print(table_dump(formatters))
end

get_configs()

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  local ok, conform = pcall(require, "conform")
  if not ok then
    vim.notify("Missing conform, aborting format")
    return
  end
  conform.format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

local function show_autoformat_state(text)
  vim.notify(
    "format on save: " .. text
    -- .. "\n- buffer: "
    -- .. (vim.b.disable_autoformat and "off" or "on")
    -- .. "\n- global: "
    -- .. (vim.g.disable_autoformat and "off" or "on")
  )
end

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
  show_autoformat_state("disable" .. (args.bang and " (buffer)" or ""))
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function(args)
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
  show_autoformat_state("enable" .. (args.bang and " (buffer)" or ""))
end, {
  desc = "Re-enable autoformat-on-save",
})

return {
  -- Autoformatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader><S-f>",
        "<cmd>Format<CR>",
        -- function()
        --   require("conform").format({ async = true }, function(err)
        --     if not err then
        --       local mode = vim.api.nvim_get_mode().mode
        --       if vim.startswith(string.lower(mode), "v") then
        --         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
        --       end
        --     end
        --   end)
        -- end,
        mode = "",
        desc = "Format buffer",
      },
      {
        "<leader>mf",
        function()
          if vim.g.disable_autoformat then
            vim.cmd("FormatEnable")
          else
            vim.cmd("FormatDisable")
          end
        end,
        mode = "n",
        desc = "Toggle global format on save",
      },
      {
        "<localleader>mf",
        function()
          if vim.b.disable_autoformat then
            vim.cmd("FormatEnable")
          else
            vim.cmd("FormatDisable!")
          end
        end,
        mode = "n",
        desc = "Toggle buffer format on save",
      },
    },
    opts = {
      log_level = vim.log.levels.DEBUG,
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Set up format-on-save
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        -- global takes priority
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      formatters_by_ft = formatters_by_ft,
      formatters = formatters,
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.g.disable_autoformat = false
      vim.b.disable_autoformat = false
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- "williamboman/mason.nvim",
      -- "williamboman/mason-lspconfig.nvim",

      {
        "j-hui/fidget.nvim",
        opts = {
          notification = {
            window = {
              winblend = 0,
            },
          },
        },
      },

      { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },

      -- {
      --   "rachartier/tiny-inline-diagnostic.nvim",
      --   config = function()
      --     require("tiny-inline-diagnostic").setup()
      --   end,
      -- },

      {
        "aznhe21/actions-preview.nvim",
        dependencies = { { "nvim-telescope/telescope.nvim" } },
        config = function()
          require("actions-preview").setup({
            telescope = require("telescope.themes").get_ivy({ winblend = 0 }),
          })
        end,
      },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      -- Don't do LSP stuff if we're in Obsidian Edit mode
      if vim.g.obsidian then
        return
      end

      local capabilities = nil
      if pcall(require, "blink.cmp") then
        capabilities = require("blink.cmp").get_lsp_capabilities()
      elseif pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      local lspconfig = require("lspconfig")

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        lspconfig[name].setup(config)
      end

      local disable_semantic_tokens = {
        lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          local settings = servers[client.name]
          if type(settings) ~= "table" then
            settings = {}
          end

          local builtin = require("telescope.builtin")

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0, desc = "Goto/List definition" })
          vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = 0, desc = "List references" })
          vim.keymap.set(
            "n",
            "gO",
            builtin.lsp_document_symbols,
            { buffer = 0, desc = "List document symbols (buffer)" }
          )
          vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = 0, desc = "Goto/List implementation" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
          -- vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
          vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover()
          end, { buffer = 0, desc = "Symbol information" })
          -- vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { buffer = 0 })
          -- vim.keymap.set("i", "<C-l>", vim.lsp.buf.signature_help, { buffer = 0 })
          vim.keymap.set("n", "gK", function()
            vim.lsp.buf.signature_help()
          end, { buffer = 0, desc = "Signature Help (Full)" })
          vim.keymap.set("i", "<C-s>", function()
            vim.lsp.buf.signature_help()
          end, { buffer = 0 })

          vim.keymap.set("n", "grn", vim.lsp.buf.rename, { buffer = 0, desc = "Rename symbol" })
          vim.keymap.set(
            { "n", "v" },
            "gra",
            require("actions-preview").code_actions,
            { buffer = 0, desc = "LSP Code Action" }
          )
          -- vim.keymap.set("n", "<leader>wd", builtin.lsp_document_symbols, { buffer = 0 })

          -- vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = 0 })
          vim.keymap.set("n", "gl", function()
            vim.diagnostic.open_float({ border = "rounded", max_height = 25, max_width = 120 })
          end, { buffer = 0 })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Override server capabilities
          if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
          end
        end,
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      require("lsp_lines").setup()

      local icon = require("util.icon")

      local severity = vim.diagnostic.severity

      local diag_config = {
        signs = {
          text = {
            [severity.ERROR] = icon.lsp_diagnostics_sign[severity.ERROR],
            [severity.WARN] = icon.lsp_diagnostics_sign[severity.WARN],
            [severity.INFO] = icon.lsp_diagnostics_sign[severity.INFO],
            [severity.HINT] = icon.lsp_diagnostics_sign[severity.HINT],
          },
          numhl = {
            [severity.ERROR] = "DiagnosticSignError",
            [severity.WARN] = "DiagnosticSignWarn",
            [severity.INFO] = "DiagnosticSignInfo",
            [severity.HINT] = "DiagnosticSignHint",
          },
        },
        update_in_insert = true,
      }
      vim.diagnostic.config(vim.tbl_extend("force", diag_config, { virtual_text = false, virtual_lines = false }))

      vim.keymap.set("", "gL", function()
        local config = vim.diagnostic.config() or { virtual_lines = false }
        if config.virtual_lines then
          vim.diagnostic.config(vim.tbl_extend("force", diag_config, { virtual_text = false, virtual_lines = false }))
        else
          vim.diagnostic.config(vim.tbl_extend("force", diag_config, { virtual_text = false, virtual_lines = true }))
        end
      end, { desc = "Toggle lsp_lines" })
      diag_vline_transparent()
    end,
  },
}
