local toggle_transparency = require 'commands.toggle-transparency'

-- toggle-theme fica fora: ele chama um script do tmux via /bin/bash,
-- que não existe no Windows nem foi montado no labs ainda.
local M = {
  toggle_transparency,
}

return M
