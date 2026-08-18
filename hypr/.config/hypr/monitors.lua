-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Original Omarchy monitor defaults, kept as reference.
-- local omarchy_gdk_scale = 2
-- local omarchy_monitor_scale = "auto"
-- hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })
--
-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })
--
-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

-- Migrated from the pre-Quattro monitor configuration.
hl.env("GDK_SCALE", "2")
hl.monitor({ output = "desc:MNT JAPANNEXT MNT", mode = "3840x1600@60", position = "0x1440", scale = 1 })
hl.monitor({ output = "desc:BNQ BenQ EW3270U JCJ01494019", mode = "3840x2160@60", position = "440x0", scale = 1.5 })
hl.monitor({ output = "desc:Xiaomi Corporation Mi Monitor", mode = "3440x1440@100", position = "0x1440", scale = 1 })
hl.monitor({ output = "desc:LG Electronics LG ULTRAGEAR", mode = "2560x1440@144", position = "1080x560", scale = 1 })
hl.monitor({ output = "desc:LG Electronics LG HDR WFHD", mode = "2560x1080@60", position = "0x0", scale = 1, transform = 1 })
hl.monitor({ output = "desc:Samsung Display Corp. 0x41A0", disabled = true })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
