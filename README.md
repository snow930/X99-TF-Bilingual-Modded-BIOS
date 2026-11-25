# 华南金牌 X99-TF V3.0 JX 全动态鸡血 + 双语菜单 + IA/CLR 独立调压 + ReBAR 刷写套件

> English version: [README_EN.md](README_EN.md)

基于官方 `TFV30JX.bin`（X99-TF V3.0 JX，2022-09-16）深度定制。  
本版集成**菜单联动的 Haswell-EP (`0x306F2`) 全核鸡血解锁引擎**、**中英文双语界面**、**IA 与 CLR 独立负压调节**、**Resizable BAR**，并配套 **Windows 11 24H2/25H2 微软签名级安全微码旁路脚本**。

> **刷写有风险，请务必备份完整 16MB 原片并确认主板为 X99-TF V3.0 JX（16MB SPI Flash，如 W25Q128）。**

---

## 一、本版核心架构与特性

1. **只改 BIOS 区模块**：Flash Descriptor、ME、DMI/机型信息、开机 LOGO 与 FV3 卷均与官方原片逐字节一致（FV3 原生不含 `0x306F2` 微码，POST 阶段天然保持 `MSR 0x8B = 0`）。
2. **专业术语精修 UI + 官方原版全量 Help 汉译精校**：
   - **左栏精简专业中文**：基于官方 `TFV30JX.bin` 英文原版逐项汉化，按硬件架构准确区分 `环形总线 (CLR/Ring)` 与 `非核心/系统代理 (Uncore)`、将 `IntelRCSetup` 统一译为 `Intel 平台设置`，常用缩写（`PCIe / USB / SATA / DDR3 / CSM / PCH / NVMe / RAPL` 等）保持简洁规范，避免超宽折行与截断；
   - **右栏 Help 全量汉译与英文对照**：右栏帮助信息基于官方原版英文全量精译，首行自动置顶 `[Original English Name]` 便于随时查阅原厂英文术语；并在核心超频、IA/CLR 调压、功耗墙及 C-State 等关键项中补充 `[本固件]` 实际生效范围与操作说明；
   - **原生点阵字库完整覆盖**：内置同源 `SimSun 16px` 1bpp 点阵字库（共 `958` 个字形：`103` 窄 + `855` 宽），完整覆盖全部菜单、帮助信息与右下角快捷键提示，实机显示清晰锐利、全固件 **0 缺字**。
3. **`A134C001` 全动态菜单联动引擎**（替代原厂固定不可调的 `XFModE5-30Dxe`）：
   - **总闸门**：绑定 `超频功能总开关`（`OverClocking Feature`，`0x161E`，本版已设为默认 `启用`）；设为 `禁用` 时一键跳过全部电压与鸡血修改。
   - **IA / CLR 独立负压调节**：动态读取 `核心电压偏移`（`Core Voltage Offset`，`0x1644/0x1646`）与 `环形总线电压偏移`（`CLR Voltage Offset`，`0x167F/0x1681`），独立写入 `MSR 0x150` Plane 0 / Plane 2（仅处理负偏移 `20–110 mV`，`5 mV` 步进，默认 `0 mV` 不调压）。
   - **SDM 标准硬件自检**：严格按 `wrmsr(0x8B, 0) → cpuid(1) → rdmsr(0x8B)` 检测；仅当 `CPUID == 0x306F2` 且 `MSR 0x8B == 0` 时执行鸡血解锁（更换 E5 v4 等带微码 CPU 时自动跳过倍频解锁，仅保留动态调压）。
   - **全核倍频与菜单动态联动**：自动从硬件熔丝（`0x1AD` / OC Mailbox `0x80000001`）读取单核最高睿频（如 E5-2696 v3 自动识别为 `38x`）；当 `核心最大超频倍频`（`Core Max OC Ratio`，`0x1640`）保持默认 `0` 时自动满血 `38x`，若手动填入 `12–38`（如 `36`）则按菜单值精确限频并广播至 `MSR 0x1AD / 0x1AE / 0x1AF`。
   - **Ring / Uncore 倍频动态联动**：自动识别最大 Ring 倍频（E5-2696 v3 为 `30x`），联动 `环形总线最大倍频`（`CLR Max OC Ratio`，`0x167B`，默认 `0`=自动 `30x`）与 `环形总线最小倍频`（`CLR Min Ratio`，`0x17A7`，默认 `12x` 动态节能），写入 `MSR 0x620`。
   - **智能解锁功耗墙 (`MSR 0x610`)**：未锁定时自动将低于甜点线的默认 TDP（如 `145W`）平滑放宽至 `PL1 = 220W / PL2 = 250W`，同时保留用户在 `SOCKET RAPL Config` 中设定的更高值或主动锁定限制；最后置位 `MSR 0x194` bit 20 (`OC_LOCK`)。
