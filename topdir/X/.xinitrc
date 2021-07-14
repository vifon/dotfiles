#!/usr/bin/env bash
# -*- shell-script -*-

set -o pipefail

if [ -z "$SESSION" ]; then
    export SESSION=xmonad
fi

# It's possible to specify the actual WM to run to be different than
# the name of the session, that's chacked in some places, like
# xbindkeys.  For example "none+xmonad" would only initialize the
# environment and tell other processes that we're running XMonad, but
# won't launch it, leaving it to some other initialization scripts
# that probably source this one.
SESSION_WM="${SESSION%%+*}"
export SESSION="${SESSION#*+}"

export PATH="$(zsh -c 'echo $PATH')"

xrdb ~/.Xresources

screen-settings() {
    xsetroot -cursor_name left_ptr

    xrandr --output eDP-1 --primary --auto --output DP-1-2 --off

    if [ -x "$HOME/.fehbg" ]; then
        ~/.fehbg
    else
        feh --bg-scale ~/images/wallpapers/wall.png
    fi

    light -S 40
}

# Enable manually on machines that are expected to use SSH keys stored
# on smartcards.
ssh-agent-settings-smartcard() {
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
}

# Used by default on all the other machines.
ssh-agent-settings() {
    . ssh-agent-start-or-attach.sh
}

start-daemons() {
    nm-applet &> /dev/null &
    dunst &
    udiskie --no-automount --tray --file-manager=ee &
    mpd 2> /dev/null &
}

lockscreen-settings() {
    xset dpms 590 600 600
    xsidle.sh exec i3lock -c 222222 --show-failed-attempts &
}

keyboard-settings() {
    xbindkeys &
    setxkbmap pl -option ctrl:nocaps &
    xset r rate 300 30 &
    numlockx on
}

screen-settings
ssh-agent-settings
lockscreen-settings
keyboard-settings
start-daemons


case $SESSION in
    xmonad)
        emacs --daemon &
        stalonetray &
        ;;
esac

case $SESSION_WM in
    none)
        :
        ;;
    xmonad)
        exec xmonad
        ;;
    emacs)
        exec emacs --eval "(require 'my-exwm)"
        ;;
    *)
        exec $SESSION_WM
        ;;
esac
