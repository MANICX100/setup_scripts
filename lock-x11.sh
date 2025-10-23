saved_pid=$!
alacritty &
sleep 1
kill $saved_pid

xset dpms force off && i3lock -c 000000 -n
