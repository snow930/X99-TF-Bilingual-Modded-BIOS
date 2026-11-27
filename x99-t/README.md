# 华南金牌 X99-T8 GAMING V6.0 双语全动态鸡血 + IA/CLR 独立调压 + 原生 ReBAR 刷写套件

基于华南金牌官网最新 **X99-T8 GAMING V6.0** 官方 BIOS `T8V60.bin`（2026-04-17，`$FID = HN368001`，来源：<https://www.huananzhi.com/list_6/648.html>）按 [X99-TF V3.0 魔改版](../V3.0/README.md) 体系深度定制，并完整保留 V6.0 官方原生特性与 `X99-T8` 原厂 DMI/SMBIOS 信息。

> **刷写有风险，请务必在刷写前备份原片并确认主板型号为华南金牌 X99-T8 GAMING V6.0（8 条 DDR3 插槽，Intel C612，16 MB SPI Flash）。推荐优先运行 `FLASH_WINDOWS_T8_BIOS_ONLY.bat` 仅刷 8 MB BIOS 区。**

---

## 一、核心架构与魔改特性

1. **原厂基底 + 完整保留 `X99-T8` 硬件与 DMI 标识**：
   - `T8ZH_V60.ROM` 前 8 MB（Flash Descriptor / IFD + Intel ME）与官网原版 `T8V60.bin` 逐字节一致（完整保留 V6.0 PCH Straps 及 Winbond `EF 40 18` / EON `1C 71 18` SPI VSCC 表）；
   - 后 8 MB BIOS 区完整保留官方 `DAF4BF89` SMBIOS 静态数据（`HUANANZHI / X99-T8 / V6.0 / HNZ-202604172026`），并在套件内随附官网 T8 V6.0 新版 `fparts.txt`（支持 `W25Q128`、`EN25QX128A`、`FM25W128`、`XM25QH128D`、`GD25Q128E` 等 16 MB SPI 芯片）。
2. **`A134C001` 全动态菜单联动鸡血与 IA/CLR 独立负压引擎**：
   - 完整重定位适配 V6.0 `IntelSetup` 结构体（`DataSize = 0x17A4`、`OverClocking Feature = 0x15F8`、`Core Max OC Ratio = 0x161A`、`Core Voltage Offset = 0x161E/0x1620`、`CLR Max OC Ratio = 0x1655`、`CLR Voltage Offset = 0x1659/0x165B`、`CLR Min Ratio = 0x1780`）；
   - **总闸门**：绑定 `超频功能总开关`（默认 `启用`），设为 `禁用` 即可一键跳过全部调压与鸡血修改；
   - **IA / CLR 独立负压**：动态读取核心/环形总线偏移设置，独立写入 `MSR 0x150` Plane 0 / Plane 2（支持 `-20 ~ -110 mV`，`5 mV` 步进，默认 `0 mV` 零风险）；
   - **SDM 标准硬件自检**：严格按 `wrmsr(0x8B, 0) → cpuid(1) → rdmsr(0x8B)` 检测，仅当 `CPUID == 0x306F2` 且 `MSR 0x8B == 0` 时执行 Haswell-EP 全核睿频解锁；更换 E5 v4 等带微码 CPU 时自动跳过倍频解锁；
   - **智能功耗墙放宽 (`MSR 0x610`)**：未锁定时自动将低于甜点线的默认 TDP 平滑放宽至 `PL1 = 220W / PL2 = 250W`，同时保留用户在 `SOCKET RAPL Config` 中设定的更高值或主动锁定限制。
3. **精准微码清理（兼容 E5 v3 鸡血与 E5 v4 直插）**：
   - 从 `FV_BB` 与 FIT 表中仅彻底移除 `0x306F2`（Haswell-EP 正式版微码），完整保留 `0x306F1`、`0x406F0` 与 **`0x406F1` rev `0x0B00002E`（Broadwell-EP E5 v4 正式版）**。
