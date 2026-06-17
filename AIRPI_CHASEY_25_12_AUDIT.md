# Airpi chasey 25.12 audit report

Generated at: 2026-06-17T20:54:35+08:00

Repository: `/home/xuelingwang/airpi_cli`

Branch:

```text
airpi-chasey-25.12
```


### Git status

```text
 D Scripts/airpi_wifi_mac_fix.sh
 D Scripts/airpi_wifi_wapp_fix.sh
?? .github/workflows/Airpi-Chasey-25.12.yml
?? AIRPI_CHASEY_25_12_AUDIT.md
?? AIRPI_CHASEY_25_12_NOTES.md
?? Scripts/apply_chasey_25_12_full.sh
?? files/
?? legacy_disabled/
```

### Generated chasey files

```text
.github/workflows/Airpi-Chasey-25.12.yml
.github/workflows/WRT-CORE.yml
.github/workflows/Cache-Clean.yml
.github/workflows/WRT-TEST.yml
.github/workflows/CI-798X-237_2410_66.yml
.github/workflows/CWRT-ALL.yml
Scripts/Handles.sh
Scripts/Settings.sh
Scripts/Packages.sh
Scripts/apply_chasey_25_12_full.sh
files/usr/sbin/airpi-qmodem-autostart.sh
files/etc/uci-defaults/99-airpi-oldfw-network
files/etc/init.d/airpi-qmodem-autostart
```

### Workflow source branch / repo

```text
.github/workflows/Airpi-Chasey-25.12.yml:1:name: Airpi Chasey 25.12 QModem
.github/workflows/Airpi-Chasey-25.12.yml:12:  SOURCE_REPO: https://github.com/chasey-dev/immortalwrt-mt798x-rebase.git
.github/workflows/Airpi-Chasey-25.12.yml:13:  SOURCE_BRANCH: 25.12
.github/workflows/Airpi-Chasey-25.12.yml:43:            echo "These scripts must not run on chasey 25.12."
.github/workflows/Airpi-Chasey-25.12.yml:47:      - name: Clone chasey-dev 25.12
.github/workflows/Airpi-Chasey-25.12.yml:49:          git clone -b "$SOURCE_BRANCH" --single-branch --filter=blob:none "$SOURCE_REPO" wrt
.github/workflows/Airpi-Chasey-25.12.yml:59:      - name: Apply Airpi qmodem 25.12 full config
.github/workflows/Airpi-Chasey-25.12.yml:62:          bash "$GITHUB_WORKSPACE/Scripts/apply_chasey_25_12_full.sh"
.github/workflows/Airpi-Chasey-25.12.yml:87:          name: Airpi-qmodem-chasey-25.12
.github/workflows/WRT-TEST.yml:18:        default: 'padavanonly/immortalwrt-mt798x-6.6'
.github/workflows/WRT-TEST.yml:22:         - padavanonly/immortalwrt-mt798x-6.6
.github/workflows/CI-798X-237_2410_66.yml:66:      WRT_REPO: https://github.com/padavanonly/immortalwrt-mt798x-24.10.git
.github/workflows/CWRT-ALL.yml:52:          - {SOURCE: "padavanonly/immortalwrt-mt798x-6.6", BRANCH: "openwrt-24.10-6.6"}
```

### Legacy script execution in workflows

