# X99-2D3 V1.02（`X92D3006`）双语全动态鸡血 + IA/CLR 独立调压 + 原生 ReBAR 刷写套件

基于昂迅官网最新 **X99-2D3 V1.02** 官方 BIOS `X92D3006.bin`（`X99-2D3V1.02_TPM_006_LOW_SCORE_2026-7-8`，`$FID = X92D3006`，SMBIOS `INTEL / X99-2D3 / V1.02 / MB-202607082026`，构建日期 `07/08/2026`，来源：<http://angxunmb.com/web/userfiles/download/X99-2D3V1.02_TPM_006_LOW_SCORE_2026-7-8.rar>），按 [X99-TF V3.0 魔改版](../V3.0/README.md) 体系深度定制，完整保留原厂 IFD/ME、SMBIOS/DMI、开机 LOGO、TPM 1.2/2.0 协议栈及原生 `PciBus` Resizable BAR。

> **刷写有风险，请务必在刷写前备份原片并确认主板型号为 X99-2D3 V1.02（16 MB SPI Flash）。推荐优先运行 `FLASH_WINDOWS_2D3_BIOS_ONLY.bat` 仅刷 8 MB BIOS 区。**

---

## 一、核心架构与魔改特性

1. **原厂基底 + 完整保留硬件配置与 DMI/IFD/ME**：
   - `2D3ZH.ROM` 前 8 MB（Flash Descriptor / IFD + Intel ME）与官网原版 `X92D3006.bin` 逐字节一致；
   - 后 8 MB BIOS 区完整保留原厂 `DAF4BF89` SMBIOS 静态数据（`INTEL / X99-2D3 / V1.02 / MB-202607082026`）、`Logo.bmp`、TPM 1.2 / 2.0 协议栈、主板 PCIe/内存硬件默认配置及全部原厂 UEFI 驱动，并随附官方原版 `fparts.txt`。
2. **完整中英双语界面 + 同源 16px 点阵 0 缺字字库**：
   - 基于原厂英文 `AMITSE`（169 条）、`Setup`（975 条）与 `Platform`（5,721 条）完整汉化，右栏帮助首行置顶 `[Original English Name]` 英文原名对照，并在关键超频、调压、C-State、Above 4G、ReBAR 与 CSM 选项中补充 `[本固件]` 实际生效说明；
   - 在保留原厂 `AMITSE` 执行代码的前提下嵌入同源 `SimSun 16px` 1bpp 点阵字库（`103` 窄 + `814` 宽，共 `917` 字形），经校验覆盖全部 3 个模块全部词条，**全固件 0 缺字**。
3. **`A134C001` 全动态菜单联动鸡血与 IA/CLR 独立负压引擎**：
   - 精准匹配 X99-2D3 专属 `IntelSetup` 结构体（`DataSize = 0x17EC`、`OverClocking Feature = 0x163F`、`Core Max OC Ratio = 0x1661`、`Core Voltage Offset = 0x1665/0x1667`、`CLR Max OC Ratio = 0x169C`、`CLR Voltage Offset = 0x16A0/0x16A2`、`CLR Min Ratio = 0x17C8`），注入至 `FV_MAIN`（GUID `A134C001-0001-4C34-9A00-000000000001`）；
   - **总闸门**：绑定 `超频功能总开关`（`OverClocking Feature`，`0x163F`，已默认 `启用`），设为 `禁用` 即可一键跳过全部调压与鸡血修改；
   - **IA / CLR 独立负压**：动态读取核心与环形总线偏移设置，独立写入 `MSR 0x150` Plane 0 / Plane 2（仅处理负偏移 `20–110 mV`，`5 mV` 步进，默认 `0 mV` 零风险）；
   - **SDM 标准硬件自检**：严格按 `wrmsr(0x8B, 0) → cpuid(1) → rdmsr(0x8B)` 检测，仅当 `CPUID == 0x306F2` 且 `MSR 0x8B == 0` 时执行 Haswell-EP 全核睿频解锁；更换 E5 v4 等带微码 CPU 时自动跳过倍频解锁，仅保留动态调压；
   - **全核与 Ring 倍频联动 + 智能功耗墙放宽 (`MSR 0x610`)**：自动识别硬件熔丝最高单核睿频与最大 Ring 倍频，支持 `Core Max OC Ratio` / `CLR Max OC Ratio` / `CLR Min Ratio` 动态联动，未锁定时自动将默认 TDP 平滑放宽至 `PL1 = 220W / PL2 = 250W`（同时保留更高的手动设置或锁定限制）；最后置位 `MSR 0x194` bit 20 (`OC_LOCK`)。
