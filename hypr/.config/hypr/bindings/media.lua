-- Port of bindings/media.conf.
for key, binding in pairs({
  XF86AudioRaiseVolume = { "Volume up", "omarchy-audio-output-volume raise" },
  XF86AudioLowerVolume = { "Volume down", "omarchy-audio-output-volume lower" },
  XF86AudioMute = { "Mute", "omarchy-audio-output-volume mute-toggle" },
  XF86AudioMicMute = { "Mute microphone", "omarchy-audio-input-mute" },
  XF86MonBrightnessUp = { "Brightness up", "omarchy-brightness-display +5%" },
  XF86MonBrightnessDown = { "Brightness down", "omarchy-brightness-display 5%-" },
}) do
  o.bind(key, binding[1], binding[2], { locked = true, repeating = true })
end
for key, binding in pairs({
  ["ALT + XF86AudioRaiseVolume"] = { "Volume up precise", "omarchy-audio-output-volume +1" },
  ["ALT + XF86AudioLowerVolume"] = { "Volume down precise", "omarchy-audio-output-volume -1" },
  ["ALT + XF86MonBrightnessUp"] = { "Brightness up precise", "omarchy-brightness-display +1%" },
  ["ALT + XF86MonBrightnessDown"] = { "Brightness down precise", "omarchy-brightness-display 1%-" },
  XF86AudioNext = { "Next track", "omarchy-shell media next" },
  XF86AudioPause = { "Pause", "omarchy-shell media playPause" },
  XF86AudioPlay = { "Play", "omarchy-shell media playPause" },
  XF86AudioPrev = { "Previous track", "omarchy-shell media previous" },
}) do
  o.bind(key, binding[1], binding[2], { locked = true, repeating = true })
end
o.bind("SUPER + XF86AudioMute", "Switch audio output", "omarchy-audio-output-switch", { locked = true })
