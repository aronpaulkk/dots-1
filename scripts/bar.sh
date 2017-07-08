#!/usr/bin/env bash

# fetch the colors from colors.sh
user=$(whoami)
source "/home/$user/.scripts/colors.sh"

~/.scripts/barinfo.sh | lemonbar \
    -f '-benis-lemon-medium-r-normal--10-110-75-75-m-50-iso10646-1' \
    -f '-wuncon-siji-medium-r-normal--10-100-75-75-c-80-iso10646-1' \
    -g "x30" \
    -B "$bgn"