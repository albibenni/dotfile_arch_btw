-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Active bindings are split to mirror the old bindings/*.conf layout.
require("hypr.bindings.bindings")
require("hypr.bindings.media")
require("hypr.bindings.monitors")
require("hypr.bindings.clipboard")
require("hypr.bindings.utils")
require("hypr.bindings.tiling")

-- Legacy one-file migration retained below as a non-active reference.
if false then

-- Personal bindings migrated from bindings/*.conf. Omarchy defaults are
-- disabled in hyprland.lua, so this is the complete active binding set.

-- Applications
o.bind("SUPER + SHIFT + T", "Terminal", { omarchy = "terminal" })
o.bind("SUPER + SHIFT + F", "File manager", { omarchy = "nautilus" })
o.bind("SUPER + SHIFT + B", "Browser", { omarchy = "browser" })
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", { omarchy = "browser --private" })
o.bind("SUPER + SHIFT + M", "Music", { omarchy = "spotify" })
o.bind("SUPER + CTRL + T", "Activity", { tui = "btop" })
o.bind("SUPER + SHIFT + D", "Docker", { tui = "lazydocker" })
o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian", focus = "^obsidian$" })
o.bind("SUPER + SHIFT + SLASH", "LocalSend", { launch = "localsend", focus = "localsend" })
o.bind("SUPER + CTRL + C", "Claude", { webapp = "https://claude.ai" })
o.bind("SUPER + CTRL + G", "Gemini", { webapp = "https://gemini.google.com/app" })
o.bind("SUPER + SHIFT + C", "Calendar", { webapp = "https://calendar.google.com/" })
o.bind("SUPER + SHIFT + Y", "YouTube", { webapp = "https://youtube.com/", focus = true })
o.bind("SUPER + CTRL + SHIFT + K", "Lock system", "omarchy-system-lock")
o.bind("SUPER + CTRL + SHIFT + T", "Toggle built-in display", "omarchy-hyprland-monitor-internal")

-- Media
o.bind("XF86AudioRaiseVolume", "Volume up", "omarchy-audio-output-volume raise", { locked = true, repeating = true })
o.bind("XF86AudioLowerVolume", "Volume down", "omarchy-audio-output-volume lower", { locked = true, repeating = true })
o.bind("XF86AudioMute", "Mute", "omarchy-audio-output-volume mute-toggle", { locked = true })
o.bind("XF86AudioMicMute", "Mute microphone", "omarchy-audio-input-mute", { locked = true })
o.bind("XF86MonBrightnessUp", "Brightness up", "omarchy-brightness-display +5%", { locked = true, repeating = true })
o.bind("XF86MonBrightnessDown", "Brightness down", "omarchy-brightness-display 5%-", { locked = true, repeating = true })
o.bind("ALT + XF86AudioRaiseVolume", "Volume up precise", "omarchy-audio-output-volume +1", { locked = true, repeating = true })
o.bind("ALT + XF86AudioLowerVolume", "Volume down precise", "omarchy-audio-output-volume -1", { locked = true, repeating = true })
o.bind("ALT + XF86MonBrightnessUp", "Brightness up precise", "omarchy-brightness-display +1%", { locked = true, repeating = true })
o.bind("ALT + XF86MonBrightnessDown", "Brightness down precise", "omarchy-brightness-display 1%-", { locked = true, repeating = true })
o.bind("XF86AudioNext", "Next track", "omarchy-shell media next", { locked = true })
o.bind("XF86AudioPause", "Pause", "omarchy-shell media playPause", { locked = true })
o.bind("XF86AudioPlay", "Play", "omarchy-shell media playPause", { locked = true })
o.bind("XF86AudioPrev", "Previous track", "omarchy-shell media previous", { locked = true })
o.bind("SUPER + XF86AudioMute", "Switch audio output", "omarchy-audio-output-switch", { locked = true })

-- Menus, system controls, and capture
o.bind("SUPER + D", "Menu", "omarchy-menu toggle apps")
o.bind("SUPER + CTRL + E", "Emoji picker", "omarchy-shell shell toggle omarchy.emojis")
o.bind("SUPER + ALT + SPACE", "Omarchy menu", "omarchy-menu toggle root")
o.bind("SUPER + ESCAPE", "System menu", "omarchy-menu toggle system")
o.bind("XF86PowerOff", "Power menu", "omarchy-menu toggle system", { locked = true })
o.bind("SUPER + K", "Show key bindings", "omarchy-menu-keybindings")
o.bind("XF86Calculator", "Calculator", "omacalc")
o.bind_toggle("SUPER + SHIFT + SPACE", "Toggle top bar", "bar")
o.bind("SUPER + CTRL + SPACE", "Theme background menu", "omarchy-menu toggle background")
o.bind("SUPER + SHIFT + CTRL + SPACE", "Theme menu", "omarchy-menu toggle theme")
o.bind("SUPER + BACKSPACE", "Toggle window transparency", "omarchy-hyprland-window-transparency-toggle")
o.bind("SUPER + SHIFT + BACKSPACE", "Toggle workspace gaps", "omarchy-hyprland-window-gaps-toggle")
o.bind("SUPER + comma", "Dismiss last notification", "omarchy-shell notifications dismissOne")
o.bind("SUPER + SHIFT + comma", "Dismiss all notifications", "omarchy-shell notifications dismissAll")
o.bind_toggle("SUPER + CTRL + comma", "Toggle silencing notifications", "notification-silencing")
o.bind("SUPER + ALT + comma", "Invoke last notification", "omarchy-shell notifications invokeLast")
o.bind("SUPER + SHIFT + ALT + comma", "Open notification history", "omarchy-shell notifications showHistory")
o.bind_toggle("SUPER + CTRL + I", "Toggle locking on idle", "idle")
o.bind_toggle("SUPER + CTRL + N", "Toggle nightlight", "nightlight")
o.bind("CTRL + SHIFT + 4", "Screenshot to clipboard", "omarchy-capture-screenshot smart copy")
o.bind("PRINT", "Screenshot", "omarchy-capture-screenshot")
o.bind("SHIFT + PRINT", "Screenshot to clipboard", "omarchy-capture-screenshot smart copy")
o.bind("ALT + PRINT", "Screenrecording", "omarchy-capture-screenrecording --stop-recording || omarchy-menu toggle trigger.capture.screenrecord")
o.bind("SUPER + PRINT", "Color picker", "pkill hyprpicker || hyprpicker -a")
o.bind("SUPER + CTRL + S", "Share", "omarchy-menu toggle share")
o.bind("SUPER + CTRL + B", "Show battery remaining", 'notify-send "󰁹    Battery is at $(omarchy-battery-remaining)%"')
o.bind("SUPER + SHIFT + V", "Clipboard manager", "omarchy-shell shell toggle omarchy.clipboard")

-- Window and workspace management
o.bind("SUPER + W", "Close window", hl.dsp.window.close())
o.bind("CTRL + ALT + DELETE", "Close all windows", "omarchy-hyprland-window-close-all")
o.bind("SUPER + CTRL + F", "Tiled full screen", "omarchy-hyprland-window-tiled-fullscreen-toggle")
o.bind("SUPER + ALT + F", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))
o.bind("SUPER + O", "Pop window out", "omarchy-hyprland-window-pop")

-- SUPER + K is reserved for the keybinding menu, matching the order of the
-- legacy sourced files. Shift + K still moves a window upward.
for key, direction in pairs({ h = "l", l = "r", j = "d" }) do
  o.bind("SUPER + " .. key:upper(), "Move focus " .. direction, hl.dsp.focus({ direction = direction }))
  o.bind("SUPER + SHIFT + " .. key:upper(), "Move window " .. direction, hl.dsp.window.swap({ direction = direction }))
end
o.bind("SUPER + SHIFT + K", "Move window up", hl.dsp.window.swap({ direction = "u" }))

for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  o.bind("SUPER + " .. key, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = tostring(workspace) }))
  o.bind("SUPER + SHIFT + " .. key, "Move window to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace) }))
end

o.bind("SUPER + CTRL + H", "Resize left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
o.bind("SUPER + CTRL + L", "Resize right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
o.bind("SUPER + CTRL + K", "Resize up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))
o.bind("SUPER + CTRL + J", "Resize down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))

-- Disabled Omarchy defaults, ported as a reference. These were not active in
-- the legacy bindings/*.conf setup; remove the leading `--` to opt into one.
--
-- Applications
-- o.bind("SUPER + RETURN", "Terminal", { omarchy = "terminal" })
-- o.bind("SUPER + SHIFT + RETURN", "Browser", { omarchy = "browser" })
-- o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { omarchy = "nautilus-cwd" })
-- o.bind("SUPER + SHIFT + N", "Editor", { omarchy = "editor" })
-- o.bind("SUPER + ALT + RETURN", "Tmux", { omarchy = "terminal-tmux" })
-- o.bind("SUPER + CTRL + RETURN", "Herdr", { omarchy = "terminal-herdr" })
-- o.bind("SUPER + SHIFT + G", "Signal", { omarchy = "signal" })
-- o.bind("SUPER + SHIFT + W", "Omawrite", { launch = "omawrite" })
-- o.bind("SUPER + SHIFT + A", "ChatGPT", { webapp = "https://chatgpt.com" })
-- o.bind("SUPER + SHIFT + E", "Email", { webapp = "https://app.hey.com" })
-- o.bind("SUPER + SHIFT + ALT + E", "New email", { webapp = "https://app.hey.com/messages/new?display=standalone&new_window=true" })
-- o.bind("SUPER + SHIFT + ALT + G", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })
-- o.bind("SUPER + SHIFT + P", "Google Photos", { webapp = "https://photos.google.com/", focus = true })
-- o.bind("SUPER + SHIFT + S", "Google Maps", { webapp = "https://maps.google.com/", focus = true })
--
-- Extra media controls
-- o.bind("SHIFT + XF86MonBrightnessUp", "Brightness maximum", "omarchy-brightness-display 100%", { locked = true, repeating = true })
-- o.bind("SHIFT + XF86MonBrightnessDown", "Brightness minimum", "omarchy-brightness-display 1%", { locked = true, repeating = true })
-- o.bind("XF86KbdBrightnessUp", "Keyboard brightness up", "omarchy-brightness-keyboard up", { locked = true, repeating = true })
-- o.bind("XF86KbdBrightnessDown", "Keyboard brightness down", "omarchy-brightness-keyboard down", { locked = true, repeating = true })
-- o.bind_toggle("XF86TouchpadToggle", "Toggle touchpad", "touchpad", { locked = true })
-- o.bind("SHIFT + XF86AudioMute", "Switch audio output", "omarchy-audio-output-switch", { locked = true })
--
-- Menus and panels
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle")
-- o.bind("SUPER + CTRL + O", "Toggle menu", "omarchy-menu toggle toggle")
-- o.bind("SUPER + CTRL + H", "Hardware menu", "omarchy-menu toggle hardware")
-- o.bind("SUPER + ALT + K", "Tmux keybindings", "omarchy-menu-tmux-keybindings")
-- o.bind("SUPER + CTRL + Q", "Calculator", "omacalc")
-- o.bind("SUPER + CTRL + A", "Audio", "omarchy-shell shell toggle omarchy.audio")
-- o.bind("SUPER + CTRL + B", "Bluetooth", "omarchy-shell shell toggle omarchy.bluetooth")
-- o.bind("SUPER + CTRL + D", "Display", "omarchy-shell shell toggle omarchy.monitor")
-- o.bind("SUPER + CTRL + P", "Power", "omarchy-shell shell toggle omarchy.power")
-- o.bind("SUPER + CTRL + L", "Lock system", "omarchy-system-lock")
--
-- Tiling and workspace navigation
-- o.bind("SUPER + J", "Toggle window split", hl.dsp.layout("togglesplit"))
-- o.bind("SUPER + P", "Pseudo window", hl.dsp.window.pseudo())
-- o.bind("SUPER + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
-- o.bind("SUPER + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
-- o.bind("SUPER + LEFT", "Focus on left window", hl.dsp.focus({ direction = "l" }))
-- o.bind("SUPER + RIGHT", "Focus on right window", hl.dsp.focus({ direction = "r" }))
-- o.bind("SUPER + UP", "Focus on above window", hl.dsp.focus({ direction = "u" }))
-- o.bind("SUPER + DOWN", "Focus on below window", hl.dsp.focus({ direction = "d" }))
-- o.bind("SUPER + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
-- o.bind("SUPER + ALT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
-- o.bind("SUPER + TAB", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
-- o.bind("SUPER + SHIFT + TAB", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
-- o.bind("ALT + TAB", "Focus on next window", hl.dsp.window.cycle_next())
-- o.bind("SUPER + mouse:272", "Move window", hl.dsp.window.drag(), { mouse = true })
-- o.bind("SUPER + mouse:273", "Resize window", hl.dsp.window.resize(), { mouse = true })
end
