# -*- shell-script -*-
# vim: ft=sh :

feh --bg-scale ~/images/wallpapers/wall.png
xsetroot -cursor_name left_ptr

xrandr --output eDP1 --primary
xbacklight -set 20

xrdb ~/.Xresources

eval `ssh-agent`
eval `gpg-agent --daemon`
nm-applet &> /dev/null &
blueman-applet &> /dev/null &

rofi -key-window mod4+shift+n -key-combi mod4+n -combi-modi window,run -modi combi,window,ssh,run -terminal urxvtcd &

if [ -z "$SESSION" ]; then
    SESSION=xmonad
    ~/.startup &
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
        exec zsh -c 'exec xmonad'
        ;;
    clfswm)
        cd /home/vifon/src/clfswm/ ; exec ./clfswm ;;
    *)
        exec $SESSION ;;
esac
