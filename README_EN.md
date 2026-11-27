# HUANANZHI X99-TF Bilingual Modded BIOS Flash Kits (`V3.0` & `V6.0`)

> 中文说明: [README.md](README.md)

This repository provides standalone modded BIOS flash kits for **X99-TF / X99-T8 / X99-XD3 / HSGM 火神革命 X99 (PF7)** motherboards, organized into separate directories:

| Directory | Stock Base | Target / Architecture | Resizable BAR | Highlights |
|---|---|---|---|---|
| **[`V3.0/`](V3.0/README_EN.md)** | `TFV30JX.bin` (X99-TF V3.0 JX, 2022-09-16) | Native X99-TF V3.0 full kit | `ReBarDxe` + `ReBarState.exe` | Real-hardware verified, `A134C001` dynamic Haswell-EP turbo + IA/CLR undervolt, bilingual UI + 16px bitmap font |
| **[`V6.0/`](V6.0/README.md)** | `TFV60.bin` (X99-TF V6.0 Stock, 2026-04-17) | Hybrid for X99-TF V3.0 (V3.0 IFD/ME + modded V6.0 BIOS region) | **Native AMI `PciBus` ReBAR (default Enabled)** | Relocated `A134C001`, `0x306F2` removed / `0x406F1` kept, full bilingual UI (0 missing glyphs), TPM 2.0, SmartFan IV, S5 RTC Wake, PCIe L1/ASPM disabled |
| **[`x99-t/`](x99-t/README.md)** | `T8V60.bin` (X99-T8 V6.0 Stock, 2026-04-17) | **Native X99-T8 GAMING V6.0** (stock V6.0 IFD/ME + stock `X99-T8` DMI) | **Native AMI `PciBus` ReBAR (default Enabled)** | Full TF-style mod set (`A134C001` dynamic turbo + IA/CLR undervolt, `0x306F2` removed / `0x406F1` kept, bilingual UI 0 missing glyphs, updated `fparts.txt`) |
| **[`X99-XD3/`](X99-XD3/README.md)** | `X9XD3003_ZH_16M.bin` (X99-XD3 V2.11 Localized) | **Native X99-XD3** (stock IFD/ME + stock `X99-XD3` DMI) | **Native AMI `PciBus` ReBAR (default Enabled)** | Relocated `A134C001` (`IntelSetup=0x17EC`) dynamic turbo + IA/CLR undervolt, `0x306F2` removed / `0x406F1` (`0x0B000038`) kept, 4-store synced defaults, 0 missing glyphs |
| **[`火神革命X99/`](火神革命X99/README.md)** | `火神革命X99_PF7_ZH_16M.rom` (HSGM X99 PF7 ZH, 2021-06-28) | **Native HSGM X99 (PF7)** (stock IFD/ME + `HSGM` DMI + existing Chinese UI/font) | `ReBarDxe` + `ReBarState.exe` | TF V3.0-style mod set (`A134C001` dynamic turbo + IA/CLR undervolt, `0x306F2` removed / `0x406F1` `0x0B000038` kept, hidden OC/Memory/XE menus unhidden, factory-clean NVRAM, 0 missing glyphs) |

> **Warning**: Always back up your SPI flash before flashing and verify your exact board model. On X99-TF V3.0 boards testing `V6.0/`, prefer `V6.0/FLASH_WINDOWS_V60_BIOS_ONLY.bat` (8 MB BIOS region only); on X99-T8 V6.0 / X99-XD3 / HSGM PF7 boards, prefer the corresponding `*_BIOS_ONLY.bat`.
