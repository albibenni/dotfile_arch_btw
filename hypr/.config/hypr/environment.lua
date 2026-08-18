-- Migrated from envs.conf. UWSM owns session-wide environment setup; these
-- values remain here because they are Hyprland-specific runtime preferences.
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("LIBINPUT_QUIRK_ALWAYS_POLL", "1")
hl.env("XCOMPOSEFILE", os.getenv("HOME") .. "/.XCompose")

hl.config({
  xwayland = { force_zero_scaling = true },
  ecosystem = { no_update_news = true },
})
