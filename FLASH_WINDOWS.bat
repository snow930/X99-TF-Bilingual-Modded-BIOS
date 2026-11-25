@echo off
chcp 65001 >nul
setlocal
fltmc >nul 2>&1
if errorlevel 1 (
  echo 正在请求管理员权限... / Requesting administrator privileges...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)
cd /d "%~dp0"
cls
echo ====================================================================
echo  华南金牌 X99-TF  -  Windows 整片刷写 BIOS（FPT 9.1）
echo  HUANANZHI X99-TF -  Full-Image BIOS Flash - Windows FPT 9.1
echo  刷写镜像 / Image: TFZH.ROM （16MB 全片 FD + ME + BIOS）
echo ====================================================================
echo.
echo 本脚本将依次执行 / This script will:
echo   1. 备份当前主板整片固件至 BACKUP.BIN / Back up current flash to BACKUP.BIN
echo   2. 写入 16MB 完整镜像 TFZH.ROM      / Write full 16MB image TFZH.ROM
echo.
echo [警告 / WARNING] 刷写期间切勿断电或重启，建议接入稳定电源/UPS！
echo Do NOT power off or reboot during flashing. Use a UPS if possible.
echo.
pause
if exist BACKUP.BIN del BACKUP.BIN
echo.
echo [1/2] 正在备份当前固件 / Backing up current flash...
fptw64.exe -d BACKUP.BIN
if errorlevel 1 goto backup_fail
if not exist BACKUP.BIN goto backup_fail
echo.
echo 备份完成 / Backup done: BACKUP.BIN
echo 建议将 BACKUP.BIN 复制到 U 盘或其他电脑留存备份。
echo Copy BACKUP.BIN to another computer or USB drive if possible.
echo.
echo [2/2] 正在刷入 TFZH.ROM / Writing TFZH.ROM...
echo 当 FPT 询问是否继续时，请按 Y / When FPT asks to continue, press Y.
fptw64.exe -f TFZH.ROM
if errorlevel 1 goto flash_fail
echo.
echo ====================================================================
echo  刷写完成！请重启并清 CMOS 或在 BIOS 中加载默认设置。
echo  Flash completed. Reboot and clear CMOS / Load Optimized Defaults.
echo ====================================================================
pause
goto end
:backup_fail
echo.
echo [错误 / ERROR] 备份失败，已中止刷写！BACKUP FAILED. Do NOT flash.
pause
goto end
:flash_fail
echo.
echo [错误 / ERROR] 刷写失败！请记录上方报错信息，切勿贸然断电。
echo FLASH FAILED. Note the error above before powering off.
pause
:end
endlocal
