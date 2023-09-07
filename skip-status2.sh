sleep 0.1
WID=$(xdotool search --name "display host writable statusline requested")
xdotool windowactivate --sync $WID
xdotool key KP_Enter
