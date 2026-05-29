#!/bin/bash

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

FILE_NAME="scrn-$(date +%Y%m%d-%H%M%S).png"
FILE_PATH="$SAVE_DIR/$FILE_NAME"

case $1 in
    full)
        grim "$FILE_PATH"
        ;;
    select)
        grim -g "$(slurp)" "$FILE_PATH"
        ;;
    *)
        echo "Usage: $0 {full|select}"
        exit 1
        ;;
esac

if [ -f "$FILE_PATH" ]; then
    cat "$FILE_PATH" | wl-copy
    notify-send "Screenshot Saved" "$FILE_NAME" -i camera-photo
fi
