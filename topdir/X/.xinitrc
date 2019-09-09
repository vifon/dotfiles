#!/bin/bash
# -*- shell-script -*-

set -o pipefail

if [ -z "$SESSION" ]; then
    export SESSION=xmonad
fi

xrdb ~/.Xresources

screen-settings() {
    xsetroot -cursor_name left_ptr

    xrandr --output eDP-1 --primary --auto --output DP-1-2 --off

    if [ -e "$HOME/.fehbg" ]; then
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
    xsidle.sh zsh -c "exec i3lock -c 222222 --show-failed-attempts" &
}

keyboard-settings() {
    zsh -c 'exec xbindkeys' &
    rofi -key-window SuperL+n -modi window,ssh,run -terminal urxvtcd &
    setxkbmap pl -option ctrl:nocaps &
    xset r rate 300 30 &
    numlockx on
    if xinput list | grep -q 'Logitech USB Trackball'; then
        xset m 5 5
    else
        xset m default
    fi
}

screen-settings
ssh-agent-settings
lockscreen-settings
keyboard-settings
start-daemons

case $SESSION in
    xmonad)
        stalonetray &
        emacs --daemon &
        exec zsh -c 'exec xmonad'
        ;;
    emacs)
        exec zsh -c "exec emacs --eval \"(require 'my-exwm)\""
        ;;
    *)
        exec zsh -c "exec $SESSION" ;;
esac
