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
