#!/usr/bin/env bash
# requires urxvt, slop, xdotool and wmctrl.

# vars
border="2"
color="255 255 255 0"
format="%w %h %x %y"
dir="/usr/scripts"


# exec
urxvt -iconic -name "drawterm" &
read "width" "height" "xpos" "ypos" < <(slop -l -f "$format" -b "$border" -c "$color")

if [ "$width" ] ; then
	:
else
	pkill -n -f "urxvt -iconic -name drawterm"
	exit "1"
fi

# adapt to the border width of your windows
((width -= 10))
((height -= 10))

active="$(xdotool search --sync --classname drawterm | tail -n1)"

xdotool "windowmove" "$active" "$xpos" "$ypos"
xdotool "windowsize" "$active" "$width" "$height"
wmctrl -ia "$active"
