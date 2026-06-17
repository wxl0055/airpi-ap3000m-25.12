#!/usr/bin/env bash
set -euo pipefail

echo "===== Airpi import: verify OpenWrt root ====="
[ -d package ] || { echo "ERROR: package directory not found. Run inside OpenWrt source root."; exit 1; }
[ -x scripts/feeds ] || { echo "ERROR: scripts/feeds not found. Run inside OpenWrt source root."; exit 1; }

OLD_REPO="https://github.com/padavanonly/immortalwrt-mt798x-6.6.git"
OLD_BRANCH="openwrt-24.10-6.6"
OLD_DIR="/tmp/airpi-padavanonly-old-src"
DST_DIR="package/airpi-mtk-applications"
DEP_REPORT="$PWD/airpi-old-package-deps.txt"

echo "===== Airpi import: clone old source ====="
rm -rf "$OLD_DIR"
git clone --depth 1 -b "$OLD_BRANCH" "$OLD_REPO" "$OLD_DIR"

echo "===== Airpi import: copy selected old packages ====="
mkdir -p "$DST_DIR"

copy_pkg() {
  local name="$1"
  local src="$OLD_DIR/package/mtk/applications/$name"
  local dst="$DST_DIR/$name"

  if [ ! -d "$src" ]; then
    echo "ERROR: old package not found: $src"
    exit 1
  fi

  rm -rf "$dst"
  cp -a "$src" "$dst"
  echo "COPIED: $name"
}

# Airpi hardware / fan
copy_pkg "Airpi-gpio-fan"
copy_pkg "luci-app-Airpifanctrl"

# MTK management / switch / low-level tools
copy_pkg "luci-app-mtk"
copy_pkg "mii_mgr"
copy_pkg "switch"
copy_pkg "regs"
copy_pkg "ndisc"

# MTK WiFi / acceleration / QoS
copy_pkg "mtwifi-cfg"
copy_pkg "luci-app-mtwifi-cfg"
copy_pkg "luci-app-eqos-mtk"
copy_pkg "luci-app-turboacc-mtk"
copy_pkg "mtkhqos_util"
copy_pkg "mtk-smp"

# Traffic accounting from old package set
copy_pkg "wrtbwmon"
copy_pkg "luci-app-wrtbwmon"

echo "===== Airpi import: hard block unwanted packages from copied tree ====="
find "$DST_DIR" -maxdepth 2 -type d | grep -Ei 'openclash|istore|store|aurora' && {
  echo "ERROR: forbidden package directory copied"
  exit 1
} || true

echo "===== Airpi import: audit old package Makefile dependencies ====="
{
  echo "Airpi old package dependency audit"
  echo "old_repo=$OLD_REPO"
  echo "old_branch=$OLD_BRANCH"
  echo "generated_at=$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo

  find "$DST_DIR" -name Makefile | sort | while read -r mf; do
    echo "------------------------------------------------------------"
    echo "FILE: $mf"
    awk '
      /^[[:space:]]*PKG_NAME[[:space:]]*[:+?]?=/ {print}
      /^[[:space:]]*DEPENDS[[:space:]]*[:+?]?=/ {print}
      /^[[:space:]]*LUCI_DEPENDS[[:space:]]*[:+?]?=/ {print}
      /^[[:space:]]*LUCI_TITLE[[:space:]]*[:+?]?=/ {print}
      /^[[:space:]]*TITLE[[:space:]]*[:+?]?=/ {print}
      /^[[:space:]]*CATEGORY[[:space:]]*[:+?]?=/ {print}
      /^[[:space:]]*SUBMENU[[:space:]]*[:+?]?=/ {print}
      /^define Package\// {print}
      /^define KernelPackage\// {print}
    ' "$mf"
    echo
  done
} > "$DEP_REPORT"

cat "$DEP_REPORT"

echo "===== Airpi import: add daed feed ====="
if ! grep -q 'openwrt-daede' feeds.conf.default 2>/dev/null; then
  echo "src-git daede https://github.com/kenzok8/openwrt-daede.git" >> feeds.conf.default
fi

echo "===== Airpi import: update/install daed feed ====="
./scripts/feeds update daede
./scripts/feeds install -a -p daede

echo "===== Airpi import: required package directories check ====="
for d in \
  "$DST_DIR/Airpi-gpio-fan" \
  "$DST_DIR/luci-app-Airpifanctrl" \
  "$DST_DIR/luci-app-mtk" \
  "$DST_DIR/mii_mgr" \
  "$DST_DIR/switch" \
  "$DST_DIR/mtwifi-cfg" \
  "$DST_DIR/luci-app-mtwifi-cfg" \
  "$DST_DIR/luci-app-eqos-mtk" \
  "$DST_DIR/luci-app-turboacc-mtk" \
  "$DST_DIR/wrtbwmon" \
  "$DST_DIR/luci-app-wrtbwmon"
do
  [ -d "$d" ] || { echo "ERROR: missing imported package directory: $d"; exit 1; }
done

echo "===== Airpi import: done ====="
