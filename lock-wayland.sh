saved_pid=$!
alacritty &
sleep 1
kill $saved_pid

xset dpms force off && swaylock -c 000000 -n
