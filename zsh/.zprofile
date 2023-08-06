# Enable firefox wayland
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi

# Setup kime
export GTK_IM_MODULE=kime
export QT_IM_MODULE=kime
export SDL_IM_MODULE=kime

# Intellij IDEA fix
# - https://github.com/swaywm/sway/issues/595
if [ "$XDG_SESSION_DESKTOP" = "sway" ] ; then
    export _JAVA_AWT_WM_NONREPARENTING=1
fi
