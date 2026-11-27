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
echo  华南金牌 X99-T8 V6.0 - 刷写魔改版 8MB BIOS 区（推荐方式）
echo  HUANANZHI X99-T8 V6.0 - Flash Modded BIOS Region (8MB Only)
echo  刷写镜像 / Image: T8ZH_V60_8M.bin （仅 BIOS 区，保留原厂 IFD / ME）
echo ====================================================================
echo.
echo 说明 / Note: 本脚本仅覆盖 8MB BIOS 区域，完全不动主板原厂 IFD 与 ME。
echo 如需回退到原厂 T8V60.bin，可用编程器或刷写 bak\T8V60.bin 恢复。
echo.
echo [警告 / WARNING] 刷写期间切勿断电或重启，建议接入稳定电源/UPS！
echo.
pause
if not exist T8ZH_V60_8M.bin (
  echo [错误 / ERROR] 当前目录未找到 T8ZH_V60_8M.bin！
  pause
  goto end
)
if exist BACKUP_BIOS_PRE_T8V60.BIN del BACKUP_BIOS_PRE_T8V60.BIN
echo.
echo [1/2] 正在备份当前 8MB BIOS 区 / Backing up current BIOS region...
fptw64.exe -d BACKUP_BIOS_PRE_T8V60.BIN -bios
if errorlevel 1 goto backup_fail
if not exist BACKUP_BIOS_PRE_T8V60.BIN goto backup_fail
echo.
echo 备份完成 / Backup done: BACKUP_BIOS_PRE_T8V60.BIN （8MB BIOS 区）
echo.
echo [2/2] 正在刷入 T8ZH_V60_8M.bin / Writing T8ZH_V60_8M.bin to BIOS region...
echo 当 FPT 询问是否继续时，请按 Y / When FPT asks to continue, press Y.
fptw64.exe -f T8ZH_V60_8M.bin -bios
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
