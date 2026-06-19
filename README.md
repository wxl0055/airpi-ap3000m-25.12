# Airpi AP3000M ImmortalWrt 25.12

## 近期两次关键修复

### 1. 风扇控制修复
已将 Airpi AP3000M 风扇控制逻辑按实机验证结果固化为新的运行时方案。

**问题表现：**
- 旧插件会写错 PWM 节点；
- 缺少默认配置文件；
- 固定模式与智能模式可能互相覆盖；
- 临时热修脚本会和正式逻辑冲突；
- 内核 thermal 会自动接管 pwm-fan，导致手动档位被拉回。

**解决思路：**
- 默认模式改为 **智能模式**；
- 默认温度来源改为 **CPU 温度**；
- 统一使用 `fan-write-duty`、`airpi-fan-set`、`fancts.sh` 这套运行链；
- 禁用 `thermal_zone0/mode` 对 PWM 风扇的自动接管；
- 保留模组温度作为备用能力，但不默认启用。

### 2. LAN 拔线后网络异常修复
已确认 LAN 网线拔掉后 Wi‑Fi / DNS / SSH / daed 异常的根因不在 DNS，也不在 daed，而是在新版 HNAT 自动检测逻辑。

**问题根因：**
- `hnat-detect` 会把 `wwan0_1` 识别为 ext device；
- 自动创建 `rxppd` 并挂入 `br-lan`；
- 在 `eth0` 拔线后，`rxppd + br-lan + HNAT` 状态异常；
- 导致 DNS 回包虽已到达，但应用层链路表现异常。

**解决思路：**
- 保留 **HNAT / WARP / TurboACC**；
- 禁用 `hnat-detect` 的自动 hotplug / ucode 逻辑；
- 防止 `rxppd` 自动挂入 `br-lan`；
- 目标不是关闭加速，而是移除错误的自动桥接逻辑，恢复稳定网络行为。



Airpi AP3000M 专用的自定义 ImmortalWrt 25.12 固件项目。

本项目已经作为独立仓库维护，后续所有修改、构建和发布均以本仓库为准，不再作为旧项目分支使用。

当前项目重点面向 **Airpi AP3000M / MT7981 / Filogic** 平台，保留常用功能并持续修正 MTK 无线、QModem、默认配置和设备适配相关问题。

## 项目特点

- 面向 Airpi AP3000M 5G CPE
- 基于 ImmortalWrt 25.12 / Filogic 平台
- 使用 MTK 闭源无线驱动栈
- 保留 QModem、MTK 无线配置、TurboACC、EQoS、网页终端等常用功能
- 作为独立项目持续维护，不再依赖旧项目仓库进行日常修改

## dae / daed 依赖说明

本项目当前已经预留并集成 `dae` / `daed` 所需运行依赖，方便后续按需启用相关功能。

当前依赖方向包括：

- `ca-bundle`
- `kmod-sched-core`
- `kmod-sched-bpf`
- `kmod-veth`
- `kmod-xdp-sockets-diag`
- `kmod-nft-tproxy`

因此，本项目后续可以继续在不重做基础环境的前提下接入 `dae` / `daed`。

## 当前项目定位

这是一个针对 Airpi AP3000M 的定制构建工程，目标不是通用整合包，而是：

- 提供可重复编译的固件工程
- 保留适合 AP3000M 的常用插件和默认配置
- 修复 MTK 无线和设备适配相关问题
- 作为后续版本迭代的唯一主仓库

## 默认信息

- 默认主机名：`Airpi`
- 默认 LAN 地址：`192.168.88.1`
- 默认登录密码：无

## 主要功能方向

### 网络与系统
- 防火墙
- 软件包管理
- 文件管理
- UPnP
- 网页终端（ttyd）
- 自动重启
- 流量监控

### 调制解调器 / 蜂窝网络
- QModem
- Modem 管理与拨号支持
- 短信相关功能（随当前配置保留）

### MTK 平台相关
- MTK 无线配置页面
- MTK TurboACC
- MTK EQoS
- MTK 闭源无线驱动适配
- 设备默认脚本与兼容处理

### 设备定制
- Airpi 风扇控制
- Airpi 默认网络与初始化脚本
- 自定义构建脚本
- GitHub Actions 自动构建工作流

## 仓库结构

### `.github/workflows`
自动编译工作流配置。  
主要控制源码拉取、构建流程、打包和发布。

### `Scripts`
自定义构建脚本。  
主要负责应用定制逻辑、导入文件、修正配置和处理特殊构建流程。

### `Config`
构建配置文件。  
用于控制默认包含的软件包、设备特性和构建选项。

### `files`
会直接打包进固件的默认文件。  
例如：

- 默认网络设置
- uci-defaults 脚本
- 设备初始化脚本
- hotplug 脚本
- 自定义兼容修复文件

## 参考与引用项目

以下项目是本仓库过去参考过、或当前仍在实际引用的主要来源。

### 旧项目 / 参考项目
- 旧项目仓库：  
  `https://github.com/yizhanghong/airpi_cli`

- 旧项目早期源码来源：  
  `https://github.com/padavanonly/immortalwrt-mt798x-6.6.git`

- 旧项目中使用过的配套 U-Boot 发布地址：  
  `https://github.com/VIKINGYFY/UBOOT-CI/releases`

### 当前实际引用 / 当前主线
- 当前 25.12 MT798x 主线上游：  
  `https://github.com/chasey-dev/immortalwrt-mt798x-rebase`

- 当前 QModem 官方项目：  
  `https://github.com/FUjr/QModem`

- 当前 dae / daed 参考项目：  
  `https://github.com/kenzok8/openwrt-daede`

## 维护说明

本仓库已经是独立项目。  
后续建议的维护方式：

1. 所有修改直接提交到本仓库
2. 所有新功能都优先在本仓库验证
3. 尽量减少旧项目残留逻辑
4. 优先保留当前已验证可工作的主链
5. 对 MTK 无线、QModem 和默认脚本问题持续做实机验证

## 已知重点问题

### 1. MTK 无线配置链与旧包混装问题
旧配置链与新的 25.12 MTK 配置链可能出现文件冲突。  
当前项目已经处理过 `luci-app-mtk` 与 `l1dat` 冲突问题，并保留主配置链继续维护。

### 2. 5G 无线行为仍需持续验证
当前固件已经成功编译，但 MTK 闭源无线仍可能存在：

- 5G 广播正常但连接异常
- BSSID / MAC 行为异常
- factory / EEPROM 缺失时退回默认 BIN
- 自动选信道和 HT/HE 参数异常

这部分仍需要通过实机继续审计和验证。

### 3. factory / EEPROM 数据问题
如果 factory 分区为空、异常或与当前驱动预期不一致，可能会影响无线行为。  
涉及 EEPROM / 校准数据 / U-Boot / 分区的操作，请务必谨慎。

## 使用建议

刷机前建议确认：

- 目标机型确实是 Airpi AP3000M
- 当前 U-Boot 与分区布局兼容
- 是否保留旧配置
- 是否需要先备份关键分区

刷机后建议优先检查：

- `uci get network.lan.ipaddr`
- `ubus call system board`
- `logread | tail -n 200`
- `/etc/config/wireless`
- `iwinfo`
- QModem 页面
- MTK 无线配置页面

## 致谢

感谢以下项目和维护者提供的基础能力与参考：

- ImmortalWrt
- MTK / Filogic 相关上游项目
- QModem 项目维护者
- dae / daed 项目维护者
- 以及所有为 Airpi AP3000M 适配提供参考的人
