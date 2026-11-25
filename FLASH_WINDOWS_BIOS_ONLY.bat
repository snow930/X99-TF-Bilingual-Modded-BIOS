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
echo  华南金牌 X99-TF  -  仅刷写 8MB BIOS 区域（备用方案）
echo  HUANANZHI X99-TF -  BIOS-Region-Only Flash - 8MB Fallback
echo  刷写镜像 / Image: TFZH_8M.bin （仅 BIOS 区，不动 FD / ME）
echo ====================================================================
echo.
echo 说明 / Note: 本脚本仅覆盖 8MB BIOS 区域，不改动 ME 与描述符区。
echo This writes ONLY the 8MB BIOS region and leaves ME/descriptor alone.
echo 仅在整片刷写被 ME 锁阻止时作为备用方案使用。
echo Use as fallback if full-image flashing is blocked by ME region lock.
echo.
echo [警告 / WARNING] 刷写期间切勿断电或重启，建议接入稳定电源/UPS！
echo Do NOT power off or reboot during flashing. Use a UPS if possible.
echo.
pause
if exist BACKUP_BIOS.BIN del BACKUP_BIOS.BIN
echo.
echo [1/2] 正在备份当前 8MB BIOS 区 / Backing up current BIOS region...
fptw64.exe -d BACKUP_BIOS.BIN -bios
if errorlevel 1 goto backup_fail
if not exist BACKUP_BIOS.BIN goto backup_fail
echo.
echo 备份完成 / Backup done: BACKUP_BIOS.BIN （8MB BIOS 区）
echo.
echo [2/2] 正在刷入 TFZH_8M.bin / Writing TFZH_8M.bin to BIOS region...
echo 当 FPT 询问是否继续时，请按 Y / When FPT asks to continue, press Y.
fptw64.exe -f TFZH_8M.bin -bios
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
