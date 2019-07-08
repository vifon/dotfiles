if [ -e "$PIDFILE" ]; then
    alt_action &
    kill "$(cat "$PIDFILE")"
else
    action &
fi

echo $$ > "$PIDFILE"
sleep ${DELAY:-1}
rm -f "$PIDFILE"
