# -*- shell-script -*-
# vim: ft=sh :

xsetroot -cursor_name left_ptr

xrandr --output eDP-1 --primary --auto --output DP-1-2 --off

if [ -e "$HOME/.fehbg" ]; then
    ~/.fehbg
else
    feh --bg-scale ~/images/wallpapers/wall.png
fi

xbacklight -set 20

xrdb ~/.Xresources

eval `ssh-agent`
nm-applet &> /dev/null &
blueman-applet &> /dev/null &

xautolock -time 10 -locker 'i3lock -c 222222 --dpms --inactivity-timeout 10 --ignore-empty-password --show-failed-attempts' -corners '00-+' -notify 5 -notifier 'xset dpms force off' &
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


if [ -z "$SESSION" ]; then
    SESSION=xmonad
fi

case $SESSION in
    awesome)
        wmname LG3D; exec awesome ;;
    i3)
        exec $HOME/local/bin/i3
        exec i3
        ;;
    kde)
        exec startkde ;;
    xmonad)
        stalonetray &
        emacs --daemon &
        exec zsh -c 'exec xmonad'
        ;;
    emacs)
        export START_EXWM=1
        exec zsh -c 'exec emacs'
        ;;
    clfswm)
        cd /home/vifon/src/clfswm/ ; exec ./clfswm ;;
    *)
        exec zsh -c "exec $SESSION" ;;
esac