```text
.github/workflows/Airpi-Chasey-25.12.yml:41:          if grep -RInE 'airpi_wifi_mac_fix|airpi_wifi_wapp_fix|11_fix_wifi_mac' Scripts .github/workflows files Config 2>/dev/null; then
.github/workflows/WRT-CORE.yml:164:          $GITHUB_WORKSPACE/Scripts/Packages.sh
.github/workflows/WRT-CORE.yml:165:          $GITHUB_WORKSPACE/Scripts/Handles.sh
.github/workflows/WRT-CORE.yml:177:          $GITHUB_WORKSPACE/Scripts/Settings.sh
.github/workflows/WRT-CORE.yml:198:        run: bash $GITHUB_WORKSPACE/Scripts/airpi_wifi_mac_fix.sh
.github/workflows/WRT-CORE.yml:200:        run: bash $GITHUB_WORKSPACE/Scripts/airpi_wifi_wapp_fix.sh
.github/workflows/CI-798X-237_2410_66.yml:206:          #$GITHUB_WORKSPACE/Scripts/Packages.sh
.github/workflows/CI-798X-237_2410_66.yml:208:          $GITHUB_WORKSPACE/Scripts/Handles.sh
.github/workflows/CI-798X-237_2410_66.yml:232:          $GITHUB_WORKSPACE/Scripts/Settings.sh
```

### Unwanted packages in workflows/scripts/config

```text
Scripts/Packages.sh:49:UPDATE_PACKAGE "aurora" "eamonxg/luci-theme-aurora" "master"
Scripts/apply_chasey_25_12_full.sh:73:# CONFIG_PACKAGE_luci-app-openclash is not set
Scripts/apply_chasey_25_12_full.sh:74:# CONFIG_PACKAGE_luci-app-istorex is not set
Scripts/apply_chasey_25_12_full.sh:75:# CONFIG_PACKAGE_luci-app-istore is not set
Scripts/apply_chasey_25_12_full.sh:76:# CONFIG_PACKAGE_luci-app-store is not set
Scripts/apply_chasey_25_12_full.sh:77:# CONFIG_PACKAGE_luci-theme-aurora is not set
Scripts/apply_chasey_25_12_full.sh:83:  -e '/CONFIG_PACKAGE_luci-app-openclash[= ]/d' \
Scripts/apply_chasey_25_12_full.sh:84:  -e '/CONFIG_PACKAGE_luci-app-istorex[= ]/d' \
Scripts/apply_chasey_25_12_full.sh:85:  -e '/CONFIG_PACKAGE_luci-app-istore[= ]/d' \
Scripts/apply_chasey_25_12_full.sh:86:  -e '/CONFIG_PACKAGE_luci-app-store[= ]/d' \
Scripts/apply_chasey_25_12_full.sh:87:  -e '/CONFIG_PACKAGE_luci-theme-aurora[= ]/d' \
Scripts/apply_chasey_25_12_full.sh:91:# CONFIG_PACKAGE_luci-app-openclash is not set
Scripts/apply_chasey_25_12_full.sh:92:# CONFIG_PACKAGE_luci-app-istorex is not set
Scripts/apply_chasey_25_12_full.sh:93:# CONFIG_PACKAGE_luci-app-istore is not set
Scripts/apply_chasey_25_12_full.sh:94:# CONFIG_PACKAGE_luci-app-store is not set
Scripts/apply_chasey_25_12_full.sh:95:# CONFIG_PACKAGE_luci-theme-aurora is not set
Scripts/apply_chasey_25_12_full.sh:108:if grep -E 'CONFIG_PACKAGE_luci-app-(openclash|istorex|istore|store)=y|CONFIG_PACKAGE_luci-theme-aurora=y' .config; then
Config/GENERAL.txt:71:CONFIG_PACKAGE_luci-theme-aurora=y
AIRPI_CHASEY_25_12_NOTES.md:34:- luci-app-openclash
AIRPI_CHASEY_25_12_NOTES.md:35:- luci-app-istorex
AIRPI_CHASEY_25_12_NOTES.md:36:- luci-app-istore
AIRPI_CHASEY_25_12_NOTES.md:37:- luci-app-store
AIRPI_CHASEY_25_12_NOTES.md:38:- luci-theme-aurora
```

### WiFi/MAC/WAPP risky references

