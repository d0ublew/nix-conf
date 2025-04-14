local transparent = function()
  vim.api.nvim_set_hl(0, "SnacksNormal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "SnacksNormalNC", { bg = "NONE" })
end

local aug = vim.api.nvim_create_augroup("d0ublew_snacks", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    transparent()
  end,
  pattern = "snacks_terminal",
  group = aug,
})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    transparent()
  end,
  group = aug,
})

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
      input = { enabled = true, relative = "cursor" },
      picker = {
        enabled = true,
        -- ui_select = true
      },
      terminal = {
        enabled = true,
        bo = {
          filetype = "snacks_terminal",
        },
        wo = {},
        keys = {
          q = "hide",
          gf = function(self)
            local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
            if f == "" then
              vim.notify("No file under cursor", vim.log.levels.WARN)
            else
              self:hide()
              vim.schedule(function()
                vim.cmd("e " .. f)
              end)
            end
          end,
          term_normal = {
            "<esc>",
            function(self)
              self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
              if self.esc_timer:is_active() then
                self.esc_timer:stop()
                vim.cmd("stopinsert")
              else
                self.esc_timer:start(200, 0, function() end)
                return "<esc>"
              end
            end,
            mode = "t",
            expr = true,
            desc = "Double escape to normal mode",
          },
        },
      },
    },
    keys = {
      { "<leader>z", "<cmd>lua Snacks.zen()<CR>", "Toggle zen mode" },
      {
        "<leader><space>",
        function()
          Snacks.terminal(nil, { start_insert = false, auto_insert = false })
        end,
        "Snacks terminal",
      },
    },
  },
}
