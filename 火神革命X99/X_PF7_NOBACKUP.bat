@echo off
cls
echo ============================================================
echo  HSGM X99 (PF7)  -  BIOS FLASH (no backup step)
echo  Image: PF7ZH.ROM
echo ============================================================
echo.
echo WARNING: This script does NOT make a backup.
echo Only use it if you already have a full 16MB backup.
echo.
echo Do NOT power off during the write.
echo.
pause
echo Writing PF7ZH.ROM...
echo When FPT asks to continue, press Y.
fpt -f PF7ZH.ROM
pause