4. **解锁隐藏超频与内存菜单（`Platform` IFR）**：
   - 解除 Xeon E5 非 K 处理器下对 **`超频设置`（`OverClocking Feature`，Form `0x03F0`）** 的 `SUPPRESS_IF` 隐藏限制，确保至强处理器可直接进入核心/环形总线倍频与调压菜单；
   - 同步解除 **`页面策略 / 内存训练`（`Page Policy / Memory Training`）** 与 **`XE 倍频限制`（`XE Ratio Limit`）** 的隐藏限制。
5. **精准微码清理（兼容 E5 v3 鸡血与 E5 v4 直插）**：
   - 从 `FV_BB` 微码区（`17088572`）与 FIT 表（`0xFFD90000`）中**仅彻底移除 `0x000306F2` rev `0x0000003D`**（Haswell-EP 正式版微码），完整保留 `0x000306F1`（`0x80000013`）、`0x000406F0`（`0x00000014`）、**`0x000406F1` rev `0x0B000038`（Broadwell-EP E5 v4 正式版）** 及 `MPDT` 尾表。
6. **官方原生 Resizable BAR（免 `ReBarDxe` 与 `ReBarState.exe`）**：
   - 经逐字节比对核验，原厂 `PciBus`（`3C1DE39F`，MD5 `ba7f04274d6e581953dca896c52339bb`）与 `X99-XD3` 同源，原生内置 PCIe Extended Capability `0x15` Resizable BAR 引擎（联动 `Setup[0x0048] Above 4G Decoding` 与 `Setup[0x0049] Re-Size BAR Support`）；
   - 已将 `大于 4G 地址解码`、`Resizable BAR 支持` 默认设为 **`启用`**、`CSM 兼容支持` 默认设为 **`禁用`**，清 CMOS 后开箱生效，**无需再运行 `ReBarState.exe`**。
7. **四处开箱即用默认值全同步**（`FV_NVRAM (StdDefaults)`、`9221315B`、`FE612B72 ($SPF)` 及 `Setup`/`Platform` IFR）：
   - `OverClocking Feature = Enabled`（`0x163F = 1`）、`Overclocking Lock = Disable`（`0x13FD = 1`）
   - `CPU C State = Enable`（`0x0069 = 1`）、`Package C State limit = C2 state`（`0x006C = 1`）、`CPU C3 report = Disable`（`0x006D = 0`）、`CPU C6 report = Disable`（`0x006E = 0`）
   - `Above 4G Decoding = Enabled`（`0x0048 = 1`）、`Re-Size BAR Support = Enabled`（`0x0049 = 1`）、`CSM Support = Disabled`（`0x0075 = 0`）
   - `ACPI Sleep State (S3) = Disabled`（`0x002A = 0`）
8. **Windows 11 24H2 / 25H2 微软签名级微码安全旁路 (`WIN11_MCUPDATE_TOGGLE.bat`)**：
   - 原位使用微软原生 WHQL 签名的 `mcupdate_AuthenticAMD.dll` 占位替代 `mcupdate_GenuineIntel.dll`（自动双备份并恢复 `TrustedInstaller` 权限），避免直接删/改名导致的开机修复循环。

---

## 二、目录结构与校验值

```text
X99-2D3/
├─ 2D3ZH_8M.bin                      # 8MB BIOS 区镜像（推荐首选，不动原厂 IFD/ME）
├─ 2D3ZH.ROM                         # 16MB 完整镜像（原厂 IFD/ME + 魔改 BIOS 区）
├─ FLASH_WINDOWS_2D3_BIOS_ONLY.bat   # Windows 首选：自动提权 + 备份 + 仅刷 8MB BIOS 区
├─ FLASH_WINDOWS_2D3_FULL.bat        # Windows 备用：自动提权 + 备份 + 16MB 整片刷写
├─ X_2D3.bat / X_2D3_NOBACKUP.bat    # DOS：16MB 整片刷写脚本
├─ WIN11_MCUPDATE_TOGGLE.bat         # Windows 11 24H2/25H2 微软签名微码旁路脚本
├─ fpt.exe / fptw64.exe / fparts.txt / idrvdll32e.DLL / pmxdll32e.DLL
├─ README.md                         # 本说明文档
└─ bak/
   └─ X92D3006.bin                   # 官方原厂 X99-2D3 V1.02 (2026-07-08) 底包备份（16MB）
```

