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

title Меню разработчика

:menu
cls
echo ============================================
echo  Меню разработчика проекта
echo ============================================
echo 1. Проверить окружение
echo 2. Создать резервную копию
echo 3. Запустить Python-проект
echo 4. Запустить тесты
echo 5. Очистить кэш проекта
echo 6. Проанализировать логи
echo 7. Сделать Git-снимок
echo 8. Собрать архив для сдачи
echo 9. Открыть проект в VS Code
echo 0. Выход
echo ============================================
set /p CHOICE=Выберите действие: 

if "%CHOICE%"=="1" call "%SCRIPT_DIR%02_check_dev_environment.bat"
if "%CHOICE%"=="2" call "%SCRIPT_DIR%03_backup_project.bat"
if "%CHOICE%"=="3" call "%SCRIPT_DIR%04_run_python_project.bat"
if "%CHOICE%"=="4" call "%SCRIPT_DIR%05_run_tests_and_report.bat"
if "%CHOICE%"=="5" call "%SCRIPT_DIR%06_clean_project_cache.bat"
if "%CHOICE%"=="6" call "%SCRIPT_DIR%07_collect_errors_from_logs.bat"
if "%CHOICE%"=="7" call "%SCRIPT_DIR%08_git_snapshot.bat"
if "%CHOICE%"=="8" call "%SCRIPT_DIR%09_make_release_archive.bat"
if "%CHOICE%"=="9" (
    where code >nul 2>nul
    if errorlevel 1 (
        echo [ОШИБКА] Команда code не найдена. Откройте проект вручную в VS Code.
        pause
    ) else (
        code .
        pause
    )
)
if "%CHOICE%"=="0" exit /b 0

goto menu