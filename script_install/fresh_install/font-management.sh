#!/bin/bash

# Create hooks directory
mkdir -p "$HOME/.config/benni/hooks"

# Create font-set hook handler (sample)
cat >"$HOME/.config/benni/hooks/font-set" <<'EOF'
#!/bin/bash

# This hook is called with the name of the font that has just been set.
# $1 = font name

font_name="$1"

# Example: Show the name of the font that was just set.
# notify-send "New font" "Your new font is $font_name"

# Example: Log font changes
# echo "$(date): Font changed to $font_name" >> ~/.config/benni/font-history.log

# Add your custom actions here
EOF

chmod +x "$HOME/.config/benni/hooks/font-set"

echo "✓ benni-hook system setup complete"
echo "  - Dispatcher: ~/.local/share/bin/benni-hook.sh"
echo "  - Hooks directory: ~/.config/benni/hooks/"
echo "  - Sample hook: ~/.config/benni/hooks/font-set"
