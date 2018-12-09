#!/bin/bash
shopt -s nullglob

PIDFILE="/tmp/ncmpcpp-cover-$UID-$WINDOWID.pid"
finish() {
    rm -f "$PIDFILE"
    exit
}; trap finish EXIT INT TERM

urxvt_preview() {
    file="$(mpc --format ~/music/%file% current)"

    printf "\e]20;;100x100+1000+1000\a"

    for c in "${file%/*}/folder."* "${file%/*}/cover."*; do
	printf "\e]20;$c;30x30+15+85:op=keep-aspect\a"
    done

    sleep 3

    printf "\e]20;;100x100+1000+1000\a"
}

if [ -e "$PIDFILE" ]; then
    kill "$(cat "$PIDFILE")"
fi
echo "$$" > "$PIDFILE"

case "$TERM" in
    rxvt-unicode*)
        urxvt_preview
        ;;
    *)
        ;;
esac
