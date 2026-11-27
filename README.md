# 华南金牌 X99-TF 双语全动态鸡血 + IA/CLR 独立调压 + ReBAR 魔改 BIOS 套件

> English version: [README_EN.md](README_EN.md)

本仓库提供基于不同官方基底深度定制的华南金牌 **X99-TF / X99-T8** 双语魔改 BIOS 刷写套件，分别位于独立目录：

| 目录 | 官方基底版本 | 适用场景 | ReBAR 方案 | E5 v4 微码 | 状态 |
|---|---|---|---|---|---|
| **[`V3.0/`](V3.0/README.md)** | `TFV30JX.bin`（X99-TF V3.0 JX，2022-09-16） | X99-TF V3.0 旧主板（原厂同代基底） | `ReBarDxe` + `ReBarState.exe` | 保留 (`0x0B000038`) | ✅ 实机长期稳定验证 |
| **[`V6.0/`](V6.0/README.md)** | `TFV60.bin`（X99-TF V6.0 默认，2026-04-17） | X99-TF V3.0 旧主板跨代移植（保留 V3.0 IFD/ME） | **官方原生 `PciBus` ReBAR（免工具）** | 保留 (`0x0B00002E`) | 🆕 新增 TPM2 / SmartFan IV / S5 定时开机 / PCIe L1 关闭 |
| **[`x99-t/`](x99-t/README.md)** | `T8V60.bin`（X99-T8 V6.0 默认，2026-04-17） | **X99-T8 GAMING V6.0** 主板（原厂 V6.0 IFD/ME + 原厂 `X99-T8` DMI） | **官方原生 `PciBus` ReBAR（免工具）** | 保留 (`0x0B00002E`) | 🆕 X99-T8 V6.0 专属魔改套件（含新版 `fparts.txt`） |

---

## 快速导航

- **X99-TF 稳定首选（V3.0 原代基底）**：进入 [**`V3.0/`**](V3.0/README.md) 查看完整特性、实机效果图与刷写教程。
- **X99-TF 体验新版（V6.0 移植版，原生 ReBAR）**：进入 [**`V6.0/`**](V6.0/README.md) 查看 V6.0 差异、校验值与仅刷 8 MB BIOS 区的安全升级/回退方案。
- **X99-T8 GAMING V6.0 魔改套件**：进入 [**`x99-t/`**](x99-t/README.md) 查看基于官方 `T8V60.bin`（2026-04-17）定制的完整说明、校验值与刷写教程。

> **风险提示**：刷写 BIOS 存在风险，请务必在刷写前备份原片并核对主板具体型号（16 MB SPI Flash）。在 V3.0 主板上体验 `V6.0/` 时，请优先使用 `V6.0/FLASH_WINDOWS_V60_BIOS_ONLY.bat` 仅刷 8 MB BIOS 区；在 X99-T8 V6.0 主板上推荐优先使用 `x99-t/FLASH_WINDOWS_T8_BIOS_ONLY.bat`。
