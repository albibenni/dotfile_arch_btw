-- Keep JetBrains splash screens and floating dialogs unobtrusive and usable.
o.window({ class = "^(jetbrains-.*)$", title = "^(splash)$", float = true }, { tag = "+jetbrains-splash" })
o.window({ tag = "jetbrains-splash" }, { center = true, no_focus = true, border_size = 0 })

o.window({ class = "^(jetbrains-.*)", title = "^()$", float = true }, { tag = "+jetbrains" })
o.window({ tag = "jetbrains" }, { center = true, stay_focused = true, border_size = 0 })
o.window(
  { class = "^(jetbrains-.*)", title = "^()$", float = true },
  { min_size = { "(monitor_w*0.5)", "(monitor_h*0.5)" } }
)

-- Prevent focus flicker from autocomplete and tooltips, and mouse focus takeovers.
o.window({ class = "^(jetbrains-.*)$", title = "^(win.*)$", float = true }, { no_initial_focus = true })
o.window("^(jetbrains-.*)$", { no_follow_mouse = true })
