#!/bin/sh

STEP=5          
MAX=150         
NOTIF_ID=9999   

get_volume() {
	wpctl get-volume @DEFAULT_AUDIO_SINK@ \
		| awk '{
			vol = int($2 * 100)
			if ($3 == "[MUTED]") print vol "M"
			else print vol
			}'
}

is_muted() {
	wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '\[MUTED\]'
}

make_bar() {
	vol=$1
	pct=$(( vol > 100 ? 100 : vol ))
	filled=$(( pct / 5 ))      # 20 ช่องรวม
	empty=$(( 20 - filled ))
	bar="["
	i=0
	while [ $i -lt $filled ]; do bar="${bar}█"; i=$(( i + 1 )); done
	while [ $i -lt 20 ];      do bar="${bar}░"; i=$(( i + 1 )); done
	bar="${bar}]"
	printf '%s' "$bar"
}

notify() {
	vol=$(get_volume)

	num=${vol%M}
	muted=${vol#"$num"}

	if [ "$muted" = "M" ]; then
		icon="audio-volume-muted"
		title="🔇 ปิดเสียง"
		body="$(make_bar 0)  ${num}%"
		urgency="low"
	elif [ "$num" -eq 0 ]; then
		icon="audio-volume-muted"
		title="🔇 ไม่มีเสียง"
		body="$(make_bar 0)  0%"
		urgency="low"
	elif [ "$num" -lt 34 ]; then
		icon="audio-volume-low"
		title="🔈 ระดับเสียง"
		body="$(make_bar "$num")  ${num}%"
		urgency="low"
	elif [ "$num" -lt 67 ]; then
		icon="audio-volume-medium"
		title="🔉 ระดับเสียง"
		body="$(make_bar "$num")  ${num}%"
		urgency="low"
	else
		icon="audio-volume-high"
		title="🔊 ระดับเสียง"
		body="$(make_bar "$num")  ${num}%"
		urgency="low"
	fi

	dunstify \
		--appname="Volume" \
		--urgency="$urgency" \
		--icon="$icon" \
		--hints="int:value:$num" \
		--replace="$NOTIF_ID" \
		--timeout=1500 \
		"$title" "$body"
}

case "$1" in
	up)
		wpctl set-volume -l "$(echo "$MAX / 100" | awk '{printf "%.2f", $0}')" \
			@DEFAULT_AUDIO_SINK@ "${STEP}%+"
		is_muted && wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
		notify
		;;
	down)
		wpctl set-volume @DEFAULT_AUDIO_SINK@ "${STEP}%-"
		notify
		;;
	mute)
		wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
		notify
		;;
	get)
		get_volume
		;;
	*)
		echo "ใช้งาน: $0 [up|down|mute|get]"
		exit 1
		;;
esac
