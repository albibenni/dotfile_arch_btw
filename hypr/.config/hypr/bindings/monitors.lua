-- Port of the navigation, workspace, and resize bindings in bindings/monitors.conf.
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
