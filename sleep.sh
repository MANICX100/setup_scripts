echo 'disabled' | sudo tee /sys/bus/pci/devices/0000:00:14.0/power/wakeup;dbus-send --system --print-reply --dest="org.freedesktop.login1" /org/freedesktop/login1 org.freedesktop.login1.Manager.Suspend boolean:true
i3lock -c 000000 -n
