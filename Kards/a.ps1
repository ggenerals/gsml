function Set-LauncherTitleForever {
    param(
        [string]$LauncherPath = "C:\Users\admin\AppData\Local\KARDS - The WWII Card Game\launcher.exe",
        [string]$Title = "[GSML] KARDS Launcher"
    )
    
    Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;
using System.Diagnostics;

public class TitleChanger 
{
    [DllImport("user32.dll")]
    private static extern bool EnumThreadWindows(uint dwThreadId, EnumWindowsProc lpEnumFunc, IntPtr lParam);
    [DllImport("user32.dll")]
    private static extern bool SetWindowText(IntPtr hWnd, string lpString);
    [DllImport("user32.dll")]
    private static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count);
    [DllImport("user32.dll")]
    private static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
    
    private delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
    
    public static void ChangeAllTitles(int processId, string newTitle) 
    {
        try 
        {
            Process process = Process.GetProcessById(processId);
            
            foreach (ProcessThread thread in process.Threads) 
            {
                EnumThreadWindows((uint)thread.Id, (hWnd, lParam) => 
                {
                    uint windowProcessId;
                    GetWindowThreadProcessId(hWnd, out windowProcessId);
                    
                    if (windowProcessId == processId) 
                    {
                        StringBuilder currentTitle = new StringBuilder(256);
                        GetWindowText(hWnd, currentTitle, currentTitle.Capacity);
                        
                        if (!string.IsNullOrEmpty(currentTitle.ToString())) 
                        {
                            SetWindowText(hWnd, newTitle);
                        }
                    }
                    return true;
                }, IntPtr.Zero);
            }
        }
        catch (Exception) 
        {
            // 进程可能已经退出
        }
    }
}
"@

    # 启动进程
    $process = Start-Process -FilePath $LauncherPath -PassThru
    Write-Host "启动器已启动 (PID: $($process.Id))" -ForegroundColor Green
    Write-Host "开始无限循环修改标题..." -ForegroundColor Yellow

    # 无限循环修改标题
    while (1) {
        try {
            [TitleChanger]::ChangeAllTitles($process.Id, $Title)
            Start-Sleep -Milliseconds 500  # 每500毫秒尝试一次
        }
        catch {
            # 如果进程退出，则结束循环
            Write-Host "进程已退出，停止修改标题" -ForegroundColor Red
            break
        }
    }
}

# 使用
Set-LauncherTitleForever