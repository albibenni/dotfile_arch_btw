-- Extra autostart processes.
o.launch_on_start("~/.config/hypr/scripts/set-monitor.sh")
o.exec_on_start("gsettings set org.gnome.desktop.interface text-scaling-factor 1.0")
