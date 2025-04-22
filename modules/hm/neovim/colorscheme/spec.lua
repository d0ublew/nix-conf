local float_transparent = function()
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatTitle", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatFooter", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
end

local aug = vim.api.nvim_create_augroup("d0ublew_colorscheme", { clear = true })

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    float_transparent()
  end,
  group = aug,
})

local function extract_name(fpath)
  local fname = fpath:match("^.+/(.+)$") or fpath
  local name = fname:match("^(.*)%.") or fname
  return name
end

local colorschemes = {}

for _, fpath in ipairs(vim.api.nvim_get_runtime_file("lua/plugins/colorscheme/*.lua", true)) do
  local colorscheme_name = extract_name(fpath)
  local status_ok, colorscheme = pcall(require, "plugins.colorscheme." .. colorscheme_name)
  if status_ok then
    table.insert(colorschemes, colorscheme)
  end
end

vim.inspect(colorschemes)

return colorschemes
