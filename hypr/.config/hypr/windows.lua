-- Personal rules migrated from windows.conf and the app-specific rules that
-- are still relevant with Quattro's Lua configuration.
o.window(".*", { suppress_event = "maximize" })
o.window(".*", { opacity = "0.99 0.98" })

o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
