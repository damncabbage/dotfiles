local wezterm = require 'wezterm'

wezterm.on(
  'format-tab-title',
  function(tab)
    return ' ' .. tab.tab_index + 1 .. ' '
  end
)

return {
  font = wezterm.font('Codelia Ligatures'),
  font_size = 14.0,
  use_cap_height_to_scale_fallback_fonts = true,

  color_scheme = 'Fairyfloss',
  colors = {
    foreground = '#F8F8F2',
    background = '#282634',

    ansi = {
      "#040303",
      "#f92672",
      "#c2ffdf",
      "#e6c000",
      "#c2ffdf",
      "#ffb8d1",
      "#c5a3ff",
      "#f8f8f0"
    },
    brights = {
      "#6090cb",
      "#ff857f",
      "#c2ffdf",
      "#ffea00",
      "#c2ffdf",
      "#ffb8d1",
      "#c5a3ff",
      "#f8f8f0"
    }
  },

  keys = {
    { key = 'LeftArrow', mods = 'SUPER', action = wezterm.action.ActivateTabRelative(-1) },
    { key = 'RightArrow', mods = 'SUPER', action = wezterm.action.ActivateTabRelative(1) },
    { key = 'LeftArrow', mods = 'SUPER|SHIFT', action = wezterm.action.MoveTabRelative(-1) },
    { key = 'RightArrow', mods = 'SUPER|SHIFT', action = wezterm.action.MoveTabRelative(1) },
  }
}
