#!/usr/bin/env bash

function battery_meter() {

    if [ "$(which acpi)" ]; then

        # Set the default color to the local variable fgdefault.
        local fgdefault='#[default]'

        # Check for existence of a battery.
        if [ -x /sys/class/power_supply/BAT1 ]; then

            local batt0=$(acpi -b 2>/dev/null | grep -oP '\d+%')

            case $batt0 in

            # From 100% to 75% display color grey.
            100% | 9[0-9]% | 8[0-9]% | 7[5-9]%)
                bgcolor='blue'
                fgcolor='#ffffff'
                icon='󰁹 '
                ;;

            # From 74% to 50% display color green.
            7[0-4]% | 6[0-9]% | 5[0-9]%)
                bgcolor='green'
                fgcolor='#ffffff'
                icon='󰂀 '
                ;;

            # From 49% to 25% display color yellow.
            4[0-9]% | 3[0-9]% | 2[5-9]%)
                bgcolor='yellow'
                fgcolor='#ffffff'
                icon='󰁾 '
                ;;

            # From 24% to 0% display color red.
            2[0-4]% | 1[0-9]% | [0-9]%)
                bgcolor='red'
                fgcolor='#ffffff'
                icon='󰁻 '
                ;;
            esac

            if [ "$(cat /sys/class/power_supply/AC1/online)" == 1 ]; then
                icon='󰂄 '
            fi

            # Display the percentage of charge the battery has.
            printf "#[bg=%s,bold] #[fg=%s]%s #[default]" "${bgcolor}" \
                "${fgcolor}" "${icon}${batt0}"

        fi

    fi
}

function load_average() {
    printf "%s " "$(uptime | awk -F: '{printf $NF}' | tr -d ',')"

}

function date_time() {
    # printf "%s" "$(date +'%Y-%m-%d %H:%M:%S %Z')"
    printf "#[fg=#ffffff,bg=brightblack,bold] %s #[default]" "$(date +'%d %b %H:%M:%S')"

    # printf "%s" "%a, %l:%M:%S %p#[default] #[fg=blue]%Y-%m-%d #[fg=default]"
}

function sep() {
    # printf "#[fg=brightblack,nobold] #[fg=brightblack,nobold,noitalics,nounderscore]"
    printf " "
}

function main() {
    # printf "#[fg=brightblack,nobold,noitalics,nounderscore]"
    date_time
    sep
    battery_meter
    # printf "#[fg=brightblack,nobold]"
}

# Calling the main function which will call the other functions.
main