4. **官方原生 Resizable BAR（免 `ReBarState.exe`）**：
   - 启用 V6.0 `PciBus` 内置 PCIe Extended Capability `0x15` 原生 ReBAR 引擎，默认开启 `Re-Size BAR 显存智取` 与 `Above 4G Decoding`、关闭 `CSM Support`，清 CMOS 后开箱生效。
5. **专业中英双语界面 + 同源 16px 点阵 0 缺字字库**：
   - 完整汉化 `Setup`、`PlatformSetup` 与 `AMITSE`（含 V6.0 新版 `F3 / F4 / <K> / <M>` 快捷键提示），右栏 Help 首行置顶 `[Original English Name]` 并附 `[本固件]` 生效说明；
   - `AMITSE` 嵌入同源 `SimSun 16px` 1bpp 点阵字库（`103` 窄 + `807` 宽），全固件 **0 缺字**。
6. **四处开箱即用默认值全同步**（`FV_NVRAM`、`9221315B`、`FE612B72 ($SPF)` 及 `Setup`/`Platform` IFR）：
   - `OverClocking Feature = Enabled`、`Overclocking Lock = Disable`
   - `CPU C State = Enable`、`Package C State limit = C2 state`、`CPU C3/C6 report = Disable`
   - `Above 4G Decoding = Enabled`、`Re-Size BAR Support = Enabled`、`CSM Support = Disabled`
   - `ACPI Sleep State (S3) = Disabled`
   - 完整保留 V6.0 原厂新增特性：TPM 1.2 / 2.0 / TCM、SmartFan IV 温控、S5 RTC 定时开机、HDD Security、NVMe 信息页、`PCH DMI ASPM = Disabled` 与 `PCIe L1 Substates = Disabled`。
7. **Windows 11 24H2 / 25H2 微软签名级微码安全旁路 (`WIN11_MCUPDATE_TOGGLE.bat`)**：
   - 原位使用微软原生 WHQL 签名的 `mcupdate_AuthenticAMD.dll` 占位替代 `mcupdate_GenuineIntel.dll`（自动双备份并恢复 `TrustedInstaller` 权限），避免直接删/改名导致的开机修复循环。

---

## 二、目录结构与校验值

```text
x99-t/
├─ T8ZH_V60_8M.bin                 # 8MB BIOS 区镜像（推荐首选，不动原厂 IFD/ME）
├─ T8ZH_V60.ROM                    # 16MB 完整镜像（官方 T8V60 IFD/ME + 魔改 BIOS 区）
├─ FLASH_WINDOWS_T8_BIOS_ONLY.bat  # Windows 首选：自动提权 + 备份 + 仅刷 8MB BIOS 区
├─ FLASH_WINDOWS_T8_FULL.bat       # Windows 备用：自动提权 + 备份 + 16MB 整片刷写
├─ X_T8.bat / X_T8_NOBACKUP.bat    # DOS：16MB 整片刷写脚本
├─ WIN11_MCUPDATE_TOGGLE.bat       # Windows 11 24H2/25H2 微软签名微码旁路脚本
├─ fpt.exe / fptw64.exe / fparts.txt / idrvdll32e.DLL / pmxdll32e.DLL
├─ README.md                       # 本说明文档
└─ bak/
   └─ T8V60.bin                    # 官方原厂 X99-T8 V6.0 (2026-04-17) 默认 BIOS 备份
```

| 文件 | 大小 (Bytes) | MD5 | SHA-256 |
|---|---:|---|---|
| **`T8ZH_V60_8M.bin`** | 8,388,608 | `6d385b39adaf7ee8aaa0aba9d38c7a0e` | `2b2c4ac51d7c5e4ff7de2fd3a662b8e333cfaf2d91bfc546921e7e254443dd08` |
| **`T8ZH_V60.ROM`** | 16,777,216 | `40924d3a9b3a6ace9fb5ce5e5479b98f` | `f1435cef10f5224c08a593eec3365bed4e158357cbb889372dbac5c946dfbc65` |
| `bak/T8V60.bin` | 16,777,216 | `dc530df83a95d1a9346904db04e81ebe` | `756653ac9fecd13ac7c627966faaf79f7d618e14bad381532f0a5070deabad79` |

