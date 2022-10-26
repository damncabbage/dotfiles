local wezterm = require 'wezterm'
local act = wezterm.action

-- Helpers
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

return {
  font = wezterm.font('Codelia Ligatures'),
  font_size = 14.0,
  use_cap_height_to_scale_fallback_fonts = true,

  color_scheme = 'tokyonight-storm',
  --color_scheme = 'Fairyfloss',
  --colors = {
  --  foreground = '#F8F8F2',
  --  background = '#282634',

  --  ansi = {
  --    "#040303",
  --    "#f92672",
  --    "#c2ffdf",
  --    "#e6c000",
  --    "#c2ffdf",
  --    "#ffb8d1",
  --    "#c5a3ff",
  --    "#f8f8f0"
  --  },
  --  brights = {
  --    "#6090cb",
  --    "#ff857f",
  --    "#c2ffdf",
  --    "#ffea00",
  --    "#c2ffdf",
  --    "#ffb8d1",
  --    "#c5a3ff",
  --    "#f8f8f0"
  --  }
  --},

  keys = {
    { key = 'LeftArrow', mods = 'SUPER', action = act.ActivateTabRelative(-1) },
    { key = 'RightArrow', mods = 'SUPER', action = act.ActivateTabRelative(1) },

    { key = 'LeftArrow', mods = 'SUPER|SHIFT', action = act.MoveTabRelative(-1) },
    { key = 'RightArrow', mods = 'SUPER|SHIFT', action = act.MoveTabRelative(1) },

    { key = 'LeftArrow', mods = 'SUPER|ALT', action = act.ActivatePaneDirection('Left') },
    { key = 'RightArrow', mods = 'SUPER|ALT', action = act.ActivatePaneDirection('Right') },
    { key = 'UpArrow', mods = 'SUPER|ALT', action = act.ActivatePaneDirection('Up') },
    { key = 'DownArrow', mods = 'SUPER|ALT', action = act.ActivatePaneDirection('Down') },

    { key = 'd', mods = 'SUPER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'D', mods = 'SUPER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    {
      key = 'k',
      mods = 'SUPER',
      action = act.Multiple {
        act.ClearScrollback 'ScrollbackAndViewport',
        act.SendKey { key = 'l', mods = 'CTRL' },
      },
    },
  },
}
