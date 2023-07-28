# Launch Contour and save PID
contour_pid=$!
flatpak run org.contourterminal.Contour &

# Wait briefly for it to launch
sleep 1

# Exit Contour instance we launched 
kill $contour_pid

xset dpms force off && i3lock -c 000000 -n
