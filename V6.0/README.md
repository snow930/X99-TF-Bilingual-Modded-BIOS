# 华南金牌 X99-TF V3.0 主板移植 `TFV60`（2026-04-17）双语全动态鸡血 + 原生 ReBAR 刷写套件

基于华南金牌最新官方 BIOS `TFV60.bin`（X99-TF GAMING V6.0，2026-04-17，`$FID = HN368001`）深度移植与定制，专面向 **X99-TF V3.0 旧主板** 采用 **“V3.0 原厂前 8 MB (IFD + ME) + 魔改 V6.0 后 8 MB (BIOS 区)”** 混合安全架构构建。

> **刷写有风险：V3.0 主板强烈建议优先运行 `FLASH_WINDOWS_V60_BIOS_ONLY.bat` 仅刷 8 MB BIOS 区（完全不动原板 IFD/ME）。**

---

## 一、相比 [V3.0 魔改版](../V3.0/README.md) 的核心升级

1. **官方原生 Resizable BAR（告别 `ReBarDxe` + `ReBarState.exe`）**：
   - 启用 V6.0 `PciBus` 内置的 PCIe Extended Capability `0x15` 原生 ReBAR 引擎，并将 `PCI 子系统设置 → Re-Size BAR 显存智取` 与 `Above 4G Decoding` 默认设为 **`启用`**、`CSM Support` 默认设为 **`禁用`**，清 CMOS 后无需再运行 `ReBarState.exe`。
2. **保留 Broadwell-EP (E5 v4) 生产微码**：
   - 从 `FV_BB` 与 FIT 表中仅彻底清除 `0x306F2`（Haswell-EP 正式版微码），完整保留 `0x306F1`、`0x406F0` 与 **`0x406F1` rev `0x0B00002E`（E5 v4 正式版）**，兼顾 E5 v3 全核鸡血与 E5 v4 直接兼容。
3. **`A134C001` 全动态鸡血与 IA/CLR 独立调压引擎重定位**：
   - 因 V6.0 移除 Intel AMT 导致 `IntelSetup` 结构体由 `6091 B` 缩减为 `6052 B`，已完整重定位 `A134C001` 全部 9 处尺寸与字段偏移（`DataSize = 0x17A4`、`OverClocking Feature = 0x15F8`、`Core Max OC Ratio = 0x161A`、`Core Voltage Offset = 0x161E/0x1620`、`CLR Max OC Ratio = 0x1655`、`CLR Voltage Offset = 0x1659/0x165B`、`CLR Min Ratio = 0x1780`）。
4. **继承 V6.0 原厂新增特性与稳定性改进**：
   - 保留 `PCH DMI ASPM = Disabled`、`PCIe Root Port 1~8 L1 Substates = Disabled`、`MemTest = Disable`、`Command Timing = Auto`；
   - 完整保留 **TPM 1.2 / TPM 2.0 / TCM 协议栈**、**SmartFan IV 智能温控**、**S5 RTC 定时开机**、**HDD Security 硬盘安全**、**NVMe 信息页**与全部原厂 UEFI 网卡 UNDI 驱动；保持 V6.0 原生无全屏开机 `Logo.bmp`。
5. **全量双语界面 + 同源 16px 点阵 0 缺字字库**：
   - 精准复用 V3.0 精校双语词典并补齐全部 186 条 V6.0 新增菜单/帮助词条（含新版 `F3 / F4 / <K> / <M>` 快捷键提示）；
   - `AMITSE` 嵌入 `103` 窄 + `807` 宽 16px 1bpp 宋体点阵字库，全固件 **0 缺字**。
6. **四处默认值全同步**：
   - `FV_NVRAM (StdDefaults)`、`9221315B`、`FE612B72 ($SPF)` 及 `Setup`/`Platform` IFR 同步写入：`OverClocking Feature = Enabled`、`Overclocking Lock = Disable`、`CPU C State = Enable`、`Package C State limit = C2`、`CPU C3/C6 report = Disable`、`Above 4G = Enabled`、`Re-Size BAR = Enabled`、`CSM = Disabled`、`ACPI S3 = Disabled`。

---

## 二、目录结构与校验值

```text
V6.0/
├─ TFZH_V60_8M.bin                 # 8MB BIOS 区镜像（V3.0 主板首选刷写）
├─ TFZH_V60.ROM                    # 16MB 完整混合镜像（V3.0 原厂 IFD/ME + 魔改 V6.0 BIOS 区）
├─ FLASH_WINDOWS_V60_BIOS_ONLY.bat # Windows 首选：自动提权 + 备份 + 仅刷 8MB BIOS 区
├─ FLASH_WINDOWS_V60_FULL.bat      # Windows 备用：自动提权 + 备份 + 16MB 整片刷写
├─ WIN11_MCUPDATE_TOGGLE.bat       # Windows 11 24H2/25H2 微软签名微码旁路脚本
├─ fpt.exe / fptw64.exe / ...      # 官方 FPT 刷写工具链
├─ README.md                       # 本说明文档
└─ bak/
   └─ TFV60.bin                    # 官方原厂 X99-TF V6.0 (2026-04-17) 默认 BIOS 备份
```

| 文件 | 大小 (Bytes) | MD5 | SHA-256 |
|---|---:|---|---|
| **`TFZH_V60_8M.bin`** | 8,388,608 | `85211695ba7147d975d5b34d39a3bf70` | `1d12ed1878532ca1e596eaf5696e9c55b0f165fe4f86580148bac4bf5225a1fb` |
| **`TFZH_V60.ROM`** | 16,777,216 | `5a02d204320af8d9a6ee90f13cfb2da9` | `6dfbb168e7dceeba7b8eb974773ba695195579a49deb39562a349642a90b4ea8` |
| `bak/TFV60.bin` | 16,777,216 | `e2548f8e26887df3bce619cd26a44cf2` | `ed70ab6b5318c7c030ef6600974a3f5768cff0d344ee4f3b102f14126d36a6c2` |

---

## 三、刷写与回退流程

1. **刷入（推荐仅刷 8 MB BIOS 区）**：
   - 将 `V6.0` 目录置于非中文短路径下，右键 **`FLASH_WINDOWS_V60_BIOS_ONLY.bat`** → **以管理员身份运行**（先备份 `BACKUP_BIOS_PRE_V60.BIN`，FPT 提示时按 `Y`）。
2. **清 CMOS 与检查**：
   - 刷完关机拔电清 CMOS，或进 BIOS 按 **`F3`** 加载优化默认值并按 **`F4`** 保存重启（注意 V6.0 快捷键已从 `F9/F10` 变更为 `F3/F4`）。
   - 进入 `Intel 平台设置 → 超频设置` 按需设定核心/环形总线负压与倍频（默认负压 `0 mV` 零风险）。
3. **Windows 11 微码旁路**：
   - 如尚未启用微码旁路，运行 **`WIN11_MCUPDATE_TOGGLE.bat`** 按 `Y` 启用；本版原生 ReBAR 开箱生效，**无需运行 `ReBarState.exe`**。
4. **无损回退到 V3.0 稳定版**：
   - 如需退回 V3.0 魔改版，运行 [`../V3.0/FLASH_WINDOWS_BIOS_ONLY.bat`](../V3.0/FLASH_WINDOWS_BIOS_ONLY.bat) 刷回 `TFZH_8M.bin` 即可；如需退回 V3.0 官方原片，参考 [`../V3.0/README.md`](../V3.0/README.md)。
