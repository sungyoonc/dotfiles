#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5

# Current Theme
dir="$HOME/.config/rofi/scripts/powermenu"
theme='style-1'

# CMDs
uptime="$(uptime -p | sed -e 's/up //g')"
host=$(cat /proc/sys/kernel/hostname)

# Options
shutdown=' Shutdown'
reboot=' Reboot'
lock=' Lock'
suspend='󰤄 Suspend'
logout=' Logout'
hibernate=' Hibernate'
yes=' Yes'
no=' No'

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -scroll-method 0 \
        -p "$host" \
        -mesg "Uptime: $uptime" \
        -theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
    rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg "Confirm $1?" \
        -theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd "$1"
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$lock\n$suspend\n$hibernate\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
    selected="$(confirm_exit "$1")"
    if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == 'Shutdown' ]]; then
            systemctl poweroff
        elif [[ $1 == 'Reboot' ]]; then
            systemctl reboot
        elif [[ $1 == 'Suspend' ]]; then
            # mpc -q pause
            amixer set Master mute
            systemctl suspend
        elif [[ $1 == 'Hibernate' ]]; then
            systemctl hibernate
        elif [[ $1 == 'Logout' ]]; then
            if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then
                # close all client windows
                # required for graceful exit since many apps aren't good SIGNAL citizens
                HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
                hyprctl --batch "$HYPRCMDS" >>$XDG_RUNTIME_DIR/hypr/hyprexitwithgrace.log 2>&1

                # exit hyprland
                # loginctl kill-user $(whoami) >>/tmp/hypr/hyprexitwithgrace.log 2>&1
                hyprctl dispatch exit
            elif [[ "$XDG_CURRENT_DESKTOP" == 'openbox' ]]; then
                openbox --exit
            elif [[ "$XDG_CURRENT_DESKTOP" == 'bspwm' ]]; then
                bspc quit
            elif [[ "$XDG_CURRENT_DESKTOP" == 'i3' ]]; then
                i3-msg exit
            elif [[ "$XDG_CURRENT_DESKTOP" == 'plasma' ]]; then
                qdbus org.kde.ksmserver /KSMServer logout 0 0 0
            fi
        fi
        exit 1
    fi
    exit 0
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$shutdown)
    run_cmd Shutdown
    ;;
$reboot)
    run_cmd Reboot
    ;;
$lock)
    if [[ -x '/usr/bin/hyprlock' ]]; then
        hyprlock
    elif [[ -x '/usr/bin/swaylock' ]]; then
        swaylock
    fi
    ;;
$suspend)
    run_cmd Suspend
    ;;
$hibernate)
    run_cmd Hibernate
    ;;
$logout)
    run_cmd Logout
    ;;
esac
