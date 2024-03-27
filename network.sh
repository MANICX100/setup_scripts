disable-all-network-interfaces() {
    if type ip > /dev/null 2>&1; then
        for iface in $(ip link show | rg '^[0-9]' | frawk -F: '{print $2}' | tr -d '[:space:]'); do
            echo "Disabling $iface"
            sudo ip link set $iface down
        done
    else
        for service in $(networksetup -listallnetworkservices | tr -d '[:space:]'); do
            echo "Disabling $service"
            sudo networksetup -setnetworkserviceenabled "$service" off
        done
    fi
}

enable-all-network-interfaces() {
    if type ip > /dev/null 2>&1; then
        for iface in $(ip link show | rg '^[0-9]' | frawk -F: '{print $2}' | tr -d '[:space:]'); do
            echo "Enabling $iface"
            sudo ip link set $iface up
        done
    else
        for service in $(networksetup -listallnetworkservices | tr -d '[:space:]'); do
            echo "Enabling $service"
            sudo networksetup -setnetworkserviceenabled "$service" on
        done
    fi
}

networkcycle() {
    disable-all-network-interfaces
    enable-all-network-interfaces
}
