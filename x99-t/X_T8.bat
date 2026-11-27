@echo off
cls
echo ============================================================
echo  HUANANZHI X99-T8 V6.0  -  BIOS FLASH (DOS / official FPT)
echo  Image: T8ZH_V60.ROM
echo ============================================================
echo.
echo This will:
echo   1. Back up the current SPI flash to BACKUP.BIN
echo   2. Write T8ZH_V60.ROM to the SPI flash
echo.
echo Do NOT power off during the write.
echo.
pause
if exist BACKUP.BIN del BACKUP.BIN
echo.
echo [1/2] Backing up current flash...
fpt -d BACKUP.BIN
if errorlevel 1 goto backup_fail
if not exist BACKUP.BIN goto backup_fail
echo.
echo Backup done: BACKUP.BIN
echo Copy it to another computer before continuing if possible.
echo.
echo [2/2] Writing T8ZH_V60.ROM...
echo When FPT asks to continue, press Y.
fpt -f T8ZH_V60.ROM
if errorlevel 1 goto flash_fail
echo.
echo ============================================================
echo  Flash completed. Remove USB and reboot.
echo  After reboot: clear CMOS or press F3 (Load Defaults) + F4.
echo ============================================================
pause
goto end
:backup_fail
echo.
echo BACKUP FAILED. Do NOT flash.
echo Check the error above, or make a backup by another method.
pause
goto end
:flash_fail
echo.
echo FLASH FAILED. Do not power off immediately.
echo Note the error above and use a hardware programmer if needed.
pause
:end
