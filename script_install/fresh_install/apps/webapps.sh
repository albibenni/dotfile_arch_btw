#!/bin/bash

# Ensure the installer script is available
INSTALLER="$HOME/.local/share/bin/install-webapp.sh"

if [ ! -x "$INSTALLER" ]; then
    echo "Error: install-webapp.sh not found or not executable at $INSTALLER"
    exit 1
fi

# Usage: install-webapp.sh "Name" "URL" "Icon_Name_or_URL" [Custom_Exec] [Mime_Types]

# --- Productivity & Communication ---

# Basecamp
"$INSTALLER" "Basecamp" "https://launchpad.37signals.com" "Basecamp.png"

# WhatsApp
"$INSTALLER" "WhatsApp" "https://web.whatsapp.com/" "WhatsApp.png" "launch-or-focus-webapp.sh 'WhatsApp' 'https://web.whatsapp.com/'"

# Telegram
"$INSTALLER" "Telegram" "https://web.telegram.org/k/" "https://raw.githubusercontent.com/walkxcode/dashboard-icons/master/png/telegram.png" "launch-or-focus-webapp.sh 'Telegram' 'https://web.telegram.org/k/'"

# Discord
"$INSTALLER" "Discord" "https://discord.com/channels/@me" "Discord.png" "launch-or-focus-webapp.sh 'Discord' 'https://discord.com/channels/@me'"

# Zoom
"$INSTALLER" "Zoom" "https://app.zoom.us/wc/home" "Zoom.png" "launch-or-focus-webapp.sh 'Zoom' 'https://app.zoom.us/wc/home'" "x-scheme-handler/zoommtg;x-scheme-handler/zoomus"

# --- Google Services ---

"$INSTALLER" "Google Gemini" "https://gemini.google.com/" "Google Gemini.png"
"$INSTALLER" "Google Photos" "https://photos.google.com/" "Google Photos.png"
"$INSTALLER" "Google Contacts" "https://contacts.google.com/" "Google Contacts.png"
"$INSTALLER" "Google Messages" "https://messages.google.com/web/conversations" "Google Messages.png" "launch-or-focus-webapp.sh 'Messages' 'https://messages.google.com/web/conversations'"
"$INSTALLER" "Google Maps" "https://maps.google.com" "Google Maps.png"

# --- Tools & Social ---

"$INSTALLER" "ChatGPT" "https://chatgpt.com/" "ChatGPT.png"
"$INSTALLER" "YouTube" "https://youtube.com/" "YouTube.png"
"$INSTALLER" "GitHub" "https://github.com/" "GitHub.png"
"$INSTALLER" "X" "https://x.com/" "X.png"
"$INSTALLER" "Figma" "https://figma.com/" "Figma.png"
"$INSTALLER" "Fizzy" "https://app.fizzy.do/" "Fizzy.png"

echo "All web apps installed successfully."
