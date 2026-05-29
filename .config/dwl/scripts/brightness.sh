#!/bin/sh

STEP=5
NOTIF_ID=9998

get_brightness() {
    brightnessctl -m | awk -F, '{gsub(/%/,"",$4); print int($4)}'
}

make_bar() {
    pct=$(( $1 > 100 ? 100 : $1 ))
    filled=$(( pct / 5 ))
    i=0; bar="["
    while [ $i -lt $filled ]; do bar="${bar}█"; i=$(( i+1 )); done
    while [ $i -lt 20 ];      do bar="${bar}░"; i=$(( i+1 )); done
    printf '%s]' "$bar"
}

notify() {
    val=$(get_brightness)
    dunstify -a "bright" -u low -i "display-brightness" \
        -h "int:value:$val" -r "$NOTIF_ID" -t 1500 \
        "Brightness" "$(make_bar "$val")  ${val}%"
}

case "$1" in
    up)
        brightnessctl set "${STEP}%+" -q
        notify ;;
    down)
        brightnessctl set "${STEP}%-" -q
        notify ;;
    get) get_brightness ;;
    *) echo "usage: $0 [up|down|get]"; exit 1 ;;
esac
