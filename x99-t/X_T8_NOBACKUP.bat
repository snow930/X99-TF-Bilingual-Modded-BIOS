@echo off
cls
echo ============================================================
echo  HUANANZHI X99-T8 V6.0  -  BIOS FLASH (no backup step)
echo  Image: T8ZH_V60.ROM
echo ============================================================
echo.
echo WARNING: This script does NOT make a backup.
echo Only use it if you already have a full 16MB backup.
echo.
echo Do NOT power off during the write.
echo.
pause
echo Writing T8ZH_V60.ROM...
echo When FPT asks to continue, press Y.
fpt -f T8ZH_V60.ROM
pause