```text
.github/workflows/Airpi-Chasey-25.12.yml:41:          if grep -RInE 'airpi_wifi_mac_fix|airpi_wifi_wapp_fix|11_fix_wifi_mac' Scripts .github/workflows files Config 2>/dev/null; then
.github/workflows/WRT-CORE.yml:198:        run: bash $GITHUB_WORKSPACE/Scripts/airpi_wifi_mac_fix.sh
.github/workflows/WRT-CORE.yml:199:      - name: Apply Airpi WiFi/WAPP runtime fix
.github/workflows/WRT-CORE.yml:200:        run: bash $GITHUB_WORKSPACE/Scripts/airpi_wifi_wapp_fix.sh
files/etc/uci-defaults/99-airpi-oldfw-network:97:set wireless.MT7981_1_1.phy='ra0'
files/etc/uci-defaults/99-airpi-oldfw-network:118:set wireless.MT7981_1_2.phy='rax0'
```

### Old WiFi repair scripts existence

```text
NOT FOUND: Scripts/airpi_wifi_mac_fix.sh
NOT FOUND: Scripts/airpi_wifi_wapp_fix.sh
```

### Old firmware network defaults

```text
files/etc/uci-defaults/99-airpi-oldfw-network:21:set network.lan.ipaddr='192.168.88.1'
files/etc/uci-defaults/99-airpi-oldfw-network:48:set network.2_1=interface
files/etc/uci-defaults/99-airpi-oldfw-network:49:set network.2_1.modem_config='2_1'
files/etc/uci-defaults/99-airpi-oldfw-network:50:set network.2_1.proto='dhcp'
files/etc/uci-defaults/99-airpi-oldfw-network:51:set network.2_1.metric='11'
files/etc/uci-defaults/99-airpi-oldfw-network:52:set network.2_1.ifname='wwan0_1'
files/etc/uci-defaults/99-airpi-oldfw-network:53:set network.2_1.device='wwan0_1'
files/etc/uci-defaults/99-airpi-oldfw-network:55:set network.2_1v6=interface
files/etc/uci-defaults/99-airpi-oldfw-network:56:set network.2_1v6.modem_config='2_1'
files/etc/uci-defaults/99-airpi-oldfw-network:57:set network.2_1v6.proto='dhcpv6'
files/etc/uci-defaults/99-airpi-oldfw-network:58:set network.2_1v6.metric='11'
files/etc/uci-defaults/99-airpi-oldfw-network:71:set firewall.@zone[1].name='wan'
files/etc/uci-defaults/99-airpi-oldfw-network:72:delete firewall.@zone[1].network
files/etc/uci-defaults/99-airpi-oldfw-network:73:add_list firewall.@zone[1].network='wan'
files/etc/uci-defaults/99-airpi-oldfw-network:74:add_list firewall.@zone[1].network='wan6'
files/etc/uci-defaults/99-airpi-oldfw-network:75:add_list firewall.@zone[1].network='2_1'
files/etc/uci-defaults/99-airpi-oldfw-network:76:add_list firewall.@zone[1].network='2_1v6'
files/etc/uci-defaults/99-airpi-oldfw-network:77:set firewall.@zone[1].input='REJECT'
files/etc/uci-defaults/99-airpi-oldfw-network:78:set firewall.@zone[1].output='ACCEPT'
files/etc/uci-defaults/99-airpi-oldfw-network:79:set firewall.@zone[1].forward='REJECT'
files/etc/uci-defaults/99-airpi-oldfw-network:80:set firewall.@zone[1].masq='1'
files/etc/uci-defaults/99-airpi-oldfw-network:81:set firewall.@zone[1].mtu_fix='1'
files/etc/uci-defaults/99-airpi-oldfw-network:113:set wireless.default_MT7981_1_1.ssid='Airpi-2.4G'
files/etc/uci-defaults/99-airpi-oldfw-network:135:set wireless.default_MT7981_1_2.ssid='Airpi-5G'
files/etc/uci-defaults/99-airpi-oldfw-network:137:set wireless.default_MT7981_1_2.key='1234567890'
files/etc/uci-defaults/99-airpi-oldfw-network:154:set qmodem.2_1=modem-device
files/etc/uci-defaults/99-airpi-oldfw-network:155:set qmodem.2_1.path='/sys/bus/usb/devices/2-1/'
files/etc/uci-defaults/99-airpi-oldfw-network:156:set qmodem.2_1.data_interface='usb'
files/etc/uci-defaults/99-airpi-oldfw-network:157:set qmodem.2_1.enable_dial='1'
files/etc/uci-defaults/99-airpi-oldfw-network:158:set qmodem.2_1.soft_reboot='1'
files/etc/uci-defaults/99-airpi-oldfw-network:159:set qmodem.2_1.extend_prefix='1'
files/etc/uci-defaults/99-airpi-oldfw-network:160:set qmodem.2_1.pdp_type='ipv4v6'
files/etc/uci-defaults/99-airpi-oldfw-network:161:set qmodem.2_1.state='enabled'
files/etc/uci-defaults/99-airpi-oldfw-network:162:set qmodem.2_1.metric='11'
files/etc/uci-defaults/99-airpi-oldfw-network:163:set qmodem.2_1.name='rg520f-eb'
files/etc/uci-defaults/99-airpi-oldfw-network:164:set qmodem.2_1.network='wwan0'
files/etc/uci-defaults/99-airpi-oldfw-network:165:set qmodem.2_1.manufacturer='quectel'
files/etc/uci-defaults/99-airpi-oldfw-network:166:set qmodem.2_1.platform='qualcomm'
files/etc/uci-defaults/99-airpi-oldfw-network:167:set qmodem.2_1.wcdma_band='1/5/8'
files/etc/uci-defaults/99-airpi-oldfw-network:168:set qmodem.2_1.lte_band='1/3/5/7/8/20/28/32/38/40/41/42/43/71'
files/etc/uci-defaults/99-airpi-oldfw-network:169:set qmodem.2_1.nsa_band='1/3/5/7/8/20/28/38/40/41/71/75/76/77/78'
files/etc/uci-defaults/99-airpi-oldfw-network:170:set qmodem.2_1.sa_band='1/3/5/7/8/20/28/38/40/41/71/75/76/77/78'
files/etc/uci-defaults/99-airpi-oldfw-network:171:set qmodem.2_1.at_port='/dev/ttyUSB2'
files/etc/uci-defaults/99-airpi-oldfw-network:172:set qmodem.2_1.valid_at_ports='/dev/ttyUSB2'
files/etc/uci-defaults/99-airpi-oldfw-network:174:delete qmodem.2_1.modes
files/etc/uci-defaults/99-airpi-oldfw-network:175:add_list qmodem.2_1.modes='qmi'
files/etc/uci-defaults/99-airpi-oldfw-network:176:add_list qmodem.2_1.modes='gobinet'
files/etc/uci-defaults/99-airpi-oldfw-network:177:add_list qmodem.2_1.modes='ecm'
files/etc/uci-defaults/99-airpi-oldfw-network:178:add_list qmodem.2_1.modes='mbim'
files/etc/uci-defaults/99-airpi-oldfw-network:179:add_list qmodem.2_1.modes='rndis'
files/etc/uci-defaults/99-airpi-oldfw-network:180:add_list qmodem.2_1.modes='ncm'
files/etc/uci-defaults/99-airpi-oldfw-network:182:delete qmodem.2_1.ports
files/etc/uci-defaults/99-airpi-oldfw-network:183:add_list qmodem.2_1.ports='/dev/ttyUSB0'
files/etc/uci-defaults/99-airpi-oldfw-network:184:add_list qmodem.2_1.ports='/dev/ttyUSB1'
files/etc/uci-defaults/99-airpi-oldfw-network:185:add_list qmodem.2_1.ports='/dev/ttyUSB2'
files/etc/uci-defaults/99-airpi-oldfw-network:186:add_list qmodem.2_1.ports='/dev/ttyUSB3'
files/usr/sbin/airpi-qmodem-autostart.sh:24:if ip link show wwan0_1 >/dev/null 2>&1; then
files/usr/sbin/airpi-qmodem-autostart.sh:25:    ip link set wwan0_1 up >/dev/null 2>&1 || true
files/usr/sbin/airpi-qmodem-autostart.sh:27:    ifup 2_1v6 >/dev/null 2>&1 || true
```

