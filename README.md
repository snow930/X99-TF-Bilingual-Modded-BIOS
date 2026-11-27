#  X99 双语全动态鸡血 + IA/CLR 独立调压 + ReBAR 魔改 BIOS 套件

> English version: [README_EN.md](README_EN.md)

本仓库提供基于不同官方/汉化基底深度定制的 **X99-TF / X99-T8 / X99-XD3 / 火神革命 X99** 双语/中文魔改 BIOS 刷写套件，分别位于独立目录：

| 目录 | 基底版本 | 适用场景 | ReBAR 方案 | E5 v4 微码 | 实机测试 | 状态 |
|---|---|---|---|---|---|---|
| **[`V3.0/`](V3.0/README.md)** | `TFV30JX.bin`（X99-TF V3.0 JX，2022-09-16） | X99-TF V3.0 旧主板（原厂同代基底） | `ReBarDxe` + `ReBarState.exe` | 保留 (`0x0B000038`) | ✅ 已实机测试（X99-TF V3.0；B站评论区反馈华南 X99-8M 刷入正常） | ✅ 长期稳定验证 |
| **[`V6.0/`](V6.0/README.md)** | `TFV60.bin`（X99-TF V6.0 默认，2026-04-17） | X99-TF V3.0 旧主板跨代移植（保留 V3.0 IFD/ME） | **官方原生 `PciBus` ReBAR（免工具）** | 保留 (`0x0B00002E`) | ⚠️ 未实机测试 | 🆕 新增 TPM2 / SmartFan IV / S5 定时开机 / PCIe L1 关闭 |
| **[`x99-t/`](x99-t/README.md)** | `T8V60.bin`（X99-T8 V6.0 默认，2026-04-17） | **X99-T8 GAMING V6.0** 主板（原厂 V6.0 IFD/ME + 原厂 `X99-T8` DMI） | **官方原生 `PciBus` ReBAR（免工具）** | 保留 (`0x0B00002E`) | ⚠️ 未实机测试 | 🆕 X99-T8 V6.0 专属魔改套件（含新版 `fparts.txt`） |
| **[`X99-XD3/`](X99-XD3/README.md)** | `X9XD3003_ZH_16M.bin`（X99-XD3 V2.11 汉化版） | **X99-XD3** 主板（原厂 IFD/ME + 原厂 `X99-XD3` DMI） | **官方原生 `PciBus` ReBAR（免工具）** | 保留 (`0x0B000038`) | ⚠️ 未实机测试 | 🆕 全动态 `A134C001` (`IntelSetup=0x17EC`) + IA/CLR 调压 + 原生 ReBAR |
| **[`火神革命X99/`](火神革命X99/README.md)** | `火神革命X99_PF7_ZH_16M.rom`（火神革命 PF7 汉化版，2021-06-28） | **火神革命 X99 (PF7)** 主板（保留原厂 IFD/ME + `HSGM` DMI + 原汉化字库） | `ReBarDxe` + `ReBarState.exe` | 保留 (`0x0B000038`) | ⚠️ 未实机测试 | 🆕 按 TF V3.0 体系集成 `A134C001` 全动态鸡血 + IA/CLR 独立调压 + ReBAR |

---

## 快速导航

- **X99-TF 稳定首选（V3.0 原代基底）**：进入 [**`V3.0/`**](V3.0/README.md) 查看完整特性、实机效果图与刷写教程。
- **X99-TF 体验新版（V6.0 移植版，原生 ReBAR）**：进入 [**`V6.0/`**](V6.0/README.md) 查看 V6.0 差异、校验值与仅刷 8 MB BIOS 区的安全升级/回退方案。
- **X99-T8 GAMING V6.0 魔改套件**：进入 [**`x99-t/`**](x99-t/README.md) 查看基于官方 `T8V60.bin`（2026-04-17）定制的完整说明、校验值与刷写教程。
- **X99-XD3 魔改套件**：进入 [**`X99-XD3/`**](X99-XD3/README.md) 查看基于汉化底包 `X9XD3003_ZH_16M.bin` 定制的全动态鸡血 + IA/CLR 独立调压 + 原生 ReBAR 刷写教程与校验值。
- **火神革命 X99 (PF7) 魔改套件**：进入 [**`火神革命X99/`**](火神革命X99/README.md) 查看基于汉化底包 `火神革命X99_PF7_ZH_16M.rom` 定制的全动态鸡血 + IA/CLR 独立调压 + ReBAR 完整说明、校验值与刷写教程。

> **风险提示**：刷写 BIOS 存在风险，请务必在刷写前备份原片并核对主板具体型号（16 MB SPI Flash）。在 V3.0 主板上体验 `V6.0/` 时，请优先使用 `V6.0/FLASH_WINDOWS_V60_BIOS_ONLY.bat` 仅刷 8 MB BIOS 区；在 X99-T8 V6.0 / X99-XD3 / 火神革命 X99 主板上推荐优先使用对应的 `*_BIOS_ONLY.bat`。
