-- Float Steam and keep its windows fully opaque.
o.window("steam", { float = true, opacity = "1 1", idle_inhibit = "fullscreen" })
o.window({ class = "steam", title = "Steam" }, { center = true, size = { 1100, 700 } })
o.window({ class = "steam", title = "Friends List" }, { size = { 460, 800 } })