### Requested kept packages

```text
Scripts/Handles.sh:28:if [ -d *"luci-theme-argon"* ]; then
Scripts/Handles.sh:31:	cd ./luci-theme-argon/
Scripts/Handles.sh:33:	sed -i "s/primary '.*'/primary '#31a1a1'/; s/'0.2'/'0.5'/; s/'none'/'bing'/; s/'600'/'normal'/" ./luci-app-argon-config/root/etc/config/argon
Scripts/Handles.sh:79:DM_FILE="./luci-app-diskman/applications/luci-app-diskman/Makefile"
Scripts/Settings.sh:4:sed -i "s/luci-theme-bootstrap/luci-theme-$WRT_THEME/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")
Scripts/Packages.sh:48:UPDATE_PACKAGE "argon" "sbwml/luci-theme-argon" "openwrt-25.12"
Scripts/Packages.sh:50:UPDATE_PACKAGE "aurora-config" "eamonxg/luci-app-aurora-config" "master"
Scripts/Packages.sh:67:UPDATE_PACKAGE "luci-app-quickstart" "linkease/nas-packages-luci" "main" "pkg"
Scripts/Packages.sh:69:UPDATE_PACKAGE "diskman" "lisaac/luci-app-diskman" "master"
Scripts/Packages.sh:81:UPDATE_PACKAGE "viking" "VIKINGYFY/packages" "main" "" "luci-app-timewol luci-app-wolplus"
Scripts/Packages.sh:85:git clone https://github.com/timsaya/luci-app-bandix ./bandix
Scripts/Packages.sh:86:sed -i 's/Bandix 流量监控/流量监控/g' ./bandix/luci-app-bandix/po/zh_Hans/bandix.po
Scripts/apply_chasey_25_12_full.sh:46:CONFIG_PACKAGE_luci-theme-bootstrap=y
Scripts/apply_chasey_25_12_full.sh:47:CONFIG_PACKAGE_luci-theme-argon=y
Scripts/apply_chasey_25_12_full.sh:50:CONFIG_PACKAGE_luci-app-Airpifanctrl=y
Scripts/apply_chasey_25_12_full.sh:51:CONFIG_PACKAGE_luci-app-argon-config=y
Scripts/apply_chasey_25_12_full.sh:52:CONFIG_PACKAGE_luci-app-aurora-config=y
Scripts/apply_chasey_25_12_full.sh:53:CONFIG_PACKAGE_luci-app-autoreboot=y
Scripts/apply_chasey_25_12_full.sh:54:CONFIG_PACKAGE_luci-app-bandix=y
Scripts/apply_chasey_25_12_full.sh:55:CONFIG_PACKAGE_luci-app-diskman=y
Scripts/apply_chasey_25_12_full.sh:56:CONFIG_PACKAGE_luci-app-eqos-mtk=y
Scripts/apply_chasey_25_12_full.sh:57:CONFIG_PACKAGE_luci-app-filemanager=y
Scripts/apply_chasey_25_12_full.sh:58:CONFIG_PACKAGE_luci-app-firewall=y
Scripts/apply_chasey_25_12_full.sh:59:CONFIG_PACKAGE_luci-app-mtwifi-cfg=y
Scripts/apply_chasey_25_12_full.sh:60:CONFIG_PACKAGE_luci-app-package-manager=y
Scripts/apply_chasey_25_12_full.sh:61:CONFIG_PACKAGE_luci-app-qmodem-next=y
Scripts/apply_chasey_25_12_full.sh:62:CONFIG_PACKAGE_luci-app-quickstart=y
Scripts/apply_chasey_25_12_full.sh:63:CONFIG_PACKAGE_luci-app-ttyd=y
Scripts/apply_chasey_25_12_full.sh:64:CONFIG_PACKAGE_luci-app-turboacc-mtk=y
Scripts/apply_chasey_25_12_full.sh:65:CONFIG_PACKAGE_luci-app-upnp=y
Scripts/apply_chasey_25_12_full.sh:66:CONFIG_PACKAGE_luci-app-wolplus=y
Scripts/apply_chasey_25_12_full.sh:67:CONFIG_PACKAGE_luci-app-wrtbwmon=y
Scripts/apply_chasey_25_12_full.sh:68:CONFIG_PACKAGE_luci-app-xfrpc=y
Config/Airpi-qmodem-old.txt:15:#CONFIG_PACKAGE_luci-app-qmodem-next=y
Config/Airpi-qmodem.txt:15:CONFIG_PACKAGE_luci-app-qmodem-next=y
Config/GENERAL.txt:47:CONFIG_PACKAGE_luci-app-quickstart=y
Config/GENERAL.txt:50:CONFIG_PACKAGE_luci-app-autoreboot=y
Config/GENERAL.txt:57:CONFIG_PACKAGE_luci-app-upnp=y
Config/GENERAL.txt:58:CONFIG_PACKAGE_luci-app-wolplus=y
Config/GENERAL.txt:59:CONFIG_PACKAGE_luci-app-xfrpc=y
Config/GENERAL.txt:60:CONFIG_PACKAGE_luci-app-ttyd=y
Config/GENERAL.txt:61:CONFIG_PACKAGE_luci-app-filemanager=y
Config/GENERAL.txt:63:CONFIG_PACKAGE_luci-app-diskman=y
Config/GENERAL.txt:64:CONFIG_PACKAGE_luci-app-wrtbwmon=y
Config/GENERAL.txt:66:CONFIG_PACKAGE_luci-app-bandix=y
Config/GENERAL.txt:68:CONFIG_PACKAGE_luci-theme-bootstrap=y
Config/GENERAL.txt:69:CONFIG_PACKAGE_luci-theme-argon=y
Config/GENERAL.txt:70:CONFIG_PACKAGE_luci-app-argon-config=y
Config/GENERAL.txt:72:CONFIG_PACKAGE_luci-app-aurora-config=y
Config/GENERAL.txt:138:CONFIG_PACKAGE_luci-app-eqos-mtk=y
Config/GENERAL.txt:139:CONFIG_PACKAGE_luci-app-mtwifi-cfg=y
Config/GENERAL.txt:140:CONFIG_PACKAGE_luci-app-turboacc-mtk=y
.github/workflows/CI-798X-237_2410_66.yml:243:            #sed -i 's/network/status/g' ./package/mtk/applications/luci-app-wrtbwmon/root/usr/share/luci/menu.d/luci-app-wrtbwmon.json  || true
.github/workflows/CI-798X-237_2410_66.yml:247:            sed -i 's/services/nas/g' ./package/luci-app-wolplus/luasrc/controller/*.lua  || true
.github/workflows/CI-798X-237_2410_66.yml:248:            sed -i 's/services/nas/g' ./package/luci-app-wolplus/luasrc/view/wolplus/*.htm  || true
.github/workflows/CI-798X-237_2410_66.yml:257:            sed -i 's/services/network/g' ./package/mtk/applications/luci-app-eqos-mtk/root/usr/share/luci/menu.d/luci-app-eqos.json  || true
```

## Risk summary

- HIGH: workflow still calls legacy package/settings scripts. These may re-apply old WiFi/MAC/WAPP fixes or old package choices.
- HIGH: old WiFi/MAC repair scripts or references still exist. They must not run in chasey 25.12 build.
- MEDIUM: unwanted package is explicitly selected somewhere.
