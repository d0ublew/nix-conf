require("config.autocmds")
require("config.colorscheme")
require("config.keymaps")
require("config.option")
require("config.clipboard")

vim.cmd([[ command! W execute 'lua require("util.sudo.write")("!")' ]])
