#!/bin/bash

echo "Updating logiops configuration to fix click detection..."
echo ""

# Backup existing config
if [[ -f /etc/logid.cfg ]]; then
    echo "Backing up existing config to /etc/logid.cfg.backup..."
    sudo cp /etc/logid.cfg /etc/logid.cfg.backup
fi

# Copy new config
echo "Installing updated config..."
sudo cp ~/dotfiles/script_install/fixes/logid-updated.cfg /etc/logid.cfg

echo ""
echo "Restarting logiops service..."
sudo systemctl restart logid

echo ""
echo "Checking service status..."
sudo systemctl status logid --no-pager -l

echo ""
echo "Recent logs:"
sleep 1
sudo journalctl -u logid -n 15 --no-pager

echo ""
echo "✓ Configuration updated!"
echo ""
echo "Changes made:"
echo "  • Added explicit pass-through for left/right/middle buttons (type: None)"
echo "  • This prevents logiops from interfering with primary click detection"
echo ""
echo "Now test your screenshot tool - clicks should be detected properly!"
echo ""
echo "If you need to restore the old config:"
echo "  sudo cp /etc/logid.cfg.backup /etc/logid.cfg"
echo "  sudo systemctl restart logid"
