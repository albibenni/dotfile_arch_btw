#!/bin/bash

# Colors and formatting
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Antigravity uses a separate mcp_config.json file
CONFIG_DIR="$HOME/.antigravity"
SETTINGS_FILE="$CONFIG_DIR/mcp_config.json"

# Source environment variables if they exist to get CONTEXT7_API_KEY
BASH_SECRETS="$HOME/dotfiles/bash/.config/bash/bash_envs_secrets.sh"

[ -f "$BASH_SECRETS" ] && source "$BASH_SECRETS"

# The new configuration to be written
# Note: "url" field is now "serverUrl" in Antigravity
NEW_CONFIG=$(
    cat <<EOF
{
  "mcpServers": {
    "grep": {
      "serverUrl": "https://mcp.grep.app",
      "type": "http"
    },
    "upstash-context7": {
      "command": "/home/albibenni/.local/share/fnm/aliases/default/bin/npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY:-}"
      }
    }
  }
}
EOF
)

# Check if the file exists and has content
if [ -s "$SETTINGS_FILE" ]; then
    echo -e "${YELLOW}${BOLD}⚠️  WARNING: Existing Antigravity MCP Configuration Detected${NC}"
    echo -e "File: ${BOLD}$SETTINGS_FILE${NC}"

    echo
    echo -e "${MAGENTA}${BOLD}CURRENT CONFIGURATION:${NC}"
    echo -e "${MAGENTA}$(cat "$SETTINGS_FILE")${NC}"
    echo

    echo -e "${CYAN}${BOLD}NEW CONFIGURATION (OVERWRITE):${NC}"
    echo -e "${CYAN}$NEW_CONFIG${NC}"
    echo

    echo -e "${RED}${BOLD}🚨 This will PERMANENTLY REPLACE your current Antigravity MCP settings.${NC}"
    read -p "Are you sure you want to continue? (y/N): " response
    echo

    if [[ ! "$response" =~ ^[yY]$ ]]; then
        echo -e "${YELLOW}Operation cancelled. No changes were made.${NC}"
        exit 1
    fi
fi

# Ensure the .antigravity directory exists
mkdir -p "$CONFIG_DIR"

# Write the MCP configuration
echo "$NEW_CONFIG" >"$SETTINGS_FILE"

echo -e "${GREEN}✅ Antigravity MCP settings have been written to:${NC} $SETTINGS_FILE"
echo -e "${CYAN}Tip: Run 'agy' to start using the new configuration.${NC}"
