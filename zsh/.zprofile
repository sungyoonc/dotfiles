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
# $XDG_SESSION_DESKTOP doesn't seem to be set for sway
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export _JAVA_AWT_WM_NONREPARENTING=1
fi

# Bob: Version manager for Neovim
PATH=$PATH:$HOME/.local/share/bob/nvim-bin

# Flatpak
PATH=$PATH:/var/lib/flatpak/exports/share
PATH=$PATH:$HOME/.local/share/flatpak/exports/share
