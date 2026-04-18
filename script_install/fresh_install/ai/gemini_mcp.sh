#!/bin/bash

SETTINGS_FILE="$HOME/.gemini/settings.json"

# Check if the file exists and has content
if [ -s "$SETTINGS_FILE" ]; then
    echo "Warning: $SETTINGS_FILE already exists and contains configuration."

    echo "--- EXISTING CONFIGURATION ----"

    cat $SETTINGS_FILE

    echo "-------"

    # Check for specific keywords to be more helpful
    if grep -q "mcpServers" "$SETTINGS_FILE"; then
        echo "Existing 'mcpServers' configuration detected."
    fi

    read -p "This script will OVERWRITE your current settings. Continue? (y/N): " response
    if [[ ! "$response" =~ ^[yY]$ ]]; then
        echo "Operation cancelled. No changes were made."
        exit 1
    fi
fi

# Ensure the .gemini directory exists
mkdir -p "$(dirname "$SETTINGS_FILE")"

# Write the MCP configuration to settings.json
cat <<EOF >"$SETTINGS_FILE"
{
  "mcpServers": {
    "grep": {
      "url": "https://mcp.grep.app",
      "type": "http"
    },
    "upstash-context7": {
      "command": "/home/albibenni/.local/share/fnm/aliases/default/bin/npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {
        "CONTEXT7_API_KEY": ""
      }
    }
  }
}
EOF

echo "Gemini MCP settings have been written to $SETTINGS_FILE"
