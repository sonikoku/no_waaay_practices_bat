@echo off
chcp 65001 >nul
setlocal EnableExtensions
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%.") do set "SCRIPT_FOLDER=%%~nxI"
if /I "%SCRIPT_FOLDER%"=="scripts" (
    for %%I in ("%SCRIPT_DIR%..") do set "PROJECT_ROOT=%%~fI"
) else (
    set "PROJECT_ROOT=%SCRIPT_DIR:~0,-1%"
)
cd /d "%PROJECT_ROOT%"


title Анализ логов

echo ============================================
echo  Поиск ошибок и предупреждений в логах
echo ============================================
echo.

if not exist logs (
    echo [ОШИБКА] Папка logs не найдена.
    echo Создайте logs и положите туда .log или .txt файлы.
    pause
    exit /b 1
)

if not exist reports mkdir reports
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "TS=%%i"
set "REPORT=reports\log_analysis_%TS%.txt"

> "%REPORT%" echo Анализ логов
>> "%REPORT%" echo Дата: %DATE% %TIME%
>> "%REPORT%" echo.

echo Ищу ERROR, WARNING, Traceback, Exception, CRITICAL...
>> "%REPORT%" echo Найденные строки:
>> "%REPORT%" echo.

findstr /S /I /N /C:"ERROR" /C:"WARNING" /C:"Traceback" /C:"Exception" /C:"CRITICAL" logs\*.log logs\*.txt >> "%REPORT%" 2>nul

if errorlevel 1 (
    >> "%REPORT%" echo [OK] Критичные строки не найдены.
    echo [OK] Критичные строки не найдены.
) else (
    >> "%REPORT%" echo.
    >> "%REPORT%" echo [INFO] Найдены потенциальные ошибки.
    echo [INFO] Найдены потенциальные ошибки. Откройте отчет: %REPORT%
)

type "%REPORT%"
pause
exit /b 0