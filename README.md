# 华南金牌 X99-TF 双语全动态鸡血 + IA/CLR 独立调压 + ReBAR 魔改 BIOS 套件

> English version: [README_EN.md](README_EN.md)

本仓库提供两套基于不同官方基底深度定制的华南金牌 **X99-TF** BIOS 刷写套件，分别位于独立目录：

| 目录 | 官方基底版本 | 适用场景 | ReBAR 方案 | E5 v4 微码 | 状态 |
|---|---|---|---|---|---|
| **[`V3.0/`](V3.0/README.md)** | `TFV30JX.bin`（V3.0 JX，2022-09-16） | X99-TF V3.0 旧主板（原厂同代基底） | `ReBarDxe` + `ReBarState.exe` | 保留 (`0x0B000038`) | ✅ 实机长期稳定验证 |
| **[`V6.0/`](V6.0/README.md)** | `TFV60.bin`（V6.0 默认，2026-04-17） | X99-TF V3.0 旧主板跨代移植（保留 V3.0 IFD/ME） | **官方原生 `PciBus` ReBAR（免工具）** | 保留 (`0x0B00002E`) | 🆕 新增 TPM2 / SmartFan IV / S5 定时开机 / PCIe L1 关闭 |

---

## 快速导航

- **稳定首选（V3.0 原代基底）**：进入 [**`V3.0/`**](V3.0/README.md) 查看完整特性、实机效果图与刷写教程。
- **体验新版（V6.0 移植版，原生 ReBAR）**：进入 [**`V6.0/`**](V6.0/README.md) 查看 V6.0 差异、校验值与仅刷 8 MB BIOS 区的安全升级/回退方案。

> **风险提示**：刷写 BIOS 存在风险，请务必在刷写前备份原片并确认主板型号为华南金牌 X99-TF（16 MB SPI Flash）。在 V3.0 主板上体验 `V6.0/` 时，请优先使用 `V6.0/FLASH_WINDOWS_V60_BIOS_ONLY.bat` 仅刷 8 MB BIOS 区，随时可无损退回 `V3.0/`。
