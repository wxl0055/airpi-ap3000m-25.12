#!/usr/bin/env bash
set -euo pipefail

# AIRPI_IMPORT_OLD_MTK_AND_DAED_BEGIN
echo "===== Import Airpi old MTK packages and daed feed ====="
if [ -f "../Scripts/import_airpi_old_and_daed.sh" ]; then
  bash ../Scripts/import_airpi_old_and_daed.sh
elif [ -f "Scripts/import_airpi_old_and_daed.sh" ]; then
  bash Scripts/import_airpi_old_and_daed.sh
else
  echo "ERROR: import_airpi_old_and_daed.sh not found"
  exit 1
fi
# AIRPI_IMPORT_OLD_MTK_AND_DAED_END


echo "============================================================"
echo " Apply Airpi chasey 25.12 full qmodem config"
echo "============================================================"

# This script runs inside chasey-dev/immortalwrt-mt798x-rebase source root.

# ------------------------------------------------------------
# Add QModem feed
# ------------------------------------------------------------
if ! grep -q 'FUjr/QModem' feeds.conf.default; then
  echo 'src-git qmodem https://github.com/FUjr/QModem.git;main' >> feeds.conf.default
fi

echo
echo "===== feeds update/install ====="
./scripts/feeds update -a
echo "===== feeds install: selected packages only ====="

# Do not use "./scripts/feeds install -a" here.
# Only link packages needed by this Airpi build.

./scripts/feeds install \
  luci luci-base luci-compat luci-mod-admin-full luci-app-firewall \
  luci-app-ttyd luci-app-upnp luci-app-autoreboot \
  luci-app-diskman luci-app-filemanager luci-app-package-manager \
  luci-app-argon-config luci-theme-argon luci-theme-bootstrap \
  luci-app-mtk luci-app-mtwifi-cfg luci-app-turboacc-mtk \
  wrtbwmon luci-app-wrtbwmon \
  || true

./scripts/feeds install \
  qmodem luci-app-qmodem-next luci-app-qmodem \
  ubus_at_daemon tom_modem sms-tool_q modem_scan qmodem_monitor \
  quectel_QMI_WWAN simcom_QMI_WWAN quectel_MHI qfirehose quectel_CM_5G_M \
  sms_forwarder_next sms_forwarder \
  luci-app-qmodem-monitor luci-app-qmodem-sms luci-app-qmodem-mwan luci-app-qmodem-ttl luci-app-qmodem-ttlfw4 \
  || true

./scripts/feeds install \
  dae daed luci-app-dae luci-app-daed luci-app-daede \
  dae-geoip dae-geosite daed-geoip daed-geosite \
  || true

echo "===== feeds install: selected packages done ====="


# ------------------------------------------------------------
# Base target config
# ------------------------------------------------------------
echo
echo "===== target config ====="

if [ -f defconfig/mt7981-ax3000.config ]; then
  cp -f defconfig/mt7981-ax3000.config .config
else
  : > .config
fi


# AIRPI_REQUIRED_CONFIG_BEGIN
echo "===== Apply Airpi required package config ====="

cat >> .config <<'EOF'
CONFIG_TARGET_mediatek=y
CONFIG_TARGET_mediatek_filogic=y
CONFIG_TARGET_mediatek_filogic_DEVICE_airpi_ap3000m=y
CONFIG_CCACHE=y
CONFIG_PACKAGE_luci-app-firewall=y
CONFIG_PACKAGE_luci-compat=y
CONFIG_PACKAGE_luci-base=y
CONFIG_PACKAGE_luci=y
# ===== LuCI base =====

CONFIG_PACKAGE_qmodem=y
CONFIG_PACKAGE_luci-app-qmodem-next=y

CONFIG_PACKAGE_luci-app-mtwifi-cfg=y
CONFIG_PACKAGE_mtwifi-cfg-ucode=y

