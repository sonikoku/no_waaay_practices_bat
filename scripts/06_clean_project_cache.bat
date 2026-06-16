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


title Очистка проекта

echo ============================================
echo  Очистка временных файлов проекта
echo ============================================
echo.
echo Скрипт удалит только кэши и временные папки:
echo __pycache__, .pytest_cache, .mypy_cache, .ruff_cache, dist, build, htmlcov, .next, .vite
echo.
set /p CONFIRM=Продолжить? Введите YES: 
if /I not "%CONFIRM%"=="YES" (
    echo Отмена операции.
    pause
    exit /b 0
)

echo.
echo Удаляю временные папки...
for %%N in (__pycache__ .pytest_cache .mypy_cache .ruff_cache dist build htmlcov .next .vite) do (
    for /d /r %%D in (%%N) do (
        if exist "%%D" (
            echo Удаляю: %%D
            rmdir /s /q "%%D"
        )
    )
)

echo Удаляю *.pyc...
del /s /q *.pyc >nul 2>nul

echo.
echo [OK] Очистка завершена.
pause
exit /b 0