#!/bin/bash

# Colors and formatting
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${CYAN}${BOLD}Setting up Italian dictionary and regional formats...${NC}"

# 1. Install Dictionary Packages
echo "Installing English and Italian dictionaries and hyphenation patterns..."
sudo pacman -S --needed --noconfirm \
    hunspell-en_us \
    hyphen-en \
    hunspell-it \
    hyphen-it

# 2. Enable Italian Locale
echo "Enabling it_IT.UTF-8 locale in /etc/locale.gen..."
if grep -q "^#it_IT.UTF-8 UTF-8" /etc/locale.gen; then
    sudo sed -i 's/^#it_IT.UTF-8 UTF-8/it_IT.UTF-8 UTF-8/' /etc/locale.gen
    echo "✓ it_IT.UTF-8 uncommented"
elif grep -q "^it_IT.UTF-8 UTF-8" /etc/locale.gen; then
    echo "✓ it_IT.UTF-8 already enabled"
else
    # In case it's completely missing from the file
    echo "it_IT.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
    echo "✓ it_IT.UTF-8 added to locale.gen"
fi

echo "Generating locales..."
sudo locale-gen

# 3. Configure mixed locale in /etc/locale.conf
# We keep LANG=en_US.UTF-8 (fallback) but override specific regional formats
echo "Configuring regional formats in /etc/locale.conf..."

# Helper function to update or add locale variables
set_locale_var() {
    local var=$1
    local val=$2
    if grep -q "^${var}=" /etc/locale.conf; then
        sudo sed -i "s/^${var}=.*/${var}=${val}/" /etc/locale.conf
    else
        echo "${var}=${val}" | sudo tee -a /etc/locale.conf
    fi
}

# Set Italian for formats while keeping English as primary language
set_locale_var "LC_TIME" "it_IT.UTF-8"
set_locale_var "LC_MONEY" "it_IT.UTF-8"
set_locale_var "LC_PAPER" "it_IT.UTF-8"
set_locale_var "LC_MEASUREMENT" "it_IT.UTF-8"

echo -e "${GREEN}✅ Italian setup complete!${NC}"
echo ""
echo "Current locale configuration (/etc/locale.conf):"
cat /etc/locale.conf
echo ""
echo "Note: Restart your session or reboot for changes to take effect."
