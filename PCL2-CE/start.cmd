@echo off

chcp 65001

if exist ".\PCL2\Plain Craft Launcher.exe" goto skip

echo ========================================
echo 正在下载 PCL2 启动器
echo ========================================

:: 修正：移除 URL 末尾空格，并用引号包裹路径
powershell -Command "Start-BitsTransfer -Source 'https://j.1win.ggff.net/https://github.com/OI-liyifan202201/nbsmc-PCL2-in-GSML/raw/refs/heads/main/nbsmc.zip' -Destination 'nbsmc.zip'"

if errorlevel 1 (
    echo 下载失败！请检查网络或稍后重试。
    pause
    exit /b 1
)

echo 下载完成！
echo ========================================
echo 正在解压文件
echo ========================================

powershell -Command "Expand-Archive -Path 'nbsmc.zip' -DestinationPath '.\PCL2' -Force"

echo 解压完成！
:skip

echo ========================================
echo 启动 PCL2 启动器
echo ========================================
start "" ".\PCL2\Plain Craft Launcher.exe"

ping 127.0.0.1 -n 3 >nul
exit /b
