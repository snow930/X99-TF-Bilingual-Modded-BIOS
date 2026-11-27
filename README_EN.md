# HUANANZHI X99-TF Bilingual Modded BIOS Flash Kits (`V3.0` & `V6.0`)

> 中文说明: [README.md](README.md)

This repository provides two standalone modded BIOS flash kits for the **HUANANZHI X99-TF** motherboard, organized into separate directories:

| Directory | Stock Base | Target / Architecture | Resizable BAR | Highlights |
|---|---|---|---|---|
| **[`V3.0/`](V3.0/README_EN.md)** | `TFV30JX.bin` (V3.0 JX, 2022-09-16) | Native X99-TF V3.0 full kit | `ReBarDxe` + `ReBarState.exe` | Real-hardware verified, `A134C001` dynamic Haswell-EP turbo + IA/CLR undervolt, bilingual UI + 16px bitmap font |
| **[`V6.0/`](V6.0/README.md)** | `TFV60.bin` (V6.0 Stock, 2026-04-17) | Hybrid for X99-TF V3.0 (V3.0 IFD/ME + modded V6.0 BIOS region) | **Native AMI `PciBus` ReBAR (default Enabled)** | Relocated `A134C001`, `0x306F2` removed / `0x406F1` kept, full bilingual UI (0 missing glyphs), TPM 2.0, SmartFan IV, S5 RTC Wake, PCIe L1/ASPM disabled |

> **Warning**: Always back up your SPI flash before flashing. On X99-TF V3.0 boards testing `V6.0/`, prefer `V6.0/FLASH_WINDOWS_V60_BIOS_ONLY.bat` (8 MB BIOS region only) so V3.0 IFD/ME remains untouched and rollback to `V3.0/` is instant.
