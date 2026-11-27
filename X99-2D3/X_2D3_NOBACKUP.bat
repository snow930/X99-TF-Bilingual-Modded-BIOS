@echo off
cls
echo ============================================================
echo  X99-2D3 V1.02 (X92D3006)  -  BIOS FLASH (no backup step)
echo  Image: 2D3ZH.ROM
echo ============================================================
echo.
echo WARNING: This script does NOT make a backup.
echo Only use it if you already have a full 16MB backup.
echo.
echo Do NOT power off during the write.
echo.
pause
echo Writing 2D3ZH.ROM...
echo When FPT asks to continue, press Y.
fpt -f 2D3ZH.ROM
pause