4. **开箱即用默认值**（同步写入 FV0 NVAR、`9221315B`、`FE612B72` SPF 与 `IntelSetup` IFR）：
   - `OverClocking Feature = Enabled`（默认开启总开关，默认负压 `0 mV` 零风险）
   - `Overclocking Lock = Disable`（`0x13DC = 1`）
   - `CPU C State = Enable`（`0x0069 = 1`，允许激活最高 `38x` 睿频桶）
   - `Package C State limit = C2 state`（`0x006C = 1`，防止深睡掉压冻屏）
   - `CPU C6 report = Disable`（`0x006E = 0`；`CPU C3 report` 原生默认亦为 `Disable`）
   - `CSM Support = Disabled`（纯 UEFI 引导）
   - `Above 4G Decoding = Enabled`（支持大显存与 ReBAR）
   - `ACPI Sleep State (S3) = Disabled`（保持原厂默认关闭，防止 S3 唤醒丢失 MSR 状态）
5. **Windows 11 24H2 / 25H2 安全微码旁路 (`WIN11_MCUPDATE_TOGGLE.bat`)**：
   - 采用同目录微软原生 WHQL 内核签名的 `mcupdate_AuthenticAMD.dll` 原位覆盖 `mcupdate_GenuineIntel.dll`（双备份至 `System32` 与 `bak\`，并还原 `TrustedInstaller` 权限），100% 规避 Win11 24H2/25H2 直接删/改名微码 DLL 导致的开机蓝屏修复循环。

---

## 二、目录结构与校验值

```text
flash_kit/
├─ TFZH.ROM                      # 16MB 主镜像（全动态鸡血 + 双语 + IA/CLR 调压 + ReBAR）
├─ TFZH_8M.bin                   # 对应 8MB BIOS 区镜像（供 -bios 区单独刷写）
├─ WIN11_MCUPDATE_TOGGLE.bat     # Windows 11 24H2/25H2 安全微码旁路一键开关（双击自动提权）
├─ ReBarState.exe                # ReBAR 启用工具（Windows 管理员运行）
├─ FLASH_WINDOWS.bat             # Windows：自动提权 + 备份 BACKUP.BIN + 16MB 整片刷写
├─ FLASH_WINDOWS_BIOS_ONLY.bat   # Windows：仅备份并刷写 8MB BIOS 区
├─ X_ZH.bat / X_ZH_NOBACKUP.bat  # DOS：整片刷写脚本
├─ fpt.exe / fptw64.exe / ...    # 官方 DOS / Windows FPT 刷写工具链
├─ README.md / README_EN.md      # 中英文说明文档
└─ bak/
   ├─ TFV30JX.bin                                                            # 官方原厂 BIOS
   └─ TFV30JX_ZH-BILINGUAL-TURBO-VOLT-CLR-REBAR-CSMOFF-4GON-C2-C6OFF.rom     # 当前主镜像 TFZH.ROM 归档副本
