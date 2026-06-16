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


title Проверка окружения разработчика

if not exist reports mkdir reports
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "TS=%%i"
set "REPORT=reports\dev_environment_%TS%.txt"

> "%REPORT%" echo ============================================
>> "%REPORT%" echo  Отчет проверки окружения разработчика
>> "%REPORT%" echo ============================================
>> "%REPORT%" echo Дата проверки: %DATE% %TIME%
>> "%REPORT%" echo.

echo Проверяю инструменты...
echo.

call :check_tool python "Python" "--version"
call :check_tool pip "Pip" "--version"
call :check_tool git "Git" "--version"
call :check_tool node "Node.js" "--version"
call :check_tool npm "NPM" "--version"
call :check_tool docker "Docker" "--version"
call :check_tool code "Visual Studio Code CLI" "--version"
call :check_tool java "Java" "-version"

>> "%REPORT%" echo.
>> "%REPORT%" echo Проверка завершена.

echo [OK] Отчет создан: %REPORT%
type "%REPORT%"
pause
exit /b 0

:check_tool
set "TOOL=%~1"
set "NAME=%~2"
set "ARGS=%~3"
where %TOOL% >nul 2>nul
if errorlevel 1 (
    echo [НЕТ] %NAME% не найден
    >> "%REPORT%" echo [НЕТ] %NAME% не найден
) else (
    echo [OK] %NAME% найден
    >> "%REPORT%" echo [OK] %NAME% найден
    %TOOL% %ARGS% >> "%REPORT%" 2>&1
    >> "%REPORT%" echo.
)
exit /b 0