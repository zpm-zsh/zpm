#!/usr/bin/env zsh

BATTERY_CHARGE_PREFIX=${BATTERY_CHARGE_PREFIX:-""}
BATTERY_CHARGE_SUFIX=${BATTERY_CHARGE_SUFIX:-""}

function _battery_charge {
if hash acpi 2>/dev/null; then
    bat_percent=`acpi | awk -F ':' '{print $2}' | awk -F ',' '{print $2}' | sed -e "s/\s//" -e "s/%.*//"`
    if [[ $COLORS == "true" ]]; then
        if [ "$bat_percent" -gt "20" ]; then
            if [ "$bat_percent" -gt "50" ]; then
               cl="%{$fg[green]%}$BATTERY_CHARGE_PREFIX"
            else
               cl="%{$fg[yellow]%}$BATTERY_CHARGE_PREFIX"
            fi
        else
            cl="%{$fg[red]%}$BATTERY_CHARGE_PREFIX"
        fi
    else
        cl="$BATTERY_CHARGE_PREFIX"
    fi

    filled=${(l:`expr $bat_percent / 10`::▸:)}
    empty=${(l:`expr 10 - $bat_percent / 10`::▹:)}

    if [[ $COLORS == "true" ]]; then
        export battery_charge=$cl$filled$empty"%{$reset_color%}"$BATTERY_CHARGE_SUFIX
    else
        export battery_charge=$cl$filled$empty$BATTERY_CHARGE_SUFIX
    fi
else
    export battery_charge=""
fi
}

precmd_functions+=(_battery_charge)
