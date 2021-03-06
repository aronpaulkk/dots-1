#!/usr/bin/env bash
# vars
colors="/usr/scripts/colors.sh"
refresh=".5"
padding="    "
height="35"
font="-*-euphon-*"
font2="-*-ijis-*"
font3="-*-vanilla-*"
font4="-efont-biwidth-*"
battery="BAT0"


# colors
source "$colors"


# functions
mpd() {
	artist="$(mpc -f '%artist%' | head -1)"
	song="$(mpc -f '%title%' | head -1)"
	progress="$(mpc | sed 's/.*(//;s/)//;2q;d')"
	if [ "$(mpc current)" ] ; then
		echo "$a2$padding$artist : $song : $progress$padding$bg"
	else
		:
	fi
}

spotify() {
	current="$(sps 'current' | sed 's/ \- / \: /')"
	if [ "$current" == "No media player is currently running" ] ; then
		:
	else
		echo "$a2$padding$current$padding$bg"
	fi
}

weather() {
	file="/tmp/weather"
	cat "$file"
}

battery() {
	percent="$(cat '/sys/class/power_supply/'$battery'/capacity')"
	status="$(cat '/sys/class/power_supply/'$battery'/status')"
	if [[ $status == "Unknown" || $status == "Charging" ]] ; then
		if [ $percent -gt 98 ] ; then
			echo "$a3$padding ̚ $padding$a3"
		else
			echo "$a3$padding$percent%$padding$bg"
		fi
	else
		echo "$a2$padding$percent%$padding$bg"
	fi
}

clock() {
	born="$(date -d '5 Nov 1998' +%s)"
    now="$(date -d now +%s)"
    printf "$(((now - born) / 86400)) days spent on earth"
}


# loops
desktop_loop() {
	while :; do
		echo "%{l}\
		%{A2:cover &:}%{A:mpc 'toggle' &:}%{A3:urxvt -e 'ncmpcpp' &:}$(mpd)%{A}%{A}%{A:sps 'play' &:}$(spotify)$padding%{A}%{A}$bg\
		%{r}\
		$a2%{A:notify-send 'updating the weather' && weather &:}$padding$(weather)$padding%{A}%{A:calendar &:}$padding$(clock)$padding%{A}$bg"
		sleep "$refresh"
	done |\

	lemonbar \
		-f "$font" \
		-f "$font2" \
		-f "$font3" \
		-f "$font4" \
		-g "x$height" \
		-F "$text" \
		-B "$background" \
	| bash
}

laptop_loop() {
	while :; do
		echo "%{l}\
		%{A2:cover &:}%{A:mpc 'toggle' &:}%{A3:urxvt -e 'ncmpcpp' &:}$(mpd)%{A}%{A}%{A:sps 'play' &:}$(spotify)$padding%{A}%{A}$bg\
		%{r}\
		$a2%{A:calendar &:}$padding$(clock)$padding%{A}$bg\
		%{A:batstat &:}$(battery)%{A}$bg"
		sleep "$refresh"
	done |\

	lemonbar \
		-f "$font" \
		-f "$font2" \
		-f "$font3" \
		-f "$font4" \
		-g "x$height" \
		-F "$text" \
		-B "$background" \
	| bash
}


# exec
if [ -f "/sys/class/power_supply/$battery/status" ] ; then
	laptop_loop
else
	desktop_loop
fi