#!/bin/bash

# Colors and formatting
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

SETTINGS_FILE="$HOME/.copilot/mcp-config.json"

# The new configuration to be written
NEW_CONFIG='{
  "mcpServers": {
    "grep": {
      "type": "http",
      "url": "https://mcp.grep.app",
      "tools": ["*"]
    },
    "upstash-context7": {
      "type": "stdio",
      "command": "/home/albibenni/.local/share/fnm/aliases/default/bin/npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {
        "CONTEXT7_API_KEY": "YOUR-API-KEY"
      },
      "tools": ["*"]
    }
  }
}'

# Check if the file exists and has content
if [ -s "$SETTINGS_FILE" ]; then
    echo -e "${YELLOW}${BOLD}⚠️  WARNING: Existing Configuration Detected${NC}"
    echo -e "File: ${BOLD}$SETTINGS_FILE${NC}"

    if grep -q "mcpServers" "$SETTINGS_FILE"; then
        echo -e "   • Found existing ${YELLOW}mcpServers${NC} entries."
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

# Ensure the .copilot directory exists
mkdir -p "$(dirname "$SETTINGS_FILE")"

# Write the MCP configuration to mcp-config.json
echo "$NEW_CONFIG" >"$SETTINGS_FILE"

echo -e "${GREEN}✅ Copilot CLI MCP settings have been written to:${NC} $SETTINGS_FILE"
