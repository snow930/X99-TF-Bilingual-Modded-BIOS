@echo off
cls
echo ============================================================
echo  HUANANZHI X99-TF  -  BIOS FLASH (no backup step)
echo  Image: TFZH.ROM
echo ============================================================
echo.
echo WARNING: This script does NOT make a backup.
echo Only use it if you already have a full 16MB backup.
echo.
echo Do NOT power off during the write.
echo.
pause
echo Writing TFZH.ROM...
echo When FPT asks to continue, press Y.
fpt -f TFZH.ROM
pause
