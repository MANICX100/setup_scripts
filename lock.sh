# Launch Contour 
flatpak run org.contourterminal.Contour &

# Wait briefly for it to launch 
sleep 1

# Send Ctrl+D to exit Contour
killall contour

xset dpms force off && i3lock -c 000000 -n
