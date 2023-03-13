local wezterm = require 'wezterm'
local act = wezterm.action

---------- Tab Titles ----------
-- TODO: for some reason wezterm.nerdfonts.mdi_numeric_#_outline (et al) are missing in this version.
local box_glyphs = {
  filled = { [0] = '', '', '', '', '', '', '', '', '', '' },
  outline = { [0] = '', '', '', '', '', '', '', '', '', '' },
}
local box_types = { outline = 'outline', filled = 'filled' }
local box = function(num, type)
  return box_glyphs[type][num] or ('[' .. num .. ']')
end

wezterm.on(
  'format-tab-title',
  function(tab)
    box_type = tab.is_active and box_types.filled or box_types.outline
    return box(tab.tab_index + 1, box_type) .. ' ' .. tab.active_pane.title .. ' '
  end
)

---------- Font Helpers ----------
local codelia_font_features = {
  -- See: https://tosche.net/media/pages/fonts/codelia/7fbd7c0aca-1664387056/codelia9.svg
  'liga=1', 'dlig=1', 'calt=1', 'clig=1', 'case=1', 'ccmp=1', 'ss01=1',
}

local codelia = function(overrides)
  local font = {
    family = 'Codelia Ligatures',
    harfbuzz_features = codelia_font_features,
  }
  for k,v in pairs(overrides) do font[k] = v end
  return wezterm.font(font)
end


---------- Config ----------
return {
  font_rules = {
    {
      italic = true,
      font = codelia { weight = 'Medium', style = 'Italic' },
    },
    {
      italic = true,
      intensity = 'Bold',
      font = codelia { weight = 'Bold', style = 'Italic' },
    },
    {
      italic = false,
      intensity = 'Bold',
      font = codelia { weight = 'Bold' },
    },
    {
      italic = false,
      intensity = 'Half',
      font = codelia { weight = 'Medium' },
    },
    {
      italic = true,
      intensity = 'Half',
      font = codelia { weight = 'Medium', style = 'Italic' },
    },
  },
  font = wezterm.font {
    family = 'Codelia Ligatures',
    weight = 'Medium',
    harfbuzz_features = font_features,
  },
  font_size = 14.0,
  use_cap_height_to_scale_fallback_fonts = true,

  ---------- Colours ----------
  -- Previously:
  --   color_scheme = 'tokyonight-storm',
  --   color_scheme = 'Fairyfloss',
  -- Now:
  colors = {
    ------
    -- Copy-paste-modification of:
    -- https://github.com/wez/wezterm/blob/main/assets/colors/tokyonight-storm.toml
    ------
    foreground = '#d3ddff', -- MODIFIED
    background = "#25283B", -- MODIFIED

    ansi = {
      '#1d202f', -- black
      '#f7768e', -- red
      '#6e9e3a', -- green -- MODIFIED
      '#e0af68', -- yellow
      '#6a92e7', -- blue
      '#bb9af7', -- purple
      '#5dafdf', -- cyan  -- MODIFIED
      '#c9d1f6', -- white -- MODIFIED
    },

    brights = {
      '#414868', -- black
      '#f7768e', -- red
      '#9ece6a', -- green
      '#e0af68', -- yellow
      '#7aa2f7', -- blue
      '#bb9af7', -- purple
      '#7dcfff', -- cyan
      '#c0caf5', -- white
    },

    cursor_bg = '#c0caf5',
    cursor_border = '#c0caf5',
    cursor_fg = '#1d202f',
    selection_bg = '#364a82',
    selection_fg = '#c0caf5',
    ------
    -- /tokyonight-storm
    ------

    visual_bell = '#2a2d43',
  },

  ---------- Keys ----------
  keys = {
    -- Tabs
    { key = 'LeftArrow', mods = 'SUPER', action = act.ActivateTabRelative(-1) },
    { key = 'RightArrow', mods = 'SUPER', action = act.ActivateTabRelative(1) },

    { key = 'LeftArrow', mods = 'SUPER|SHIFT', action = act.MoveTabRelative(-1) },
    { key = 'RightArrow', mods = 'SUPER|SHIFT', action = act.MoveTabRelative(1) },

    -- Panes
    { key = 'LeftArrow', mods = 'SUPER|ALT', action = act.ActivatePaneDirection('Left') },
    { key = 'RightArrow', mods = 'SUPER|ALT', action = act.ActivatePaneDirection('Right') },
    { key = 'UpArrow', mods = 'SUPER|ALT', action = act.ActivatePaneDirection('Up') },
    { key = 'DownArrow', mods = 'SUPER|ALT', action = act.ActivatePaneDirection('Down') },

    { key = 'LeftArrow', mods = 'SUPER|ALT|SHIFT', action = act.RotatePanes('CounterClockwise') },
    { key = 'RightArrow', mods = 'SUPER|ALT|SHIFT', action = act.RotatePanes('CounterClockwise') },

    { key = 'd', mods = 'SUPER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'D', mods = 'SUPER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    { key = '>', mods = 'SUPER|ALT|SHIFT', action = act.AdjustPaneSize { 'Right', 3 } },
    { key = '<', mods = 'SUPER|ALT|SHIFT', action = act.AdjustPaneSize { 'Left', 3 } },

    -- Misc
    {
      key = 'k',
      mods = 'SUPER',
      action = act.Multiple {
        act.ClearScrollback 'ScrollbackAndViewport',
        act.SendKey { key = 'l', mods = 'CTRL' },
      },
    },
  },

  ---------- Misc ----------
  audible_bell = "Disabled",
  visual_bell = {
    fade_in_duration_ms = 15,
    fade_out_duration_ms = 75,
    target = 'BackgroundColor',
  },

  check_for_updates_interval_seconds = 604800,
}
