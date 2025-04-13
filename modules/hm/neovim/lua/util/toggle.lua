local M = {}

local function toggle_bg()
  local curr_bg = vim.api.nvim_get_option_value("background", { scope = "global" })
  if curr_bg == "dark" then
    curr_bg = "light"
    -- vim.cmd([[ colorscheme github_light ]])
  else
    curr_bg = "dark"
    -- vim.cmd([[ colorscheme github_dark ]])
  end
  vim.opt.background = curr_bg
end

M.toggle_bg = toggle_bg

return M