| 文件 | 大小 (Bytes) | MD5 | SHA-256 |
|---|---:|---|---|
| **`2D3ZH_8M.bin`** | 8,388,608 | `4af09c6c75cf74d115b241712c36332b` | `810706b55c7a43df60d932d8d5f041da6a013cc4a55ae89c52d4270b9e085451` |
| **`2D3ZH.ROM`** | 16,777,216 | `e6e68e5c309f9bad2934bc550b8c5a58` | `f0da099e7667bab32c5d486a3b23986009e561956bb52b68fedf015c27a67dfc` |
| `bak/X92D3006.bin` | 16,777,216 | `0671b228dbb6f59eef0e6c5ddfbc4b67` | `064491b0ea9a2d800861f9d04fa54afbb147660ad551958005adb53646d49f7d` |

---

## 三、刷写与启用流程

### 第一步：刷入固件
- **Windows 推荐方式（仅刷 8 MB BIOS 区）**：将 `X99-2D3` 目录置于纯英文短路径下，右键 **`FLASH_WINDOWS_2D3_BIOS_ONLY.bat`** → **以管理员身份运行**（自动备份 `BACKUP_BIOS_PRE_2D3.BIN` 后刷入 `2D3ZH_8M.bin`，FPT 提示时按 `Y`）。
- **Windows 整片刷写（16 MB）**：如需完整写入 16 MB 镜像，可运行 **`FLASH_WINDOWS_2D3_FULL.bat`** 刷入 `2D3ZH.ROM`。
- **DOS 方式**：复制到 FreeDOS U 盘根目录启动，运行 `X_2D3.bat` 并按 `Y`。

### 第二步：清 CMOS 并按需调整降压/倍频
1. 刷完关机拔电清 CMOS，或进 BIOS 加载 **优化默认值（Load Optimized Defaults）** 并保存重启；
2. 此时 `超频功能总开关`、`大于 4G 地址解码`、`Resizable BAR 支持`、`CSM 关闭`、`封装 C2 限制 / C3 关闭 / C6 关闭` 均已默认生效，默认负压 `0 mV` 零风险；
3. 按需进入 **`Intel 平台设置 → 超频设置`** 调整降压与倍频：

| BIOS 菜单路径（`Intel 平台设置 → 超频设置`） | 推荐值 | 说明 |
|---|---|---|
| `超频设置 → 超频功能总开关` | `启用`（已默认） | 动态鸡血与调压总开关 |
| `处理器核心 (Core) → 核心最大超频倍频` | `0`（自动满血）或 `36` | `0` 自动解锁全核最高睿频；长时满载降温可按需手动限频 |
| `处理器核心 (Core) → 核心电压偏移 / 偏移符号` | `50` ~ `65` / `[-]` | 建议从 `-50 mV` 起步做烤机稳定性测试（`5 mV` 步进） |
| `环形总线 (CLR/Ring) → 环形总线最大倍频` | `28` 或 `29`（默认 `0`=自动上限） | 高负载下退 1~2 档可显著提升缓存与 IMC 稳定性 |
| `环形总线 (CLR/Ring) → 环形总线电压偏移 / 偏移符号` | `35` ~ `45` / `[-]` | 建议避免缓存降压过深报 WHEA（`5 mV` 步进） |
| `CPU C 状态控制 → 封装 C 状态限制 / CPU C3 / C6 报告` | `C2 状态` / `禁用` / `禁用`（已默认） | 防止大幅负压下轻重负载切换瞬间掉压冻屏 |

### 第三步：开启 Windows 11 微码安全旁路
- 进入 Windows，双击运行 **`WIN11_MCUPDATE_TOGGLE.bat`** 按 `Y` 启用微软签名微码旁路（再次运行可查看状态或按 `R` 无损还原；**切勿手动直接删除 `System32\mcupdate_GenuineIntel.dll`**）；
- 本版采用官方原生 `PciBus` Resizable BAR，**无需运行 `ReBarState.exe`**，重启系统后即可在 HWiNFO / CPU-Z / GPU-Z 确认全核鸡血、IA/CLR 独立负压与 Resizable BAR 全部生效。

---

## 四、版本回退说明

如需回退至官方原厂底包，将 `bak\X92D3006.bin` 复制至目录并执行 `fptw64.exe -f X92D3006.bin`（或使用刷写前自动生成的 `BACKUP_BIOS_PRE_2D3.BIN` 执行 `fptw64.exe -f BACKUP_BIOS_PRE_2D3.BIN -bios`）；如需还原 Windows 原版 Intel 微码，运行 `WIN11_MCUPDATE_TOGGLE.bat` 按 `R` 即可一键恢复。
