-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.input")
require("hypr.bindings.bindings")
require("hypr.bindings.media")
require("hypr.bindings.monitors")
require("hypr.bindings.clipboard")
require("hypr.bindings.utils")
require("hypr.bindings.tiling")
require("hypr.looknfeel")
require("hypr.autostart")
require("hypr.environment")
require("hypr.windows")
require("hypr.apps.bitwarden")
require("hypr.apps.browser")
require("hypr.apps.davinci-resolve")
require("hypr.apps.jetbrains")
require("hypr.apps.localsend")
require("hypr.apps.pip")
require("hypr.apps.retroarch")
require("hypr.apps.steam")
require("hypr.apps.system")
require("hypr.apps.terminals")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
