# Airpi Chasey 25.12 QModem Build

## Source

- Repo: https://github.com/chasey-dev/immortalwrt-mt798x-rebase.git
- Branch: 25.12

## Kept packages

- luci-app-Airpifanctrl
- luci-app-argon-config
- luci-app-aurora-config
- luci-app-autoreboot
- luci-app-bandix
- luci-app-diskman
- luci-app-eqos-mtk
- luci-app-filemanager
- luci-app-firewall
- luci-app-mtwifi-cfg
- luci-app-package-manager
- luci-app-qmodem-next
- luci-app-quickstart
- luci-app-ttyd
- luci-app-turboacc-mtk
- luci-app-upnp
- luci-app-wolplus
- luci-app-wrtbwmon
- luci-app-xfrpc
- luci-theme-argon
- luci-theme-bootstrap

## Removed packages

- luci-app-openclash
- luci-app-istorex
- luci-app-istore
- luci-app-store
- luci-theme-aurora

## Old firmware compatible defaults

- Hostname: Airpi
- LAN: 192.168.88.1/24
- DHCPv4 server enabled
- QModem profile: 2_1
- Modem interface: wwan0 / wwan0_1
- Metric: 11
- Firewall WAN zone: wan, wan6, 2_1, 2_1v6
- 2.4G SSID: Airpi-2.4G
- 5G SSID: Airpi-5G
- 5G password: 1234567890

## GitHub Actions

Workflow:

.github/workflows/Airpi-Chasey-25.12.yml

Run manually from GitHub Actions or wait for scheduled build.
