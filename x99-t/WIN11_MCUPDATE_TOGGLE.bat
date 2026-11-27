@echo off
chcp 65001 >nul
setlocal EnableExtensions
fltmc >nul 2>&1
if errorlevel 1 (
  echo 正在请求管理员权限... / Requesting administrator privileges...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)
cd /d "%~dp0"
cls

set "SYS32=%SystemRoot%\System32"
set "INTEL_DLL=%SYS32%\mcupdate_GenuineIntel.dll"
set "AMD_DLL=%SYS32%\mcupdate_AuthenticAMD.dll"
set "SYS_BAK=%SYS32%\mcupdate_GenuineIntel.dll.intel_orig"
set "KIT_BAK=%~dp0bak\mcupdate_GenuineIntel.dll.intel_orig"

echo ====================================================================
echo  华南金牌 X99-T8  -  Win11 24H2/25H2 微码安全旁路开关
echo  HUANANZHI X99-T8 -  Win11 24H2/25H2 Safe Microcode Toggle
echo  原理/Method: 微软签名 mcupdate_AuthenticAMD.dll 原位替换
echo ====================================================================
echo.

if not exist "%INTEL_DLL%" goto missing_intel
if not exist "%AMD_DLL%" goto missing_amd

fc /b "%INTEL_DLL%" "%AMD_DLL%" >nul 2>&1
if not errorlevel 1 goto already_bypassed

echo [当前状态 / Current Status]
echo   官方 Intel 微码生效中（会阻止 0x306F2 全核鸡血解锁）
echo   STOCK INTEL MICROCODE ACTIVE - blocks Haswell-EP all-core turbo
echo.
echo 按 Y 启用微码安全旁路（解锁全核鸡血），按其他键退出。
echo Press [Y] to ENABLE Safe Microcode Bypass, or any other key to exit.
set /p "CH=请选择 / Select [Y/N]: "
if /i not "%CH%"=="Y" goto end

echo.
echo [1/4] 备份原版 Intel 微码 DLL / Backing up original Intel microcode DLL...
if not exist "%~dp0bak" mkdir "%~dp0bak"
if not exist "%SYS_BAK%" copy /y /b "%INTEL_DLL%" "%SYS_BAK%" >nul
if not exist "%KIT_BAK%" copy /y /b "%INTEL_DLL%" "%KIT_BAK%" >nul
if not exist "%SYS_BAK%" goto bak_fail

echo [2/4] 临时获取管理员写入权限 / Granting temporary write access...
takeown /f "%INTEL_DLL%" /a >nul
if errorlevel 1 goto perm_fail
icacls "%INTEL_DLL%" /grant *S-1-5-32-544:F >nul
if errorlevel 1 goto perm_fail

echo [3/4] 原位替换为微软签名 AMD 占位模块 / Replacing in-place with signed stub...
copy /y /b "%AMD_DLL%" "%INTEL_DLL%" >nul
if errorlevel 1 goto copy_fail
fc /b "%INTEL_DLL%" "%AMD_DLL%" >nul 2>&1
if errorlevel 1 goto copy_fail

echo [4/4] 还原 TrustedInstaller 所有权与系统权限 / Restoring TrustedInstaller ACLs...
icacls "%INTEL_DLL%" /setowner "NT SERVICE\TrustedInstaller" >nul 2>&1
icacls "%INTEL_DLL%" /grant:r "NT SERVICE\TrustedInstaller":F *S-1-5-18:RX *S-1-5-32-544:RX *S-1-5-32-545:RX >nul 2>&1

echo.
echo ====================================================================
echo  [成功 / SUCCESS] 微码安全旁路已启用！Safe Microcode Bypass ENABLED!
echo  请重启 Windows 使 E5-2696 v3 全核鸡血正式生效。
echo  Reboot Windows to activate All-Core Turbo Unlock.
echo  提示/Tip: 随时可再次运行本脚本查看状态或恢复原版微码。
echo ====================================================================
pause
goto end

:already_bypassed
echo [当前状态 / Current Status]
echo   全核鸡血微码旁路已启用（已使用微软签名占位模块）
echo   ALL-CORE TURBO BYPASS ACTIVE - signed stub is already in place
echo.
echo 无需额外操作；如需恢复官方原版 Intel 微码，请按 R，直接回车退出。
echo Press [R] to RESTORE original Intel microcode DLL, or Enter to exit.
set /p "CH=请选择 / Select [R/Exit]: "
if /i not "%CH%"=="R" goto end

set "RESTORE_SRC="
if exist "%SYS_BAK%" set "RESTORE_SRC=%SYS_BAK%"
if not defined RESTORE_SRC if exist "%KIT_BAK%" set "RESTORE_SRC=%KIT_BAK%"
if not defined RESTORE_SRC goto no_backup

echo.
echo 正在恢复原版 Intel 微码 / Restoring original Intel microcode DLL...
echo 来源 / Source: "%RESTORE_SRC%"
takeown /f "%INTEL_DLL%" /a >nul
if errorlevel 1 goto perm_fail
icacls "%INTEL_DLL%" /grant *S-1-5-32-544:F >nul
if errorlevel 1 goto perm_fail
copy /y /b "%RESTORE_SRC%" "%INTEL_DLL%" >nul
if errorlevel 1 goto copy_fail
icacls "%INTEL_DLL%" /setowner "NT SERVICE\TrustedInstaller" >nul 2>&1
icacls "%INTEL_DLL%" /grant:r "NT SERVICE\TrustedInstaller":F *S-1-5-18:RX *S-1-5-32-544:RX *S-1-5-32-545:RX >nul 2>&1

echo.
echo [成功 / SUCCESS] 已还原官方原版 Intel 微码，重启后生效。
echo Original Intel microcode DLL restored. Reboot to apply.
pause
goto end

:missing_intel
echo [错误 / ERROR] 未找到 "%INTEL_DLL%"！
echo Missing "%INTEL_DLL%"! Do NOT reboot until a valid signed DLL is restored.
pause
exit /b 1

:missing_amd
echo [错误 / ERROR] 未找到 "%AMD_DLL%"，无法执行微软签名替换。
echo Missing "%AMD_DLL%"! Cannot perform Microsoft-signed substitution.
pause
exit /b 1

:bak_fail
echo [错误 / ERROR] 创建备份文件失败，已中止操作。
echo Failed to create backup "%SYS_BAK%". Aborting.
pause
exit /b 1

:no_backup
echo [错误 / ERROR] 在 System32 和 flash_kit\bak 中均未找到原版微码备份！
echo Backup file not found in System32 or flash_kit\bak!
pause
exit /b 1

:perm_fail
echo [错误 / ERROR] 修改文件权限失败 / Failed to adjust permissions on "%INTEL_DLL%".
pause
exit /b 1

:copy_fail
echo [错误 / ERROR] 原位复制失败！重启前请务必确认 "%INTEL_DLL%" 完整！
echo In-place copy failed! Verify "%INTEL_DLL%" before rebooting!
pause
exit /b 1

:end
endlocal
