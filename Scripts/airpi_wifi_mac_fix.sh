#!/usr/bin/env bash
set -euo pipefail

echo "============================================================"
echo " Apply Airpi AP3000M WiFi MAC fix"
echo " 修复：phy0/phy1 分配不同 WiFi MAC，避免 ra0/rax0 BSSID 相同"
echo "============================================================"

echo
echo "=== Runtime paths ==="
echo "PWD=${PWD}"
echo "GITHUB_WORKSPACE=${GITHUB_WORKSPACE:-}"
echo "HOME=${HOME:-}"

TARGET_REL="target/linux/mediatek/filogic/base-files/etc/hotplug.d/ieee80211/11_fix_wifi_mac"

FIX_FILE=""

# 1. 优先查常见 OpenWrt 源码目录
for d in \
  "${PWD}" \
  "${GITHUB_WORKSPACE:-}" \
  "${GITHUB_WORKSPACE:-}/openwrt" \
  "${GITHUB_WORKSPACE:-}/immortalwrt" \
  "${GITHUB_WORKSPACE:-}/source" \
  "/workdir/openwrt" \
  "/workdir/immortalwrt" \
  "/workdir/source" \
  "/home/runner/work" \
  "/home/runner"
do
  [ -n "$d" ] || continue
  [ -d "$d" ] || continue

  if [ -f "$d/$TARGET_REL" ]; then
    FIX_FILE="$d/$TARGET_REL"
    break
  fi
done

# 2. 如果常见目录没找到，再做有限搜索
if [ -z "$FIX_FILE" ]; then
  echo
  echo "=== Common paths not found, searching limited locations ==="

  for d in "/workdir" "/home/runner/work" "${GITHUB_WORKSPACE:-}"; do
    [ -n "$d" ] || continue
    [ -d "$d" ] || continue

    FOUND="$(find "$d" -path "*/$TARGET_REL" -type f 2>/dev/null | head -n 1 || true)"
    if [ -n "$FOUND" ]; then
      FIX_FILE="$FOUND"
      break
    fi
  done
fi

if [ -z "$FIX_FILE" ]; then
  echo "ERROR: 找不到 11_fix_wifi_mac"
  echo
  echo "=== Debug: top-level dirs ==="
  ls -la "${GITHUB_WORKSPACE:-.}" || true
  ls -la /workdir 2>/dev/null || true
  ls -la /home/runner/work 2>/dev/null || true
  exit 1
fi

echo
echo "Target file: $FIX_FILE"

if grep -q 'airpi,ap3000m)' "$FIX_FILE"; then
  echo
  echo "airpi,ap3000m 分支已存在，不重复插入。"
  grep -nA6 -B2 'airpi,ap3000m)' "$FIX_FILE" || true
  exit 0
fi

python3 - "$FIX_FILE" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text()
lines = text.splitlines(True)

insert_block = [
'\tairpi,ap3000m)\n',
'\t\tbase_mac=$(macaddr_generate_from_mmc_cid mmcblk0)\n',
'\t\t[ "$PHYNBR" = "0" ] && macaddr_add $base_mac 2 > /sys${DEVPATH}/macaddress\n',
'\t\t[ "$PHYNBR" = "1" ] && macaddr_add $base_mac 3 > /sys${DEVPATH}/macaddress\n',
'\t\t;;\n',
]

insert_at = None

# 优先插在 asus,rt-ax59u 前面
for i, line in enumerate(lines):
    if re.match(r'^\s*asus,rt-ax59u\)', line):
        insert_at = i
        break

# 兜底插在 bananapi,bpi-r3 前面
if insert_at is None:
    for i, line in enumerate(lines):
        if re.match(r'^\s*bananapi,bpi-r3', line):
            insert_at = i
            break

# 最后兜底：插在第一个已有 board case 后面
if insert_at is None:
    for i, line in enumerate(lines):
        if re.match(r'^\s*[a-z0-9*_-]+,[a-z0-9*._-]+\)', line):
            insert_at = i
            break

if insert_at is None:
    raise SystemExit("ERROR: 未找到合适插入点，未修改文件。")

new_lines = lines[:insert_at] + insert_block + lines[insert_at:]
path.write_text(''.join(new_lines))
PY

echo
echo "=== 插入后的 Airpi 分支 ==="
grep -nA6 -B2 'airpi,ap3000m)' "$FIX_FILE"

echo
echo "Airpi WiFi MAC fix applied."
