#!/usr/bin/env bash

# vars
tmpf="/tmp/fweather"
station="LFBD"
ctime=$(date "+%H")
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

icon() {
	weather=$(weather --no-cache -qm --headers="Weather" "$station" | sed "s/Weather: //")
	
	if [[ "$ctime" -le "07" || "$ctime" -ge "20" ]] ; then
	 	ico=" "
		echo "$ico"
	elif [ "$weather" == "light rain" ] ; then
		ico=""
		echo "$ico "
	elif [ "$weather" == "showers in the vicinity" ] ; then
		ico=""
		echo "$ico "
	elif [[ "$(wcond)" == "mostly cloudy" || "$(wcond)" == "mostly clear"  ]] ; then
		ico=""
		echo "$ico "
	elif [ "$(wcond)" == "overcast" ] ; then
		ico=""
		echo "$ico "
	elif [ "$(wcond)" == "clear" ] ; then
		ico=""
		echo "$ico "
	else
		:
	fi
}

while true ; do
	echo "$(icon)$temp - $(wcond)" > "$tmpf"
	cat "$tmpf"
	sleep "15m"
done