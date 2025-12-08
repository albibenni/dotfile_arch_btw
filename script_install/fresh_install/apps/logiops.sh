#!/bin/bash

echo "Installing logiops for Logitech MX Master 3..."
echo "Based on: https://hackeradam.com/improve-logitech-mx-master-3-mouse-support-on-arch-linux/"
echo ""

# Install logiops from AUR
yay -S --noconfirm --needed logiops-git

# Create comprehensive configuration for MX Master 3
echo "Creating configuration at /etc/logid.cfg..."
sudo tee /etc/logid.cfg > /dev/null <<'EOF'
devices: (
{
    name: "Logitech MX Master 3 for Mac";

    // SmartShift: Auto-switches between click-to-click and smooth scrolling
    // Lower threshold = switches to smooth scroll easier (range: 0-255)
    smartshift:
    {
        on: true;
        threshold: 20;
    };

    // High-resolution scrolling for smoother experience
    hiresscroll:
    {
        hires: true;
        invert: false;
        target: false;
    };

    // DPI setting (max 4000)
    dpi: 1500;

    // Button mappings
    buttons: (
        // Back button (side button - bottom)
        {
            cid: 0x53;
            action =
            {
                type: "Keypress";
                keys: ["KEY_BACK"];  // Browser back / Alt+Left
            };
        },
        // Forward button (side button - top)
        {
            cid: 0x56;
            action =
            {
                type: "Keypress";
                keys: ["KEY_FORWARD"];  // Browser forward / Alt+Right
            };
        },
        // Thumb/gesture button - with gestures for workspace navigation
        {
            cid: 0xc3;
            action =
            {
                type: "Gestures";
                gestures: (
                    {
                        direction: "None";
                        mode: "OnRelease";
                        action =
                        {
                            type: "Keypress";
                            keys: ["KEY_LEFTMETA", "KEY_W"];  // Hyprland overview / show all windows
                        };
                    },
                    {
                        direction: "Up";
                        mode: "OnRelease";
                        action =
                        {
                            type: "Keypress";
                            keys: ["KEY_LEFTMETA", "KEY_UP"];  // Move to workspace above
                        };
                    },
                    {
                        direction: "Down";
                        mode: "OnRelease";
                        action =
                        {
                            type: "Keypress";
                            keys: ["KEY_LEFTMETA", "KEY_DOWN"];  // Move to workspace below
                        };
                    },
                    {
                        direction: "Left";
                        mode: "OnRelease";
                        action =
                        {
                            type: "Keypress";
                            keys: ["KEY_LEFTMETA", "KEY_LEFT"];  // Move to workspace left
                        };
                    },
                    {
                        direction: "Right";
                        mode: "OnRelease";
                        action =
                        {
                            type: "Keypress";
                            keys: ["KEY_LEFTMETA", "KEY_RIGHT"];  // Move to workspace right
                        };
                    }
                );
            };
        },
        // Top button (mode shift) - Toggle SmartShift
        {
            cid: 0xc4;
            action =
            {
                type: "ToggleSmartshift";
            };
        }
    );
}
);
EOF

# Enable and start the logiops daemon
echo "Enabling and starting logid service..."
sudo systemctl enable logid
sudo systemctl start logid

# Check service status
echo ""
echo "Checking service status..."
sudo systemctl status logid --no-pager

echo ""
echo "✓ logiops installation complete!"
echo ""
echo "Configuration file: /etc/logid.cfg"
echo ""
echo "Button mappings for Hyprland:"
echo "  • Back button (bottom side): Browser back"
echo "  • Forward button (top side): Browser forward"
echo "  • Thumb button: Show all windows (Super+W)"
echo "  • Thumb button + gestures: Workspace navigation"
echo "  • Top button: Toggle SmartShift (smooth/ratchet scroll)"
echo ""
echo "SmartShift: Enabled (threshold: 20)"
echo "DPI: 1500 (max 4000)"
echo "High-res scroll: Enabled"
echo ""
echo "The logid service will auto-start on boot."
echo ""
echo "Useful commands:"
echo "  • Restart after config changes: sudo systemctl restart logid"
echo "  • Check status: sudo systemctl status logid"
echo "  • View logs: sudo journalctl -u logid -f"
echo "  • Edit config: sudo nano /etc/logid.cfg"
