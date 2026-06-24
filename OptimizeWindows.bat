@echo off
title Windows 系統優化清理工具 - 主選單版
color 0A

:menu
cls
echo ============================================================
echo   Windows 系統優化清理工具 - 主選單
echo   ----------------------------------------------------------
echo   本工具僅進行系統環境清理，不會影響使用者檔案
echo   作者：Tony
echo ============================================================
echo.
echo   [1]  清理暫存檔
echo   [2]  清理 Prefetch
echo   [3]  清理 DNS 快取
echo   [4]  重啟 Explorer
echo   [5]  重置背景程序 (搜尋索引器、RuntimeBroker、OneDrive、Update Agent、Defender)
echo   [6]  Print Spooler 清理
echo   [7]  系統檔案檢查 (sfc /scannow)
echo   [8]  DISM 健康檢查
echo   [9]  磁碟清理 (cleanmgr)
echo   [A]  瀏覽器快取清理 (Edge/Chrome/Firefox)
echo   [B]  最近使用檔案紀錄清理
echo   [C]  縮圖快取清理
echo.
echo   [X]  執行全部步驟 (1~9, A~C)
echo   [0]  結束工作
echo ============================================================
echo.
echo   提示：15 秒內未輸入，將自動執行 [X] 全部步驟。
echo ============================================================
echo.

choice /c 0123456789ABCX /m "請輸入選項：" /T 15 /D X

if errorlevel 14 call :all
if errorlevel 13 call :stepC
if errorlevel 12 call :stepB
if errorlevel 11 call :stepA
if errorlevel 10 call :step9
if errorlevel 9 call :step8
if errorlevel 8 call :step7
if errorlevel 7 call :step6
if errorlevel 6 call :step5
if errorlevel 5 call :step4
if errorlevel 4 call :step3
if errorlevel 3 call :step2
if errorlevel 2 call :step1
if errorlevel 1 goto end

goto menu

:: Step 1 - 清理暫存檔
:step1
echo ------------------------------------------------------------
echo 正在執行第 1 步驟：清理暫存檔...
echo ------------------------------------------------------------
del /f /s /q %temp%\*.* >nul 2>&1
del /f /s /q C:\Windows\Temp\*.* >nul 2>&1
timeout /t 5 /nobreak >nul
goto :eof

:: Step 2 - 清理 Prefetch
:step2
echo ------------------------------------------------------------
echo 正在執行第 2 步驟：清理 Prefetch...
echo ------------------------------------------------------------
del /f /s /q C:\Windows\Prefetch\*.* >nul 2>&1
timeout /t 5 /nobreak >nul
goto :eof

:: Step 3 - 清理 DNS 快取
:step3
echo ------------------------------------------------------------
echo 正在執行第 3 步驟：清理 DNS 快取...
echo ------------------------------------------------------------
ipconfig /flushdns
timeout /t 5 /nobreak >nul
goto :eof

:: Step 4 - Explorer
:step4
echo ------------------------------------------------------------
echo 正在執行第 4 步驟：重啟 Windows Explorer...
echo ------------------------------------------------------------
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
timeout /t 5 /nobreak >nul
goto :eof

:: Step 5 - 重置背景程序
:step5
echo ------------------------------------------------------------
echo 正在執行第 5 步驟：重置背景程序...
echo ------------------------------------------------------------
taskkill /f /im SearchIndexer.exe >nul 2>&1
start SearchIndexer.exe
taskkill /f /im RuntimeBroker.exe >nul 2>&1
tasklist /fi "imagename eq OneDrive.exe" | find /i "OneDrive.exe" >nul
if not errorlevel 1 (
    taskkill /f /im OneDrive.exe >nul 2>&1
    start OneDrive.exe
)
taskkill /f /im wuauclt.exe >nul 2>&1
net stop wuauserv
net start wuauserv
taskkill /f /im msmpeng.exe >nul 2>&1
net stop WinDefend
net start WinDefend
timeout /t 5 /nobreak >nul
goto :eof

:: Step 6 - Print Spooler 清理
:step6
echo ------------------------------------------------------------
echo 正在執行第 6 步驟：Print Spooler 清理...
echo ------------------------------------------------------------
net stop spooler
del /f /q %systemroot%\System32\spool\PRINTERS\*.* >nul 2>&1
net start spooler
timeout /t 5 /nobreak >nul
goto :eof

:: Step 7 - 系統檔案檢查
:step7
echo ------------------------------------------------------------
echo 正在執行第 7 步驟：系統檔案檢查 (sfc /scannow)...
echo ------------------------------------------------------------
call sfc /scannow
timeout /t 5 /nobreak >nul
goto :eof

:: Step 8 - DISM 健康檢查
:step8
echo ------------------------------------------------------------
echo 正在執行第 8 步驟：DISM 健康檢查...
echo ------------------------------------------------------------
call DISM /Online /Cleanup-Image /CheckHealth
timeout /t 5 /nobreak >nul
goto :eof

:: Step 9 - 磁碟清理
:step9
echo ------------------------------------------------------------
echo 正在執行第 9 步驟：磁碟清理 (cleanmgr)...
echo ------------------------------------------------------------
call cleanmgr /sageset:1
call cleanmgr /sagerun:1
timeout /t 5 /nobreak >nul
goto :eof

:: Step A - 瀏覽器快取清理
:stepA
echo ------------------------------------------------------------
echo 正在執行第 A 步驟：瀏覽器快取清理...
echo ------------------------------------------------------------
rd /s /q "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1
rd /s /q "%LocalAppData%\Google\Chrome\User Data\Default\Cache" >nul 2>&1
rd /s /q "%AppData%\Mozilla\Firefox\Profiles" >nul 2>&1
timeout /t 5 /nobreak >nul
goto :eof

:: Step B - 最近使用檔案紀錄清理
:stepB
echo ------------------------------------------------------------
echo 正在執行第 B 步驟：最近使用檔案紀錄清理...
echo ------------------------------------------------------------
del /f /q "%AppData%\Microsoft\Windows\Recent\*.*" >nul 2>&1
timeout /t 5 /nobreak >nul
goto :eof

:: Step C - 縮圖快取清理
:stepC
echo ------------------------------------------------------------
echo 正在執行第 C 步驟：縮圖快取清理...
echo ------------------------------------------------------------
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache*.db" >nul 2>&1
timeout /t 5 /nobreak >nul
goto :eof

:: 執行全部步驟
:all
call :step1
call :step2
call :step3
call :step4
call :step5
call :step6
call :step7
call :step8
call :step9
call :stepA
call :stepB
call :stepC
goto end

:end
echo ============================================================
echo   優化清理完成！建議可重新開機以獲得最佳效果！
echo ============================================================
timeout /t 5 /nobreak >nul
exit
