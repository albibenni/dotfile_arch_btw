#!/bin/bash

# Ensure the .gemini directory exists
mkdir -p "$HOME/.gemini"

# Write the MCP configuration to settings.json
cat <<EOF >"$HOME/.gemini/settings.json"
{
  "security": {
    "auth": {
      "selectedType": "oauth-personal"
    }
  },
  "general": {
    "previewFeatures": true,
    "vimMode": true
  },
  "mcpServers": {
    "grep": {
      "url": "https://mcp.grep.app",
      "type": "http"
    },
    "upstash-context7": {
      "command": "/home/albibenni/.local/share/fnm/aliases/default/bin/npx",
      "args": [
        "-y",
        "@upstash/context7-mcp@latest"
      ],
      "env": {
        "CONTEXT7_API_KEY": ""
      }
    }
  }
}
EOF

echo "Gemini MCP settings have been written to \$HOME/.gemini/settings.json"
