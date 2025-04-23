local wezterm = require 'wezterm'
local act = wezterm.action

local io = require 'io';
local os = require 'os';

local session_manager = require 'wezterm-session-manager/session-manager'

---------- Tab Titles ----------
local box_types = { outline = 'box_outline', filled = 'box' }
local box = function(num, type)
  if num > 10 then
    return (type == box_types.filled and "[" .. num .. "]" or num)
  else
    return wezterm.nerdfonts['md_numeric_' .. num .. '_' .. type]
  end
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
  'liga=0', 'dlig=1', 'calt=1', 'clig=1', 'case=1', 'ccmp=1', 'ss01=1',
}

local codelia = function(overrides)
  local font = {
    family = 'Codelia Ligatures',
    harfbuzz_features = codelia_font_features,
  }
  for k,v in pairs(overrides) do font[k] = v end
  return wezterm.font_with_fallback {
    font,
    'Hack Bold Nerd Font Complete Mono',
  }
end

---------- Misc Helpers ----------
local scrollback_lines = 10000
wezterm.on("trigger-vim-with-scrollback", function(window, pane)
  -- Retrieve the current viewport's text.
  -- Pass an optional number of lines (eg: 2000) to retrieve
  -- that number of lines starting from the bottom of the viewport
  local scrollback = pane:get_logical_lines_as_text(scrollback_lines);

  -- Create a temporary file to pass to vim
  local name = os.tmpname();
  local f = io.open(name, "w+");
  f:write(scrollback);
  f:flush();
  f:close();

  -- Open a new window running vim and tell it to open the file
  window:perform_action(
    wezterm.action{
      SpawnCommandInNewWindow={args={"vim", name}}
    },
    pane
  )

  -- wait "enough" time for vim to read the file before we remove it.
  -- The window creation and process spawn are asynchronous
  -- wrt. running this script and are not awaitable, so we just pick
  -- a number.
  wezterm.sleep_ms(1000);
  os.remove(name);
end)

---------- Session Management ----------
wezterm.on("save_session", function(window) session_manager.save_state(window) end)
wezterm.on("load_session", function(window) session_manager.load_state(window) end)
wezterm.on("restore_session", function(window) session_manager.restore_state(window) end)

---------- Default Shell ----------
local file_exists = function(name)
   local f = io.open(name, "r")
   return f ~= nil and io.close(f)
end
local homebrew_bash = "/opt/homebrew/bin/bash"

---------- Config ----------
local config = {
  default_prog = {
    file_exists(homebrew_bash) and homebrew_bash or "/bin/bash"
  },
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
  font_dirs = { 'fonts' }, -- include ~/.config/wezterm/fonts; this _may_ shadow inbuilt fonts though
  font = wezterm.font_with_fallback {
    {
      family = 'Codelia Ligatures',
      weight = 'Medium',
      harfbuzz_features = codelia_font_features,
    },
    "Symbols Nerd Font Mono", -- intended to refer to the local fallback/override nerdfont
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

    -- Scrollback
    {
      key = 'k',
      mods = 'SUPER',
      action = act.Multiple {
        act.ClearScrollback 'ScrollbackAndViewport',
        act.SendKey { key = 'l', mods = 'CTRL' },
      },
    },
    {
      key = 'e',
      mods = 'SUPER',
      action=wezterm.action{EmitEvent="trigger-vim-with-scrollback"},
    },

    -- Sessions
    {key = "S", mods = "SUPER|SHIFT", action = wezterm.action{EmitEvent = "save_session"}},
    {key = "L", mods = "SUPER|SHIFT", action = wezterm.action{EmitEvent = "load_session"}},
    {key = "R", mods = "SUPER|SHIFT", action = wezterm.action{EmitEvent = "restore_session"}},
  },

  mouse_bindings = {
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
      event={Up={streak=1, button="Left"}},
      mods="NONE",
      action=act.CompleteSelection("PrimarySelection"),
    },

    -- and make Super-Click open hyperlinks
    {
      event={Up={streak=1, button="Left"}},
      mods="SUPER",
      action=act.OpenLinkAtMouseCursor,
    },

    -- Disable the 'Down' event of SUPER-Click to avoid weird program behaviors
    {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'SUPER',
      action = act.Nop,
    }
  },

  ---------- Misc ----------
  audible_bell = "Disabled",
  visual_bell = {
    fade_in_duration_ms = 15,
    fade_out_duration_ms = 75,
    target = 'BackgroundColor',
  },

  scrollback_lines = scrollback_lines,

  check_for_updates_interval_seconds = 604800,
}
return config
