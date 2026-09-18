local wezterm = require 'wezterm'

local M = {}

-- config_dir resolve no Windows e no Linux, sem depender de $HOME
local assets = wezterm.config_dir .. '/assets/'

M.bg_blurred_darker = assets .. 'bg-blurred-darker.png'
M.bg_blurred = assets .. 'bg-blurred.png'
M.bg_image = M.bg_blurred_darker

return M
