local wezterm = require 'wezterm'
local commands = require 'commands'
local constants = require 'constants'

local config = wezterm.config_builder()

local is_windows = wezterm.target_triple:find 'windows' ~= nil

-- Font settings
config.font_size = 12
config.line_height = 1.2
config.font = wezterm.font_with_fallback {
  {
    family = 'JetBrainsMono Nerd Font',
    harfbuzz_features = { 'calt', 'liga' },
  },
  { family = 'Symbols Nerd Font Mono' },
}

-- Colors
config.color_scheme = 'Catppuccin Mocha'
config.colors = {
  cursor_bg = 'white',
  cursor_border = 'white',
}

-- Appearance
config.cursor_blink_rate = 0
config.window_decorations = 'RESIZE'
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
if is_windows then
  -- no Windows o snap (Win+Shift+setas) esconde o topo da janela sem
  -- barra de título; o padding devolve essa faixa
  config.window_padding.top = 12
end
config.window_background_image = constants.bg_image
config.macos_window_background_blur = 40
if is_windows then
  -- equivalente Windows do blur do macOS; só aparece com opacidade < 1
  config.win32_system_backdrop = 'Acrylic'
end

-- Miscellaneous settings
config.max_fps = 120
if is_windows then
  config.front_end = 'WebGpu'
else
  config.prefer_egl = true
end

-- Shell e conexão com o labs (Fedora via Tailscale)
if is_windows then
  config.default_prog = { 'pwsh', '-NoLogo' }
  config.launch_menu = {
    { label = 'labs (Fedora)', args = { 'ssh', 'mrlabs@labs' } },
    { label = 'PowerShell', args = { 'pwsh', '-NoLogo' } },
  }
  config.keys = {
    -- Ctrl+Shift+L abre uma aba nova já dentro do labs
    {
      key = 'L',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.SpawnCommandInNewTab {
        args = { 'ssh', 'mrlabs@labs' },
      },
    },
  }
end

-- Custom commands
wezterm.on('augment-command-palette', function()
  return commands
end)

return config
