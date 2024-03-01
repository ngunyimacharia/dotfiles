#!/bin/bash

DARK_MODE=$(2>/dev/null defaults read -g AppleInterfaceStyle)

# Set the Kitty config directory
KITTY_CONFIG_DIR="${HOME}/.config/kitty/kitty-themes/themes"

# Define the light and dark theme names
LIGHT_THEME="AtomOneLight.conf"
DARK_THEME="Dracula.conf"

# Define the theme to use based on the value of DARKMODE
if [ -n "$DARK_MODE" ] && [ "$DARK_MODE" = "Dark" ]; then
	THEME="${DARK_THEME}"
else
	THEME="${LIGHT_THEME}"
fi

# Check if the theme file exists
if [[ -f "${KITTY_CONFIG_DIR}/${THEME}" ]]; then
	# Use kitty command to set colors
	kitty @ set-colors -a "${KITTY_CONFIG_DIR}/${THEME}"
	# echo "Theme successfully set to ${KITTY_CONFIG_DIR}/${THEME}"
else
	# echo "Error: ${KITTY_CONFIG_DIR}/${THEME} theme file not found"
	exit 1
fi