---

## 三、刷写与启用流程

### 第一步：刷入固件
- **Windows 推荐方式（仅刷 8 MB BIOS 区）**：将 `x99-t` 目录置于纯英文短路径下，右键 **`FLASH_WINDOWS_T8_BIOS_ONLY.bat`** → **以管理员身份运行**（自动备份 `BACKUP_BIOS_PRE_T8V60.BIN` 后刷入 `T8ZH_V60_8M.bin`，FPT 提示时按 `Y`）。
- **Windows 整片刷写（16 MB）**：如确需整片写入原生 V6.0 IFD/ME + BIOS，可运行 **`FLASH_WINDOWS_T8_FULL.bat`** 刷入 `T8ZH_V60.ROM`。
- **DOS 方式**：复制到 FreeDOS U 盘根目录启动，运行 `X_T8.bat` 并按 `Y`。

### 第二步：清 CMOS 并按需调整降压/倍频
1. 刷完关机拔电清 CMOS，或进 BIOS 按 **`F3`** 加载优化默认值并按 **`F4`** 保存重启（V6.0 快捷键为 `F3 / F4`）；
2. 此时 `OverClocking Feature`、`Above 4G`、`Re-Size BAR`、`CSM Off`、`C2 限制 / C6 关闭` 均已默认生效，默认负压 `0 mV` 零风险；
3. 按需进入 **`Intel 平台设置 → 超频设置`** 调整降压与倍频（8 条 DDR3 满插/大内存建议参考下表）：

| BIOS 菜单路径（`Intel 平台设置 → 超频设置`） | 推荐值 | 说明 |
|---|---|---|
| `超频设置 → 超频功能总开关` | `启用`（已默认） | 动态鸡血与调压总开关 |
| `处理器核心 (Core) → 核心最大超频倍频` | `0`（自动满血）或 `36` | `0` 自动解锁全核最高睿频；长时满载降温可按需手动限频 |
| `处理器核心 (Core) → 核心电压偏移 / 偏移符号` | `50` ~ `65` / `[-]` | 建议从 `-50 mV` 起步做烤机稳定性测试 |
| `环形总线 (CLR/Ring) → 环形总线最大倍频` | `28` 或 `29`（默认 `0`=30） | 8 条 DDR3 大内存高负载下退 1~2 档可提升缓存与 IMC 稳定性 |
| `环形总线 (CLR/Ring) → 环形总线电压偏移 / 偏移符号` | `35` ~ `45` / `[-]` | 配合多条 DDR3 内存建议避免缓存降压过深报 WHEA |
| `CPU C 状态控制 → 封装 C 状态限制 / CPU C6 报告` | `C2 状态` / `禁用`（已默认） | 防止大幅负压下轻重负载切换瞬间掉压冻屏 |

### 第三步：开启 Windows 11 微码安全旁路
- 进入 Windows，双击运行 **`WIN11_MCUPDATE_TOGGLE.bat`** 按 `Y` 启用微软签名微码旁路（再次运行可查看状态或按 `R` 无损还原；**切勿手动直接删除 `System32\mcupdate_GenuineIntel.dll`**）；
- 本版采用官方 V6.0 原生 ReBAR，**无需运行 `ReBarState.exe`**，重启系统后即可在 HWiNFO / CPU-Z / GPU-Z 确认全核鸡血、独立负压与 Resizable BAR 全部生效。

---

## 四、版本回退说明

如需回退至官方原厂版，将 `bak\T8V60.bin` 复制至目录并执行 `fptw64.exe -f T8V60.bin`（或使用刷写前自动生成的 `BACKUP_BIOS_PRE_T8V60.BIN` 执行 `fptw64.exe -f BACKUP_BIOS_PRE_T8V60.BIN -bios`）；如需还原 Windows 原版 Intel 微码，运行 `WIN11_MCUPDATE_TOGGLE.bat` 按 `R` 即可一键恢复。
