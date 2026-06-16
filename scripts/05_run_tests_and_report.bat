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


title Тесты и отчет

echo ============================================
echo  Запуск тестов проекта и сохранение отчета
echo ============================================
echo.

if not exist reports mkdir reports
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "TS=%%i"
set "REPORT=reports\tests_%TS%.txt"

> "%REPORT%" echo Отчет тестирования
>> "%REPORT%" echo Дата: %DATE% %TIME%
>> "%REPORT%" echo.

if exist .venv\Scripts\activate.bat (
    call ".venv\Scripts\activate.bat"
)

where python >nul 2>nul
if errorlevel 1 (
    >> "%REPORT%" echo [ОШИБКА] Python не найден.
    echo [ОШИБКА] Python не найден.
    pause
    exit /b 1
)

if not exist tests (
    >> "%REPORT%" echo [ОШИБКА] Папка tests не найдена.
    echo [ОШИБКА] Папка tests не найдена.
    pause
    exit /b 1
)

python -m pytest --version >nul 2>nul
if errorlevel 1 (
    >> "%REPORT%" echo [INFO] Pytest не найден. Пробую установить pytest...
    python -m pip install pytest >> "%REPORT%" 2>&1
)

echo Запускаю тесты...
>> "%REPORT%" echo.
python -m pytest -q >> "%REPORT%" 2>&1
set "TEST_RESULT=!ERRORLEVEL!"

>> "%REPORT%" echo.
if "!TEST_RESULT!"=="0" (
    >> "%REPORT%" echo [OK] Все тесты пройдены.
    echo [OK] Все тесты пройдены.
) else (
    >> "%REPORT%" echo [FAIL] Есть ошибки в тестах.
    echo [FAIL] Есть ошибки в тестах. Откройте отчет: %REPORT%
)

type "%REPORT%"
pause
exit /b !TEST_RESULT!