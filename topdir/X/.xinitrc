# -*- shell-script -*-
# vim: ft=sh :

if [ -z "$SESSION" ]; then
    export SESSION=xmonad
fi

xsetroot -cursor_name left_ptr

xrandr --output eDP-1 --primary --auto --output DP-1-2 --off

if [ -e "$HOME/.fehbg" ]; then
    ~/.fehbg
else
    feh --bg-scale ~/images/wallpapers/wall.png
fi

light -S 40

xrdb ~/.Xresources

eval `ssh-agent`
nm-applet &> /dev/null &
blueman-applet &> /dev/null &
dunst &

xset dpms 590 600 600
xsidle.sh zsh -c "exec slock" &

rofi -key-window SuperL+n -modi window,ssh,run -terminal urxvtcd &


zsh -c 'exec xbindkeys' &
setxkbmap pl -option ctrl:nocaps &
xset r rate 300 30 &
if xinput list | grep -q 'Logitech USB Trackball'; then
    xset m 5 5
else
    xset m default
fi

mpd 2> /dev/null &


case $SESSION in
    xmonad)
        stalonetray &
        emacs --daemon &
        exec zsh -c 'exec xmonad'
        ;;
    emacs)
        exec env START_EXWM=1 zsh -c 'exec emacs'
        ;;
    *)
        exec zsh -c "exec $SESSION" ;;
esac
