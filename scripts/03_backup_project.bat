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


title Резервная копия проекта

echo ============================================
echo  Автобэкап проекта перед изменениями
echo ============================================
echo.

set "SOURCE=%CD%"
for %%A in ("%SOURCE%") do set "PROJECT_NAME=%%~nxA"
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "TS=%%i"
set "BACKUP_ROOT=%USERPROFILE%\Desktop\project_backups"
set "BACKUP_DIR=%BACKUP_ROOT%\%PROJECT_NAME%_%TS%"

if not exist "%BACKUP_ROOT%" mkdir "%BACKUP_ROOT%"
mkdir "%BACKUP_DIR%"

echo Исходная папка: %SOURCE%
echo Куда сохраняем: %BACKUP_DIR%
echo.

echo Копирую файлы без тяжелых служебных папок...
robocopy "%SOURCE%" "%BACKUP_DIR%" /E /XD .git .venv venv node_modules __pycache__ .pytest_cache .mypy_cache dist build _release /XF *.pyc *.log > "%BACKUP_DIR%\backup_log.txt"
set "ROBOCOPY_CODE=%ERRORLEVEL%"

if %ROBOCOPY_CODE% GEQ 8 (
    echo [ОШИБКА] Robocopy завершился с ошибкой. Проверьте backup_log.txt
    pause
    exit /b 1
)

echo [OK] Резервная копия создана.
echo [OK] Лог копирования: %BACKUP_DIR%\backup_log.txt
pause
exit /b 0