-- Monitor configuration and the navigation/workspace bindings formerly kept in
-- monitors.conf and bindings/monitors.conf.
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
--
-- Original Omarchy monitor defaults, kept as reference.
-- local omarchy_gdk_scale = 2
-- local omarchy_monitor_scale = "auto"
-- hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

hl.env("GDK_SCALE", "2")
hl.monitor({ output = "desc:MNT JAPANNEXT MNT", mode = "3840x1600@60", position = "0x1440", scale = 1 })
hl.monitor({ output = "desc:BNQ BenQ EW3270U JCJ01494019", mode = "3840x2160@60", position = "440x0", scale = 1.5 })
hl.monitor({ output = "desc:Xiaomi Corporation Mi Monitor", mode = "3440x1440@100", position = "0x1440", scale = 1 })
hl.monitor({ output = "desc:LG Electronics LG ULTRAGEAR", mode = "2560x1440@144", position = "1080x560", scale = 1 })
hl.monitor({ output = "desc:LG Electronics LG HDR WFHD", mode = "2560x1080@60", position = "0x0", scale = 1, transform = 1 })
hl.monitor({ output = "desc:Samsung Display Corp. 0x41A0", disabled = true })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

local primary_monitor = "HDMI-A-2" -- LG ULTRAGEAR
local secondary_monitor = "HDMI-A-1" -- LG HDR WFHD (rotated)
for workspace = 1, 9 do
  hl.workspace_rule({ workspace = tostring(workspace), monitor = primary_monitor, default = workspace == 1 })
end
hl.workspace_rule({ workspace = "10", monitor = secondary_monitor, default = true })

-- Navigation, workspace, and resize bindings.
for key, direction in pairs({ h = "l", l = "r", j = "d" }) do
  o.bind("SUPER + " .. key:upper(), "Move focus " .. direction, hl.dsp.focus({ direction = direction }))
  o.bind("SUPER + SHIFT + " .. key:upper(), "Move window " .. direction, hl.dsp.window.swap({ direction = direction }))
end
o.bind("SUPER + SHIFT + K", "Move window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + CTRL + SHIFT + H", "Move window left", hl.dsp.window.move({ direction = "left" }), { transparent = true })
for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  o.bind("SUPER + " .. key, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = tostring(workspace) }))
  o.bind("SUPER + SHIFT + " .. key, "Move window to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace) }))
end
o.bind("SUPER + CTRL + H", "Resize left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
o.bind("SUPER + CTRL + L", "Resize right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
o.bind("SUPER + CTRL + K", "Resize up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))
o.bind("SUPER + CTRL + J", "Resize down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))