```

| 文件 | 大小 (Bytes) | MD5 |
|---|---:|---|
| **`TFZH.ROM`** | 16,777,216 | `20a7af3eff4775b64788c8e448e4d8a0` |
| **`TFZH_8M.bin`** | 8,388,608 | `e1c424da50a72f3d9b70a75275e6b7d1` |
| `bak/TFV30JX.bin` | 16,777,216 | `e874c4531a47c5202b715ea670d763e2` |
| `bak/TFV30JX_ZH-BILINGUAL-TURBO-VOLT-CLR-REBAR-CSMOFF-4GON-C2-C6OFF.rom` | 16,777,216 | `20a7af3eff4775b64788c8e448e4d8a0` |

* `TFZH.ROM` SHA-256：`e5c1654c737ef23a1701dd3b28a9ebdde94ef5a665e15eae92c8614e5364aece`
* `TFZH_8M.bin` SHA-256：`ca0db222ec43ab0c34e174476182b19dd239d587993a5aefd14bedd0ea7901ca`

---

## 三、三步完整启用流程

### 第一步：刷入固件
* **Windows 推荐方式**：将 `flash_kit` 置于非中文短路径下，右键 `FLASH_WINDOWS.bat` → **以管理员身份运行**（自动备份当前全片至 `BACKUP.BIN` 后刷入 `TFZH.ROM`；若遇到 ME 锁则改用 `FLASH_WINDOWS_BIOS_ONLY.bat` 刷入 `TFZH_8M.bin`；FPT 提示时按 `Y`）。
* **DOS 方式**：复制到 FreeDOS U 盘根目录启动，运行 `X_ZH.bat` 并按 `Y`。

### 第二步：清 CMOS 并按需设置 BIOS 甜点参数
1. 刷完关机拔电源线，放电后抠下主板纽扣电池静置 15 秒（或短接 `CLR_CMOS` 跳线）再装回开机，或进 BIOS 执行 **Load Optimized Defaults** 保存；
2. 此时 `OverClocking Feature`、`Above 4G`、`CSM Off` 已默认生效；进入 `Intel 平台设置` 按需调整降压与倍频（见第四节参考表）。

### 第三步：开启 Windows 11 微码安全旁路与 ReBAR
1. 进入 Windows，双击运行 **`WIN11_MCUPDATE_TOGGLE.bat`**，按 `Y` 启用微软签名微码旁路（再次运行可随时查看状态或按 `R` 还原官方微码；**切勿手动直接删除 `System32\mcupdate_GenuineIntel.dll`**）；
2. 若刚清过 CMOS，右键管理员运行 **`ReBarState.exe`**，输入 **`32`** 回车重新写入 ReBAR 变量；
3. **重启电脑**，打开 HWiNFO / CPU-Z / 任务管理器即可确认全核鸡血倍频、IA/CLR 独立负压与 Resizable BAR 全部生效。

---

## 四、本机 E5-2696 v3 (18C/36T) + 128GB RAM BIOS 参考表

| BIOS 菜单路径（`Intel 平台设置 → 超频设置`） | 推荐值 | 说明 |
|---|---|---|
| `超频设置 → 超频功能总开关` | `启用`（已默认） | 动态鸡血与调压总开关 |
| `超频设置 → 处理器核心 (Core) → 核心最大超频倍频` | `0`（自动 `38x`）或 `36` | `0` 自动解锁 3.8 GHz 满血；长时 AVX 满载若需降温静音可填 `36` |
| `超频设置 → 处理器核心 (Core) → 核心电压偏移 / 偏移符号` | `50` ~ `65` / `[-]` | 建议从 `-50 mV` 起步做稳定性测试，逐步探至 `-60 ~ -70 mV` |
| `超频设置 → 环形总线 (CLR/Ring) → 环形总线最大倍频` | `28` 或 `29`（默认 `0`=30） | 128GB 四通道高负载下退 1~2 档可显著提升缓存与 IMC 稳定性 |
| `超频设置 → 环形总线 (CLR/Ring) → 环形总线电压偏移 / 偏移符号` | `35` ~ `45` / `[-]` | 配合大内存建议保持 `-35 ~ -45 mV`，避免缓存降压过深报 WHEA |
| `CPU C 状态控制 → CPU C 状态` | `启用`（已默认） | 保持开启以激活最高 `38x` 睿频桶 |
| `CPU C 状态控制 → 封装 C 状态限制 / CPU C6 报告` | `C2 状态` / `禁用`（已默认） | 大幅负压下防止待机或轻重负载切换瞬间掉压冻屏 |

---

## 五、版本回退说明

如需回退至官方原厂版，将 `bak/TFV30JX.bin` 复制覆盖根目录 `TFZH.ROM` 后重新运行 `FLASH_WINDOWS.bat` 即可；如需还原系统原版 Intel 微码，运行 `WIN11_MCUPDATE_TOGGLE.bat` 按 `R` 即可一键无损恢复。
