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
echo  华南金牌 X99-TF V3.0 - 整片刷写 V6.0 移植混合版（16MB FD+ME+BIOS）
echo  HUANANZHI X99-TF V3.0 - Full 16MB Flash (V3.0 IFD/ME + Modded V6.0 BIOS)
echo  刷写镜像 / Image: TFZH_V60.ROM （前 8MB 为 V3.0 原厂，后 8MB 为魔改 V6.0）
echo ====================================================================
echo.
echo 建议优先使用 FLASH_WINDOWS_V60_BIOS_ONLY.bat 仅刷 8MB BIOS 区。
echo 本脚本适用于需要完整写入 16MB 混合镜像的场景。
echo.
echo [警告 / WARNING] 刷写期间切勿断电或重启，建议接入稳定电源/UPS！
echo.
pause
if not exist TFZH_V60.ROM (
  echo [错误 / ERROR] 当前目录未找到 TFZH_V60.ROM！
  pause
  goto end
)
if exist BACKUP_PRE_V60.BIN del BACKUP_PRE_V60.BIN
echo.
echo [1/2] 正在备份当前 16MB 完整固件 / Backing up full 16MB flash...
fptw64.exe -d BACKUP_PRE_V60.BIN
if errorlevel 1 goto backup_fail
if not exist BACKUP_PRE_V60.BIN goto backup_fail
echo.
echo 备份完成 / Backup done: BACKUP_PRE_V60.BIN
echo.
echo [2/2] 正在刷入 TFZH_V60.ROM / Writing TFZH_V60.ROM...
echo 当 FPT 询问是否继续时，请按 Y / When FPT asks to continue, press Y.
fptw64.exe -f TFZH_V60.ROM
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
