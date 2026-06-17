#!/usr/bin/env bash
set -euo pipefail

echo "============================================================"
echo " Apply Airpi WiFi/WAPP runtime fix"
echo " 从 MTK mtwifi-cfg 源码复制 WAPP 运行文件到 rootfs overlay"
echo "============================================================"

WORK="${GITHUB_WORKSPACE:-$(pwd)}"

find_wrt_root() {
  for d in "$WORK" "$WORK"/wrt "$WORK"/openwrt "$WORK"/immortalwrt "$WORK"/immortalwrt-mt798x-6.6 "$WORK"/*; do
    [ -d "$d" ] || continue
    if [ -f "$d/rules.mk" ] && [ -d "$d/package" ]; then
      echo "$d"
      return 0
    fi
  done

  found="$(find "$WORK" -maxdepth 6 -type f -name rules.mk 2>/dev/null | head -n1 || true)"
  if [ -n "$found" ]; then
    dirname "$found"
    return 0
  fi

  return 1
}

WRT_ROOT="$(find_wrt_root || true)"

if [ -z "${WRT_ROOT:-}" ]; then
  echo "ERROR: OpenWrt source root not found"
  find "$WORK" -maxdepth 4 -type d | sed -n '1,200p'
  exit 1
fi

cd "$WRT_ROOT"
echo "OpenWrt root: $WRT_ROOT"

mkdir -p files/sbin
mkdir -p files/usr/sbin
mkdir -p files/etc/wapp
mkdir -p files/etc/hotplug.d/net
mkdir -p files/usr/lib/wapp
mkdir -p files/etc/uci-defaults

echo
echo "=== 1. 定位 mtwifi-cfg / WAPP 源文件 ==="

WAPP_DIR=""

for d in \
  "package/mtk/applications/mtwifi-cfg/files/wapp" \
  "package/mtk/applications/mtwifi-cfg/files" \
  "package/feeds/mtk/mtwifi-cfg/files/wapp" \
  "package/feeds/mtk/mtwifi-cfg/files"
do
  if [ -d "$d" ]; then
    WAPP_DIR="$d"
    break
  fi
done

if [ -z "$WAPP_DIR" ]; then
  WAPP_DIR="$(find package -type d -path '*mtwifi-cfg*' 2>/dev/null | head -n1 || true)"
fi

if [ -z "$WAPP_DIR" ]; then
  echo "ERROR: cannot locate mtwifi-cfg / wapp directory"
  find package -maxdepth 5 -type d | grep -Ei 'mtwifi|wapp|mtk' | sed -n '1,200p' || true
  exit 1
fi

echo "WAPP_DIR=$WAPP_DIR"

find_near_wapp() {
  name="$1"

  if [ -f "$WAPP_DIR/$name" ]; then
    echo "$WAPP_DIR/$name"
    return 0
  fi

  found="$(find "$WAPP_DIR" "$(dirname "$WAPP_DIR")" package -type f -name "$name" 2>/dev/null | head -n1 || true)"

  if [ -n "$found" ]; then
    echo "$found"
    return 0
  fi

  return 1
}

copy_required() {
  name="$1"
  dest="$2"

  src="$(find_near_wapp "$name" || true)"

  if [ -z "$src" ]; then
    echo "ERROR: required WAPP file missing: $name"
    exit 1
  fi

  echo "copy $src -> $dest"
  cp -f "$src" "$dest"
}

copy_optional() {
  name="$1"
  dest="$2"

  src="$(find_near_wapp "$name" || true)"

  if [ -z "$src" ]; then
    echo "WARN: optional WAPP file missing: $name"
    return 0
  fi

  echo "copy $src -> $dest"
  cp -f "$src" "$dest"
}

echo
echo "=== 2. 注入 WAPP 必要文件 ==="

copy_required startwapp.sh files/sbin/startwapp.sh
copy_required wapp files/usr/sbin/wapp.real
copy_required wappctrl files/usr/sbin/wappctrl

copy_optional bs20 files/usr/sbin/bs20
copy_optional setbssid files/usr/sbin/setbssid
copy_optional steeringsta files/usr/sbin/steeringsta

copy_optional wapp_ap.conf files/etc/wapp/wapp_ap.conf
copy_optional wapp_ap_ra0.conf files/etc/wapp/wapp_ap_ra0.conf
copy_optional 1905d.cfg files/etc/wapp/1905d.cfg
copy_optional mapd_cfg files/etc/wapp/mapd_cfg
copy_optional 100-startwapp files/etc/hotplug.d/net/100-startwapp

copy_optional libcrypto.so.1.1 files/usr/lib/wapp/libcrypto.so.1.1
copy_optional libssl.so.1.1 files/usr/lib/wapp/libssl.so.1.1

cat > files/usr/sbin/wapp <<'EOWAPP'
#!/bin/sh
export LD_LIBRARY_PATH="/usr/lib/wapp:/lib:/usr/lib"
exec /usr/sbin/wapp.real "$@"
EOWAPP

ln -sf /sbin/startwapp.sh files/usr/sbin/startwapp.sh

chmod +x files/sbin/startwapp.sh
chmod +x files/usr/sbin/wapp
chmod +x files/usr/sbin/wapp.real
chmod +x files/usr/sbin/wappctrl
chmod +x files/usr/sbin/bs20 2>/dev/null || true
chmod +x files/usr/sbin/setbssid 2>/dev/null || true
chmod +x files/usr/sbin/steeringsta 2>/dev/null || true
chmod +x files/etc/hotplug.d/net/100-startwapp 2>/dev/null || true
chmod 644 files/etc/wapp/* 2>/dev/null || true
chmod 644 files/usr/lib/wapp/* 2>/dev/null || true

echo
echo "=== 3. 加入最小 5G 兼容默认配置 ==="

cat > files/etc/uci-defaults/99-airpi-5g-compat <<'EOUCI'
#!/bin/sh

RADIO5=""
IFACE5=""

for dev in $(uci show wireless 2>/dev/null | sed -n "s/^wireless\.\([^.=]*\)=wifi-device.*/\1/p"); do
  band="$(uci -q get wireless.$dev.band)"
  hwmode="$(uci -q get wireless.$dev.hwmode)"

  if [ "$band" = "5g" ] || [ "$hwmode" = "11a" ]; then
    RADIO5="$dev"
    break
  fi
done

if [ -n "$RADIO5" ]; then
  for iface in $(uci show wireless 2>/dev/null | sed -n "s/^wireless\.\([^.=]*\)=wifi-iface.*/\1/p"); do
    dev="$(uci -q get wireless.$iface.device)"
    if [ "$dev" = "$RADIO5" ]; then
      IFACE5="$iface"
      break
    fi
  done
fi

if [ -n "$RADIO5" ]; then
  uci set wireless.$RADIO5.country='DE'
  uci set wireless.$RADIO5.channel='36'
  uci set wireless.$RADIO5.htmode='VHT80'
  uci set wireless.$RADIO5.disabled='0'
fi

if [ -n "$IFACE5" ]; then
  OLD_KEY="$(uci -q get wireless.$IFACE5.key)"
  [ -z "$OLD_KEY" ] && OLD_KEY='1234567890'

  uci set wireless.$IFACE5.mode='ap'
  uci set wireless.$IFACE5.network='lan'
  uci set wireless.$IFACE5.disabled='0'
  uci set wireless.$IFACE5.hidden='0'
  uci set wireless.$IFACE5.encryption='psk2'
  uci set wireless.$IFACE5.key="$OLD_KEY"

  uci -q delete wireless.$IFACE5.ieee80211w
  uci -q delete wireless.$IFACE5.ieee80211r
  uci -q delete wireless.$IFACE5.ieee80211k
  uci -q delete wireless.$IFACE5.bss_transition
  uci -q delete wireless.$IFACE5.wnm_sleep_mode
  uci -q delete wireless.$IFACE5.sae
  uci -q delete wireless.$IFACE5.owe
  uci -q delete wireless.$IFACE5.wpa_disable_eapol_key_retries
fi

uci commit wireless
exit 0
EOUCI

chmod +x files/etc/uci-defaults/99-airpi-5g-compat

echo
echo "=== 4. 注入结果 ==="
find files -maxdepth 6 \( \
  -name 'startwapp.sh' \
  -o -name 'wapp' \
  -o -name 'wapp.real' \
  -o -name 'wappctrl' \
  -o -name '100-startwapp' \
  -o -name '99-airpi-5g-compat' \
\) -print

echo
echo "Airpi WiFi/WAPP runtime fix applied."
