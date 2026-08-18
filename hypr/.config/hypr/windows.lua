-- Personal rules migrated from windows.conf and the app-specific rules that
-- are still relevant with Quattro's Lua configuration.
o.window(".*", { suppress_event = "maximize" })
o.window(".*", { opacity = "0.99 0.98" })

o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

o.window("(Share|localsend)", { float = true, center = true })
o.window("org.gnome.Calculator", { float = true })
o.window("com.libretro.RetroArch", { fullscreen = true, opacity = "1 1", idle_inhibit = "fullscreen" })
o.window("steam", { float = true, opacity = "1 1", idle_inhibit = "fullscreen" })
o.window({ class = "steam", title = "Steam" }, { center = true, size = { 1100, 700 } })
o.window({ class = "steam", title = "Friends List" }, { size = { 460, 800 } })
o.window("org.omarchy.screensaver", { fullscreen = true, float = true, animation = "slide" })