# CONFIG_PACKAGE_luci-app-eqos-mtk is not set
CONFIG_PACKAGE_luci-app-turboacc-mtk=y
CONFIG_PACKAGE_mii_mgr=y
CONFIG_PACKAGE_switch=y
CONFIG_PACKAGE_regs=y
CONFIG_PACKAGE_ndisc=y
# CONFIG_PACKAGE_mtkhqos_util is not set
CONFIG_PACKAGE_mtk-smp=y

CONFIG_PACKAGE_luci-app-Airpifanctrl=y
CONFIG_PACKAGE_kmod-Airpi-gpio-fan=y
CONFIG_PACKAGE_luci-app-mtk=y

CONFIG_PACKAGE_wrtbwmon=y
CONFIG_PACKAGE_luci-app-wrtbwmon=y

CONFIG_PACKAGE_luci-app-autoreboot=y
CONFIG_PACKAGE_luci-app-bandix=y
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-filemanager=y
CONFIG_PACKAGE_luci-app-package-manager=y
CONFIG_PACKAGE_luci-app-quickstart=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-upnp=y
CONFIG_PACKAGE_luci-app-wolplus=y
CONFIG_PACKAGE_luci-app-xfrpc=y
CONFIG_PACKAGE_luci-app-argon-config=y
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-theme-bootstrap=y

CONFIG_PACKAGE_ca-bundle=y
CONFIG_PACKAGE_kmod-sched-core=y
CONFIG_PACKAGE_kmod-sched-bpf=y
CONFIG_PACKAGE_kmod-veth=y
CONFIG_PACKAGE_kmod-xdp-sockets-diag=y
CONFIG_PACKAGE_kmod-nft-tproxy=y
CONFIG_PACKAGE_dae=y
CONFIG_PACKAGE_daed=y
CONFIG_PACKAGE_luci-app-daede=y

CONFIG_KERNEL_BPF_EVENTS=y
CONFIG_KERNEL_KPROBE_EVENTS=y
CONFIG_KERNEL_DEBUG_INFO=y
CONFIG_KERNEL_DEBUG_INFO_BTF=y
CONFIG_KERNEL_XDP_SOCKETS=y
CONFIG_BPF_TOOLCHAIN_HOST=y

# CONFIG_PACKAGE_luci-app-aurora-config is not set
# CONFIG_PACKAGE_luci-app-openclash is not set
# CONFIG_PACKAGE_luci-app-istorex is not set
# CONFIG_PACKAGE_luci-app-istore is not set
# CONFIG_PACKAGE_luci-app-store is not set
# CONFIG_PACKAGE_luci-theme-aurora is not set
EOF

echo "===== make defconfig for required packages ====="
make defconfig

echo "===== Airpi prebuild forbidden package check ====="
if grep -E '^CONFIG_PACKAGE_luci-app-(openclash|istorex|istore|store|aurora-config)=y$|^CONFIG_PACKAGE_luci-theme-aurora=y$' .config; then
  echo "ERROR: forbidden packages enabled"
  exit 1
fi

echo "===== Airpi prebuild br_lan overlay check ====="
if grep -RInE 'network\.br_lan|set network\.br_lan|delete network\..*ports' ../files ../Scripts 2>/dev/null \
  | grep -v airpi-old-package-deps.txt \
  | grep -vE '^[^:]+:[0-9]+:[[:space:]]*#'; then
  echo "ERROR: unsafe br_lan overlay found"
  exit 1
fi

echo "===== Airpi required config check ====="
for sym in \
  CONFIG_PACKAGE_luci-app-Airpifanctrl \
  CONFIG_PACKAGE_kmod-Airpi-gpio-fan \
  CONFIG_PACKAGE_luci-app-mtk \
  CONFIG_PACKAGE_luci-app-mtwifi-cfg \
  CONFIG_PACKAGE_luci-app-turboacc-mtk \
  CONFIG_PACKAGE_luci-app-qmodem-next \
  CONFIG_PACKAGE_daed \
  CONFIG_PACKAGE_luci-app-daede
do
  if ! grep -q "^${sym}=y$" .config; then
    echo "ERROR: required config not enabled: ${sym}"
    exit 1
  fi
done
# AIRPI_REQUIRED_CONFIG_END
