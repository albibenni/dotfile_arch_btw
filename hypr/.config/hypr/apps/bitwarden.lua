-- Keep Bitwarden out of screen sharing and use the shared floating-window rules.
o.window("^(Bitwarden)$", { no_screen_share = true, tag = "+floating-window" })
