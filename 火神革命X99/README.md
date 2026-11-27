# 火神革命 X99 (PF7) 全动态鸡血 + IA/CLR 独立调压 + ReBAR 魔改刷写套件

基于已汉化版固件 `火神革命X99_PF7_ZH_16M.rom`（SMBIOS 标识 `HSGM`，AMI Aptio V `5.11`，`$FID = G3X99911`，构建日期 `06/28/2021`）按 [X99-TF V3.0 魔改版](../V3.0/README.md) 体系深度定制。  
本版集成**菜单联动的 Haswell-EP (`0x306F2`) 全核鸡血解锁引擎 (`A134C001`)**、**IA 与 CLR 独立负压调节**、**Resizable BAR (`ReBarDxe` + `ReBarState.exe`)**、**解锁隐藏超频/内存/XE 菜单**，并配套 **Windows 11 24H2/25H2 微软签名级安全微码旁路脚本**。

> **刷写有风险，请务必在刷写前备份原片并确认主板型号为火神革命 X99（PF7，16 MB SPI Flash）。刷写前请将本目录复制到纯英文短路径（例如 `C:\PF7\`），推荐优先运行 `FLASH_WINDOWS_PF7_BIOS_ONLY.bat` 仅刷 8 MB BIOS 区。**

---

## 一、核心架构与魔改特性

1. **原厂硬件区域零改动 + 完整保留原版中文界面与点阵字库**：
   - `PF7ZH.ROM` 前 8 MB（`0x00000000–0x007FFFFF`，Flash Descriptor / IFD + Intel ME）与底包 `火神革命X99_PF7_ZH_16M.rom` 逐字节一致；
   - 完整保留底包 `DAF4BF89` SMBIOS (`HSGM`)、开机 Logo 及 `AMITSE` 16px 点阵字库（`905` 字形），并在关键超频/调压/C-State/ReBAR 选项的右栏帮助中补充 `[本固件]` 生效范围说明（经校验全部字符 **0 缺字**）；
   - 清理原实时转储底包中残留的脏 NVRAM（如他机 `MemoryConfig0..A` 内存训练数据与 `Boot0000..0004` 启动项），将 `FV[0]` 重置为纯净出厂 `StdDefaults`、`FV[1]` 置空，避免换机刷入后内存训练冲突。
2. **精准微码清理（兼容 E5 v3 鸡血与 E5 v4 直插）**：
   - 从 `FV_BB` 微码容器（`17088572`）与 FIT 表（`0xFFD90000`）中仅彻底移除 `0x306F2`（Haswell-EP 正式版 `rev 0x3D`），确保 Haswell-EP 上电保持 `MSR 0x8B = 0`；
   - 完整保留 `0x306F1`（`rev 0x80000013`）、`0x406F0`（`rev 0x14`）、**`0x406F1`（`rev 0x0B000038`，Broadwell-EP E5 v4 正式版）** 及 `MPDT` 尾表，支持直接插拔 E5 v4 处理器。
3. **`A134C001` 全动态菜单联动鸡血与 IA/CLR 独立负压引擎**：
   - 经逐项解析核验，PF7 的 `IntelSetup` 结构体（`GUID = EC87D643-EBA4-4BB5-A1E5-3F3E36B20DA9`，`DataSize = 0x17CB`）及全部 9 个关键字段偏移与 X99-TF V3.0 完全一致（`OverClocking Feature = 0x161E`、`Core Max OC Ratio = 0x1640`、`Core Voltage Offset = 0x1644/0x1646`、`CLR Max OC Ratio = 0x167B`、`CLR Voltage Offset = 0x167F/0x1681`、`CLR Min Ratio = 0x17A7`）；
   - **总闸门**：绑定 `超频功能总开关`（默认 `启用`），设为 `禁用` 即可一键跳过全部电压与鸡血修改；
   - **IA / CLR 独立负压**：动态读取核心/环形总线偏移设置，独立写入 `MSR 0x150` Plane 0 / Plane 2（支持 `-20 ~ -110 mV`，`5 mV` 步进，默认 `0 mV` 零风险）；
   - **SDM 标准硬件自检**：严格按 `wrmsr(0x8B, 0) → cpuid(1) → rdmsr(0x8B)` 检测，仅当 `CPUID == 0x306F2` 且 `MSR 0x8B == 0` 时执行全核睿频解锁；更换 E5 v4 等带微码 CPU 时自动跳过倍频解锁；
   - **全核倍频与 Ring/Uncore 动态联动**：`核心最大超频倍频` 默认 `0` 自动解锁至硬件最高单核睿频，手动填入 `12–45` 可精确限频并广播至 `MSR 0x1AD / 0x1AE / 0x1AF`；`环形总线最大/最小倍频` 动态写入 `MSR 0x620`；
   - **智能功耗墙放宽 (`MSR 0x610`)**：未锁定时自动将低于甜点线的默认 TDP 平滑放宽至 `PL1 = 220W / PL2 = 250W`，同时保留用户在 `SOCKET RAPL Config` 中设定的更高值或主动锁定限制；最后置位 `MSR 0x194` bit 20 (`OC_LOCK`)。
4. **解锁隐藏超频与内存菜单（`Platform` IFR）**：
   - 解除 Xeon E5 非 K 处理器下对 **`超频设置`（`OverClocking Feature`，Form `0x03F0`）** 的 `SUPPRESS_IF` 隐藏限制，使至强 CPU 可直接进入核心/环形总线倍频与调压菜单；
   - 同步解除 **`页面策略 / 内存训练`（`Page Policy / Memory Training`）** 与 **`XE 倍频限制`（`XE Ratio Limit`）** 的隐藏限制。
5. **Resizable BAR 支持（`ReBarDxe` + `ReBarState.exe`）**：
   - PF7 原版 `PciBus` 不含原生 ReBAR 引擎，本版注入与 X99-TF V3.0 同源的 **`ReBarDxe`**（`A8EE1777-A4F5-4345-9DA4-13742084D31E`），默认开启 `大于 4G 地址解码`（`Above 4G Decoding`）、关闭 `CSM 兼容支持`，进 Windows 运行随附的 `ReBarState.exe` 输入 `32` 即可启用 ReBAR。
6. **四处开箱即用默认值全同步**（`FV[0]` 出厂 NVRAM、`9221315B`、`FE612B72 ($SPF)` 及 `Setup`/`Platform` IFR）：
   - `超频功能总开关 (OverClocking Feature) = 启用`（`IntelSetup+0x161E = 1`，默认负压 `0 mV` 零风险）
   - `超频锁定 (Overclocking Lock) = 禁用`（`IntelSetup+0x13DC = 1`）
   - `CPU C 状态 (CPU C State) = 启用`（`IntelSetup+0x0069 = 1`）
   - `封装 C 状态限制 (Package C State limit) = C2 状态`（`IntelSetup+0x006C = 1`）
   - `CPU C3 报告 / CPU C6 报告 = 禁用`（`IntelSetup+0x006D = 0`、`0x006E = 0`）
   - `大于 4G 地址解码 (Above 4G Decoding) = 启用`（`Setup+0x001E = 1`）
   - `CSM 兼容支持 (CSM Support) = 禁用`（`Setup+0x004A = 0`）
   - `ACPI 睡眠状态 (ACPI Sleep State / S3) = 禁用挂起`（`Setup+0x000A = 0`，防止 S3 唤醒丢失 MSR 状态）
7. **Windows 11 24H2 / 25H2 微软签名级微码安全旁路 (`WIN11_MCUPDATE_TOGGLE.bat`)**：
   - 原位使用微软原生 WHQL 签名的 `mcupdate_AuthenticAMD.dll` 占位替代 `mcupdate_GenuineIntel.dll`（双备份并恢复 `TrustedInstaller` 权限），避免直接删/改名微码 DLL 导致的开机修复循环。

---

## 二、目录结构与校验值

```text
火神革命X99/
├─ PF7ZH_8M.bin                    # 8MB BIOS 区镜像（推荐首选，不动原厂 IFD/ME）
├─ PF7ZH.ROM                       # 16MB 完整镜像（原厂 IFD/ME + 魔改 BIOS 区）
├─ FLASH_WINDOWS_PF7_BIOS_ONLY.bat # Windows 首选：自动提权 + 备份 + 仅刷 8MB BIOS 区
├─ FLASH_WINDOWS_PF7_FULL.bat      # Windows 备用：自动提权 + 备份 + 16MB 整片刷写
├─ X_PF7.bat / X_PF7_NOBACKUP.bat  # DOS：16MB 整片刷写脚本
├─ ReBarState.exe                  # ReBAR 启用工具（Windows 管理员运行，输入 32）
├─ WIN11_MCUPDATE_TOGGLE.bat       # Windows 11 24H2/25H2 微软签名微码旁路脚本
├─ fpt.exe / fptw64.exe / fparts.txt / idrvdll32e.DLL / pmxdll32e.DLL
├─ README.md                       # 本说明文档
└─ bak/
   └─ 火神革命X99_PF7_ZH_16M.rom   # 原始已汉化版 PF7 底包备份
