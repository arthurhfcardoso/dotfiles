local wezterm = require 'wezterm'
local commands = require 'commands'
local constants = require 'constants'

local config = wezterm.config_builder()

local is_windows = wezterm.target_triple:find 'windows' ~= nil

-- Font settings
config.font_size = 12
-- 1.0 deixa os blocos powerline do oh-my-posh do tamanho exato da linha
config.line_height = 1.0
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

  -- barra de status embaixo, no lugar da do tmux (que não roda no Windows)
  config.hide_tab_bar_if_only_one_tab = false
  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
  config.show_new_tab_button_in_tab_bar = false
  config.status_update_interval = 1000
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

-- Barra de status: processo e pasta atual, no estilo da barra do tmux do Lazar.
-- A pasta chega pelo OSC 7 que o oh-my-posh emite (pwd = "osc7" no tema).
wezterm.on('update-status', function(window, pane)
  local cwd = ''
  local uri = pane:get_current_working_dir()
  if uri then
    local path = type(uri) == 'userdata' and uri.file_path or tostring(uri)
    path = path:gsub('^/(%a:)', '%1')
    cwd = path:match '([^/\\]+)[/\\]*$' or path
  end

  local process = (pane:get_foreground_process_name() or '')
    :match '([^/\\]+)$' or ''
  process = process:gsub('%.exe$', '')

  window:set_left_status(wezterm.format {
    { Foreground = { Color = '#a6e3a1' } },
    { Text = ' ' .. wezterm.nerdfonts.md_console .. ' ' .. window:active_workspace() .. ' ' },
    { Foreground = { Color = '#6c7086' } },
    { Text = '│' },
    { Foreground = { Color = '#eba0ac' } },
    { Text = ' ' .. wezterm.nerdfonts.md_cog .. ' ' .. process .. ' ' },
    { Foreground = { Color = '#6c7086' } },
    { Text = '│' },
    { Foreground = { Color = '#89b4fa' } },
    { Text = ' ' .. wezterm.nerdfonts.md_folder .. ' ' .. cwd .. ' ' },
    { Foreground = { Color = '#6c7086' } },
    { Text = '│' },
  })
end)

-- Custom commands
wezterm.on('augment-command-palette', function()
  return commands
end)

return config
