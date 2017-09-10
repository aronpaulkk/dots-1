#!/usr/bin/env bash

# vars
tmpf="/tmp/fweather"
station="LFBD"
temp=$(weather --no-cache -qm --headers="Temperature" "$station" | sed "s/Temperature: //" | sed "s/ //" | sed "s/C/°C/")


wcond() {
	cond=$(weather --no-cache -qm --headers="Sky Conditions" "$station" | sed "s/Sky conditions: //")

	if [ "$cond" == "(no conditions matched your header list, try with --verbose)" ] ; then
		cond=$(weather --no-cache -qm --headers="Weather" "$station" | sed "s/Weather: //")
		if [ "$cond" == "(no conditions matched your header list, try with --verbose)" ] ; then
			echo "condition unavailable"
		else
			echo "$cond"
		fi
	else
		echo "$cond"
	fi
}

while true ; do
	echo "$temp - $(wcond)" > "$tmpf"
	cat "$tmpf"
	sleep "15m"
done