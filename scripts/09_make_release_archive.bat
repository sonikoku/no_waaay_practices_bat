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


title Упаковка проекта к сдаче

echo ============================================
echo  Сборка архива проекта для сдачи
echo ============================================
echo.

for %%A in ("%CD%") do set "PROJECT_NAME=%%~nxA"
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "TS=%%i"

set "RELEASE_ROOT=_release"
set "RELEASE_DIR=%RELEASE_ROOT%\%PROJECT_NAME%_%TS%"
set "ZIP_NAME=%PROJECT_NAME%_%TS%.zip"

if not exist "%RELEASE_ROOT%" mkdir "%RELEASE_ROOT%"
mkdir "%RELEASE_DIR%"

echo Копирую обязательные материалы...
if exist README.md copy README.md "%RELEASE_DIR%\README.md" >nul
if exist requirements.txt copy requirements.txt "%RELEASE_DIR%\requirements.txt" >nul
if exist src robocopy src "%RELEASE_DIR%\src" /E >nul
if exist tests robocopy tests "%RELEASE_DIR%\tests" /E >nul
if exist docs robocopy docs "%RELEASE_DIR%\docs" /E >nul
if exist scripts robocopy scripts "%RELEASE_DIR%\scripts" /E >nul
if exist screenshots robocopy screenshots "%RELEASE_DIR%\screenshots" /E >nul
if exist reports robocopy reports "%RELEASE_DIR%\reports" /E >nul

> "%RELEASE_DIR%\checklist.txt" echo Чек-лист сдачи проекта
>> "%RELEASE_DIR%\checklist.txt" echo [ ] README.md оформлен
>> "%RELEASE_DIR%\checklist.txt" echo [ ] Есть исходный код в src
>> "%RELEASE_DIR%\checklist.txt" echo [ ] Есть тесты или описание проверки
>> "%RELEASE_DIR%\checklist.txt" echo [ ] Есть скриншоты работы
>> "%RELEASE_DIR%\checklist.txt" echo [ ] Есть отчет/лог запуска
>> "%RELEASE_DIR%\checklist.txt" echo [ ] Проект открывается у проверяющего

if not exist README.md echo [WARN] README.md отсутствует. Добавьте описание проекта.
if not exist README.md >> "%RELEASE_DIR%\checklist.txt" echo [WARN] README.md отсутствует

echo Создаю zip-архив...
powershell -NoProfile -Command "Compress-Archive -Path '%RELEASE_DIR%\*' -DestinationPath '%RELEASE_ROOT%\%ZIP_NAME%' -Force"

if exist "%RELEASE_ROOT%\%ZIP_NAME%" (
    echo [OK] Архив создан: %RELEASE_ROOT%\%ZIP_NAME%
) else (
    echo [ОШИБКА] Архив не создан.
    pause
    exit /b 1
)

pause
exit /b 0