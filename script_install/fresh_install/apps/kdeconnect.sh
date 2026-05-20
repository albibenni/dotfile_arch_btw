#!/bin/bash

echo "Installing KDE Connect..."

# Install KDE Connect (official repos)
sudo pacman -S --needed --noconfirm kdeconnect

echo ""
echo "✓ KDE Connect installation complete!"
echo ""
echo "--- IMPORTANT SETUP FOR CALLS ---"
echo "On modern systems with PipeWire, KDE Connect + Bluetooth is all you need."
echo ""
echo "1. ANDROID PERMISSIONS (Android 10+):"
echo "   • Open KDE Connect on your phone."
echo "   • Select your PC -> Plugin Settings -> Telephony."
echo "   • Grant all requested permissions (Call logs, Phone, etc.)."
echo "   • Ensure 'Display over other apps' is ALLOWED for KDE Connect in system settings."
echo ""
echo "2. BLUETOOTH PAIRING (Mandatory for Audio):"
echo "   • Pair your phone with this PC via Bluetooth."
echo "   • On your phone, go to the PC's Bluetooth settings and ensure 'Phone calls' is ON."
echo "   • When a call is active, PipeWire will automatically route the audio."
echo ""
echo "3. THE 'ANSWER' BUTTON:"
echo "   • On Android 10+, Google restricts answering calls to the 'Default Dialer'."
echo "   • If the 'Answer' button is missing on your PC notification, you may need to set"
echo "     KDE Connect as your 'Digital Assistant' app in Android settings."
echo "   • Even if the button is missing, answering on the phone will still route"
echo "     the audio to your PC speakers automatically via Bluetooth."
echo ""
echo "Note: KDE Connect handles the 'buttons', Bluetooth/PipeWire handles the 'voice'."
echo ""
