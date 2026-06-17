#!/bin/sh

BOARD="$(cat /tmp/sysinfo/board_name 2>/dev/null || true)"
[ "$BOARD" = "airpi,ap3000m" ] || exit 0

sleep 25

for svc in qmodem_init qmodem_reboot qmodem_network; do
    if [ -x "/etc/init.d/$svc" ]; then
        /etc/init.d/"$svc" enable >/dev/null 2>&1 || true
        /etc/init.d/"$svc" start >/dev/null 2>&1 || true
    fi
done

if [ -x /etc/init.d/qmodem ]; then
    /etc/init.d/qmodem enable >/dev/null 2>&1 || true
    /etc/init.d/qmodem start >/dev/null 2>&1 || true
fi

if ip link show wwan0 >/dev/null 2>&1; then
    ip link set wwan0 up >/dev/null 2>&1 || true
fi

if ip link show wwan0_1 >/dev/null 2>&1; then
    ip link set wwan0_1 up >/dev/null 2>&1 || true
    ifup 2_1 >/dev/null 2>&1 || true
    ifup 2_1v6 >/dev/null 2>&1 || true
fi

exit 0
