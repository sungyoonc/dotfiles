#!/bin/bash

entries="Logout Suspend Reboot Shutdown"

selected=$(printf '%s\n' $entries | wofi --conf=$HOME/.config/wofi/config.power --style=$HOME/.config/wofi/style.widgets.css | awk '{print tolower($1)}')

case $selected in
logout)
	case "$DESKTOP_SESSION" in
	Hyprland)
		# close all client windows
		# required for graceful exit since many apps aren't good SIGNAL citizens
		HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
		hyprctl --batch "$HYPRCMDS" >>/tmp/hypr/hyprexitwithgrace.log 2>&1

		# exit hyprland
		hyprctl dispatch exit >>/tmp/hypr/hyprexitwithgrace.log 2>&1
		;;
	*)
		swaymsg exit
		;;
	esac
	;;
suspend)
	exec systemctl suspend
	;;
reboot)
	exec systemctl reboot
	;;
shutdown)
	exec systemctl poweroff -i
	;;
esac
