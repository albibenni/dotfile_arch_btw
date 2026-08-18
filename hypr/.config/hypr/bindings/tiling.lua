-- Port of bindings/tiling.conf.
o.bind("SUPER + W", "Close window", hl.dsp.window.close())
o.bind("CTRL + ALT + DELETE", "Close all windows", "omarchy-hyprland-window-close-all")
o.bind("SUPER + CTRL + F", "Tiled full screen", "omarchy-hyprland-window-tiled-fullscreen-toggle")
o.bind("SUPER + ALT + F", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))
o.bind("SUPER + O", "Pop window out", "omarchy-hyprland-window-pop")