```

| 文件 | 大小 (Bytes) | MD5 | SHA-256 |
|---|---:|---|---|
| **`PF7ZH_8M.bin`** | 8,388,608 | `6699b29b1efacfe30e42939e923d4aff` | `cca2506712242313cb1a0531ad1257b5fd710f7b0473c180ef7ed78fae962d4a` |
| **`PF7ZH.ROM`** | 16,777,216 | `b23afa43490f7d6c5fb6b9bfb6e394c3` | `06949e1d3174480c4cc658a9f2efe70e8ab76437e460cd9c367a6ee5d58f4c45` |
| `bak/火神革命X99_PF7_ZH_16M.rom` | 16,777,216 | `fbf57795d7b1e7a485ce62be4cd17007` | `632fbe04aaaee3c679e19e4b0da9de357d9815eabd9b415d9743d0c9853cf888` |

---

## 三、三步完整启用流程

### 第一步：刷入固件
- **Windows 推荐方式（仅刷 8 MB BIOS 区）**：将本目录复制到纯英文短路径（如 `C:\PF7\`），右键 **`FLASH_WINDOWS_PF7_BIOS_ONLY.bat`** → **以管理员身份运行**（自动备份 `BACKUP_BIOS_PRE_PF7.BIN` 后刷入 `PF7ZH_8M.bin`，FPT 提示时按 `Y`）。
- **Windows 整片刷写（16 MB）**：如需整片写入（含原版 IFD/ME），可运行 **`FLASH_WINDOWS_PF7_FULL.bat`** 刷入 `PF7ZH.ROM`。
- **DOS 方式**：复制到 FreeDOS U 盘根目录启动，运行 `X_PF7.bat` 并按 `Y`。

### 第二步：清 CMOS 并按需设置降压与倍频
1. 刷完关机拔电清 CMOS，或进 BIOS 执行 **恢复默认设置（Load Optimized Defaults）** 并保存重启；
2. 此时 `超频功能总开关`、`大于 4G 地址解码`、`CSM 关闭`、`C2 限制 / C6 关闭`、`S3 挂起关闭` 均已默认生效，默认负压 `0 mV` 零风险；
3. 按需进入 **`Intel 平台设置 → 超频设置`** 调整降压与倍频：

| BIOS 菜单路径（`Intel 平台设置 → 超频设置`） | 推荐值 | 说明 |
|---|---|---|
| `超频设置 → 超频功能总开关` | `启用`（已默认） | 动态鸡血与调压总开关 |
| `处理器核心 → 核心最大超频倍频` | `0`（自动满血）或按需限频 | `0` 自动解锁全核最高睿频；长时满载降温可手动填入 `12–45` |
| `处理器核心 → 核心电压偏移 / 偏移符号` | `50` ~ `65` / `[-]` | 建议从 `-50 mV` 起步做烤机稳定性测试，支持 `-20 ~ -110 mV`（`5 mV` 步进） |
| `环形总线 → 环形总线最大倍频` | `0`（自动 `30x`）或 `28 / 29` | 大容量四通道内存高负载下退 1~2 档可提升缓存与 IMC 稳定性 |
| `环形总线 → 环形总线电压偏移 / 偏移符号` | `35` ~ `45` / `[-]` | 建议避免缓存降压过深报 WHEA，支持 `-20 ~ -110 mV`（`5 mV` 步进） |
| `CPU C 状态控制 → 封装 C 状态限制 / CPU C6 报告` | `C2 状态` / `禁用`（已默认） | 大幅负压下防止待机或轻重负载切换瞬间异常/重启 |

### 第三步：开启 Windows 11 微码安全旁路与 ReBAR
1. 进入 Windows，双击运行 **`WIN11_MCUPDATE_TOGGLE.bat`** 按 `Y` 启用微软签名微码旁路（再次运行可查看状态或按 `R` 无损还原；**切勿手动直接删除 `System32\mcupdate_GenuineIntel.dll`**）；
2. 右键以管理员身份运行 **`ReBarState.exe`**，输入 **`32`** 回车写入 ReBAR 状态变量；
3. **重启电脑**，打开 HWiNFO / CPU-Z / GPU-Z 即可确认全核鸡血倍频、IA/CLR 独立负压与 Resizable BAR 全部生效。

---

## 四、版本回退说明

如需回退至原汉化版，将 `bak\火神革命X99_PF7_ZH_16M.rom` 复制至纯英文目录并重命名为 `PF7_ORIG.rom` 后执行 `fptw64.exe -f PF7_ORIG.rom`（或直接使用刷写前自动备份的 `BACKUP_BIOS_PRE_PF7.BIN` 执行 `fptw64.exe -f BACKUP_BIOS_PRE_PF7.BIN -bios`）；如需还原 Windows 原版 Intel 微码，运行 `WIN11_MCUPDATE_TOGGLE.bat` 按 `R` 即可一键无损恢复。
