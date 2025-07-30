#!/usr/bin/env bash

# Exit if no desktop number is provided as an argument.
if [ -z "$1" ]; then
	echo "Error: No desktop number provided."
	echo "Usage: $0 <desktop_number>"
	exit 1
fi

TARGET_DESKTOP=$1

# Get the ID of the currently active window.
ACTIVE_WINDOW_ID=$(kdotool getactivewindow)

# Move the active window to the target desktop using the correct command.
kdotool set_desktop_for_window "$ACTIVE_WINDOW_ID" "$TARGET_DESKTOP"

# Switch to the target desktop using the correct command.
kdotool set_desktop "$TARGET_DESKTOP"
