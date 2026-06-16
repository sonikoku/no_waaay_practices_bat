@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%.") do set "SCRIPT_FOLDER=%%~nxI"
if /I "%SCRIPT_FOLDER%"=="scripts" (
    for %%I in ("%SCRIPT_DIR%..") do set "PROJECT_ROOT=%%~fI"
) else (
    set "PROJECT_ROOT=%SCRIPT_DIR:~0,-1%"
)
cd /d "%PROJECT_ROOT%"


title Запуск Python-проекта

echo ============================================
echo  Запуск проекта с виртуальным окружением
echo ============================================
echo.

where python >nul 2>nul
if errorlevel 1 (
    echo [ОШИБКА] Python не найден. Установите Python и добавьте его в PATH.
    pause
    exit /b 1
)

if not exist logs mkdir logs
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "TS=%%i"
set "LOG=logs\run_%TS%.log"

if not exist .venv (
    echo [1/4] Создаю виртуальное окружение...
    python -m venv .venv >> "%LOG%" 2>&1
    if errorlevel 1 (
        echo [ОШИБКА] Не удалось создать .venv. Смотрите лог: %LOG%
        pause
        exit /b 1
    )
)

call ".venv\Scripts\activate.bat"
if errorlevel 1 (
    echo [ОШИБКА] Не удалось активировать .venv.
    pause
    exit /b 1
)

if exist requirements.txt (
    echo [2/4] Устанавливаю зависимости из requirements.txt...
    python -m pip install --upgrade pip >> "%LOG%" 2>&1
    python -m pip install -r requirements.txt >> "%LOG%" 2>&1
) else (
    echo [2/4] requirements.txt не найден, пропускаю установку зависимостей.
)

set "APP_ERROR=0"
if exist src\main.py (
    echo [3/4] Запускаю src\main.py...
    >> "%LOG%" echo ===== START %DATE% %TIME% =====
    python src\main.py >> "%LOG%" 2>&1
    set "APP_ERROR=!ERRORLEVEL!"
) else if exist main.py (
    echo [3/4] Запускаю main.py...
    >> "%LOG%" echo ===== START %DATE% %TIME% =====
    python main.py >> "%LOG%" 2>&1
    set "APP_ERROR=!ERRORLEVEL!"
) else (
    echo [ОШИБКА] Не найден main.py или src\main.py
    >> "%LOG%" echo [ОШИБКА] Не найден main.py или src\main.py
    pause
    exit /b 1
)

if not "!APP_ERROR!"=="0" (
    echo [ОШИБКА] Проект завершился с ошибкой. Смотрите лог: %LOG%
    pause
    exit /b 1
)

echo [4/4] Готово. Лог запуска: %LOG%
type "%LOG%"
pause
exit /b 0