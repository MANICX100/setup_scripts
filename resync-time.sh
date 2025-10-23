Resync-Time() {
    if ! command -v ntpdate >/dev/null 2>&1; then
        echo "ntpdate is not installed. Please install it and try again."
        return 1
    fi
    echo "Resyncing system time..."
    sudo ntpdate pool.ntp.org
}
