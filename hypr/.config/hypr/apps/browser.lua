-- Browser tags and per-browser opacity overrides.
o.window("((google-)?[cC]hrom(e|ium)|[bB]rave-browser|[mM]icrosoft-edge|Vivaldi-stable|helium)", { tag = "+chromium-based-browser" })
o.window("([fF]irefox|zen|librewolf)", { tag = "+firefox-based-browser" })
o.window({ tag = "chromium-based-browser" }, { tile = true, opacity = "1 0.99" })
o.window({ tag = "firefox-based-browser" }, { opacity = "1 0.99" })

-- Video and Zoom windows stay fully opaque.
o.window({ initial_title = "((?i)(?:[a-z0-9-]+\\.)*youtube\\.com_/|app\\.zoom\\.us_/wc/home)" }, { opacity = "1 1" })
