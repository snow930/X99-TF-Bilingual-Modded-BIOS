@echo off
cls
echo ============================================================
echo  X99-XD3 (X9XD3003)  -  BIOS FLASH (no backup step)
echo  Image: XD3ZH.ROM
echo ============================================================
echo.
echo WARNING: This script does NOT make a backup.
echo Only use it if you already have a full 16MB backup.
echo.
echo Do NOT power off during the write.
echo.
pause
echo Writing XD3ZH.ROM...
echo When FPT asks to continue, press Y.
fpt -f XD3ZH.ROM
pause
