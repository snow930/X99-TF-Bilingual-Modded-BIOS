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
echo  华南金牌 X99-TF V3.0 - 刷写 V6.0 移植版 8MB BIOS 区（推荐方式）
echo  HUANANZHI X99-TF V3.0 - Flash Modded V6.0 BIOS Region (8MB Only)
echo  刷写镜像 / Image: TFZH_V60_8M.bin （仅 BIOS 区，保留 V3.0 原厂 FD / ME）
echo ====================================================================
echo.
echo 说明 / Note: 本脚本仅覆盖 8MB BIOS 区域，完全不动 V3.0 原厂 IFD 与 ME。
echo 如需回退到原 V3.0 稳定版，运行 ..\V3.0\FLASH_WINDOWS_BIOS_ONLY.bat 刷回 TFZH_8M.bin 即可。
echo.
echo [警告 / WARNING] 刷写期间切勿断电或重启，建议接入稳定电源/UPS！
echo.
pause
if not exist TFZH_V60_8M.bin (
  echo [错误 / ERROR] 当前目录未找到 TFZH_V60_8M.bin！
  pause
  goto end
)
if exist BACKUP_BIOS_PRE_V60.BIN del BACKUP_BIOS_PRE_V60.BIN
echo.
echo [1/2] 正在备份当前 8MB BIOS 区 / Backing up current BIOS region...
fptw64.exe -d BACKUP_BIOS_PRE_V60.BIN -bios
if errorlevel 1 goto backup_fail
if not exist BACKUP_BIOS_PRE_V60.BIN goto backup_fail
echo.
echo 备份完成 / Backup done: BACKUP_BIOS_PRE_V60.BIN （8MB BIOS 区）
echo.
echo [2/2] 正在刷入 TFZH_V60_8M.bin / Writing TFZH_V60_8M.bin to BIOS region...
echo 当 FPT 询问是否继续时，请按 Y / When FPT asks to continue, press Y.
fptw64.exe -f TFZH_V60_8M.bin -bios
if errorlevel 1 goto flash_fail
echo.
echo ====================================================================
echo  刷写完成！请关机断电清 CMOS（或进 BIOS 按 F3 加载优化默认值并 F4 保存）。
echo  注意：本版采用官方 V6.0 原生 Re-Size BAR，无需再运行 ReBarState.exe。
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
pause
:end
endlocal
