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


title Git-снимок проекта

echo ============================================
echo  Git-снимок перед сдачей проекта
echo ============================================
echo.

where git >nul 2>nul
if errorlevel 1 (
    echo [ОШИБКА] Git не найден.
    pause
    exit /b 1
)

if not exist .git (
    echo [INFO] Git-репозиторий не найден. Выполняю git init...
    git init
)

git config user.name >nul 2>nul
if errorlevel 1 git config user.name "Student"

git config user.email >nul 2>nul
if errorlevel 1 git config user.email "student@example.local"

if not exist reports mkdir reports
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "TS=%%i"
set "REPORT=reports\git_snapshot_%TS%.txt"

> "%REPORT%" echo Git-снимок проекта
>> "%REPORT%" echo Дата: %DATE% %TIME%
>> "%REPORT%" echo.

echo Текущий статус:
git status --short
git status --short >> "%REPORT%"

echo.
set /p MESSAGE=Введите текст коммита: 
if "%MESSAGE%"=="" set "MESSAGE=Учебный снимок проекта %TS%"

git add .
git commit -m "%MESSAGE%" >> "%REPORT%" 2>&1

if errorlevel 1 (
    echo [INFO] Коммит не создан. Возможно, нет изменений.
    >> "%REPORT%" echo [INFO] Коммит не создан. Возможно, нет изменений.
) else (
    echo [OK] Коммит создан.
    >> "%REPORT%" echo [OK] Коммит создан.
)

>> "%REPORT%" echo.
>> "%REPORT%" echo Последние коммиты:
git log --oneline -5 >> "%REPORT%" 2>&1

>> "%REPORT%" echo.
>> "%REPORT%" echo Удаленные репозитории:
git remote -v >> "%REPORT%" 2>&1

echo [OK] Отчет: %REPORT%
type "%REPORT%"
pause
exit /b 0