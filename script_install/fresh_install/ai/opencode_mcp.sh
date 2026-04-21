#!/bin/bash

# Colors and formatting
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

SETTINGS_FILE="$HOME/.config/opencode/opencode.jsonc"

# The new configuration to be written (JSONC supports comments and trailing commas)
NEW_CONFIG='{
  "$schema": "https://opencode.ai/config.json",
  "autoupdate": true,
  "theme": "system",
  "plugin": ["opencode-gemini-auth@latest"],
  "provider": {
    "moonshot": {
      "options": {
        "apiKey": "YOUR_MOONSHOT_API_KEY"
      },
      "models": {
        "kimi-k2.5": {
          "name": "Kimi 2.5"
        },
        "kimi-k2-thinking": {
          "name": "Kimi Reasoning"
        }
      }
    }
  },
  "model": "moonshot/kimi-k2.5",
  "mcp": {
    // Search the web with grep.app
    "grep": {
      "type": "remote",
      "url": "https://mcp.grep.app",
      "enabled": true
    },
    // RAG and documentation search via Upstash Context7
    "upstash-context7": {
      "type": "local",
      "command": [
        "env",
        "CONTEXT7_API_KEY=YOUR-API-KEY",
        "/home/albibenni/.local/share/fnm/aliases/default/bin/npx",
        "-y",
        "@upstash/context7-mcp@latest"
      ],
      "enabled": true
    }
  }
}'

# Check if the file exists and has content
if [ -s "$SETTINGS_FILE" ]; then
    echo -e "${YELLOW}${BOLD}⚠️  WARNING: Existing Configuration Detected${NC}"
    echo -e "File: ${BOLD}$SETTINGS_FILE${NC}"

    if grep -q "mcp" "$SETTINGS_FILE"; then
        echo -e "   • Found existing ${YELLOW}mcp${NC} entries."
    fi

    echo

    echo -e "${MAGENTA}${BOLD}CURRENT CONFIGURATION:${NC}"
    echo -e "${MAGENTA}$(cat "$SETTINGS_FILE")${NC}"
    echo

    echo -e "${CYAN}${BOLD}NEW CONFIGURATION (OVERWRITE):${NC}"
    echo -e "${CYAN}$NEW_CONFIG${NC}"
    echo

    echo -e "${RED}${BOLD}🚨 This will PERMANENTLY REPLACE your current settings.${NC}"
    read -p "Are you sure you want to continue? (y/N): " response
    echo

    if [[ ! "$response" =~ ^[yY]$ ]]; then
        echo -e "${YELLOW}Operation cancelled. No changes were made.${NC}"
        exit 1
    fi
fi

# Ensure the config directory exists
mkdir -p "$(dirname "$SETTINGS_FILE")"

# Write the configuration to opencode.jsonc
echo "$NEW_CONFIG" >"$SETTINGS_FILE"

echo -e "${GREEN}✅ OpenCode MCP settings have been written to:${NC} $SETTINGS_FILE"
