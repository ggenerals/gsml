@echo off
setlocal
chcp 65001

echo 1.3->1.4 版本更新。

echo [1/3] 卸载旧版本...
if exist "..\unins000.exe" (
    "..\unins000.exe" /SILENT /NORESTART
    echo 已调用卸载程序
) else (
    echo 未找到卸载程序，跳过卸载
)

echo [2/3] 使用 BITS 多线程下载最新安装包...
set DOWNLOAD_URL=https://j.1win.ggff.net/https://github.com/nxtblock/ggtoolbox/releases/download/v1.4/Setup.exe
set INSTALLER=Setup.exe

:: 删除旧的安装包
if exist "%INSTALLER%" del /f /q "%INSTALLER%"

:: 调用 PowerShell 的 Start-BitsTransfer (支持多线程)
powershell -Command "Start-BitsTransfer -Source '%DOWNLOAD_URL%' -Destination '%cd%\%INSTALLER%' -Priority Foreground"

if not exist "%INSTALLER%" (
    echo 下载失败，退出
    exit /b 1
)

echo [3/3] 安装新版本...
"%INSTALLER%" /DIR=".." /SILENT /NORESTART

echo 更新完成！
endlocal

timeout /t 5

start ../main.exe


exit
