-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.
--
-- See current bindings and descriptions:
--   omarchy menu keybindings --print
--
-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false
--
-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false
--
-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")
--
-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")
--
-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")
--
-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Applications
-- Launch Ghostty directly to avoid Omarchy's xdg-terminal-exec wrapper.
o.bind("SUPER + SHIFT + T", "Terminal", { launch = "ghostty --gtk-single-instance=true" })
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
-- o.bind("SUPER + SHIFT + P", "Google Photos", { webapp = "https://photos.google.com/" })
-- o.bind("SUPER + SHIFT + S", "Google Maps", { webapp = "https://maps.google.com/" })
--
-- Extra media controls
-- o.bind("SHIFT + XF86MonBrightnessUp", "Brightness maximum", "omarchy-brightness-display 100%", { locked = true, repeating = true })
-- o.bind("SHIFT + XF86MonBrightnessDown", "Brightness minimum", "omarchy-brightness-display 1%", { locked = true, repeating = true })
-- o.bind("XF86KbdBrightnessUp", "Keyboard brightness up", "omarchy-brightness-keyboard up", { locked = true })
-- o.bind("XF86KbdBrightnessDown", "Keyboard brightness down", "omarchy-brightness-keyboard down", { locked = true })
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
