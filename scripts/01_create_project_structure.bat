@echo off
chcp 65001 >nul
setlocal EnableExtensions
cd /d "%~dp0"

title Генератор структуры проекта

echo ============================================
echo  Генератор структуры учебного проекта
echo ============================================
echo.

set /p PROJECT_NAME=Введите название проекта: 
if "%PROJECT_NAME%"=="" set "PROJECT_NAME=student_project"
set "PROJECT_NAME=%PROJECT_NAME:"=%"

if exist "%PROJECT_NAME%\" (
    echo [ОШИБКА] Папка "%PROJECT_NAME%" уже существует.
    echo Выберите другое название или удалите старую папку.
    pause
    exit /b 1
)

mkdir "%PROJECT_NAME%"
mkdir "%PROJECT_NAME%\src"
mkdir "%PROJECT_NAME%\tests"
mkdir "%PROJECT_NAME%\docs"
mkdir "%PROJECT_NAME%\scripts"
mkdir "%PROJECT_NAME%\logs"
mkdir "%PROJECT_NAME%\reports"
mkdir "%PROJECT_NAME%\screenshots"

> "%PROJECT_NAME%\README.md" echo # %PROJECT_NAME%
>> "%PROJECT_NAME%\README.md" echo.
>> "%PROJECT_NAME%\README.md" echo Учебный проект, созданный через BAT-скрипт.
>> "%PROJECT_NAME%\README.md" echo.
>> "%PROJECT_NAME%\README.md" echo ## Быстрый запуск
>> "%PROJECT_NAME%\README.md" echo 1. Откройте папку проекта в VS Code.
>> "%PROJECT_NAME%\README.md" echo 2. Запустите scripts\run_project.bat.
>> "%PROJECT_NAME%\README.md" echo 3. Для тестов используйте python -m pytest.
>> "%PROJECT_NAME%\README.md" echo.
>> "%PROJECT_NAME%\README.md" echo ## Структура
>> "%PROJECT_NAME%\README.md" echo src - исходный код
>> "%PROJECT_NAME%\README.md" echo tests - тесты
>> "%PROJECT_NAME%\README.md" echo docs - документация
>> "%PROJECT_NAME%\README.md" echo scripts - вспомогательные скрипты
>> "%PROJECT_NAME%\README.md" echo logs - логи запуска
>> "%PROJECT_NAME%\README.md" echo reports - отчеты
>> "%PROJECT_NAME%\README.md" echo screenshots - скриншоты работы

> "%PROJECT_NAME%\.gitignore" echo __pycache__/
>> "%PROJECT_NAME%\.gitignore" echo .venv/
>> "%PROJECT_NAME%\.gitignore" echo .pytest_cache/
>> "%PROJECT_NAME%\.gitignore" echo logs/
>> "%PROJECT_NAME%\.gitignore" echo reports/*.log
>> "%PROJECT_NAME%\.gitignore" echo node_modules/
>> "%PROJECT_NAME%\.gitignore" echo dist/
>> "%PROJECT_NAME%\.gitignore" echo build/

> "%PROJECT_NAME%\requirements.txt" echo pytest

> "%PROJECT_NAME%\src\__init__.py" echo # package marker
> "%PROJECT_NAME%\src\main.py" echo def add^(a, b^):
>> "%PROJECT_NAME%\src\main.py" echo     return a + b
>> "%PROJECT_NAME%\src\main.py" echo.
>> "%PROJECT_NAME%\src\main.py" echo def format_task^(title, status="new"^):
>> "%PROJECT_NAME%\src\main.py" echo     return f"[{status.upper^(^)}] {title}"
>> "%PROJECT_NAME%\src\main.py" echo.
>> "%PROJECT_NAME%\src\main.py" echo if __name__ == "__main__":
>> "%PROJECT_NAME%\src\main.py" echo     print^("Demo project started"^)
>> "%PROJECT_NAME%\src\main.py" echo     print^(format_task^("Проверить BAT-файлы", "done"^)^)
>> "%PROJECT_NAME%\src\main.py" echo     print^("2 + 3 =", add^(2, 3^)^)

> "%PROJECT_NAME%\tests\test_main.py" echo from src.main import add, format_task
>> "%PROJECT_NAME%\tests\test_main.py" echo.
>> "%PROJECT_NAME%\tests\test_main.py" echo def test_add^(^):
>> "%PROJECT_NAME%\tests\test_main.py" echo     assert add^(2, 3^) == 5
>> "%PROJECT_NAME%\tests\test_main.py" echo.
>> "%PROJECT_NAME%\tests\test_main.py" echo def test_format_task^(^):
>> "%PROJECT_NAME%\tests\test_main.py" echo     assert format_task^("build", "done"^) == "[DONE] build"

> "%PROJECT_NAME%\logs\app.log" echo INFO App started
>> "%PROJECT_NAME%\logs\app.log" echo WARNING Demo warning for log analyzer
>> "%PROJECT_NAME%\logs\app.log" echo ERROR Demo error for log analyzer

> "%PROJECT_NAME%\scripts\run_project.bat" echo @echo off
>> "%PROJECT_NAME%\scripts\run_project.bat" echo chcp 65001 ^>nul
>> "%PROJECT_NAME%\scripts\run_project.bat" echo cd /d "%%~dp0.."
>> "%PROJECT_NAME%\scripts\run_project.bat" echo python src\main.py
>> "%PROJECT_NAME%\scripts\run_project.bat" echo pause

echo.
echo [OK] Структура проекта создана: %PROJECT_NAME%
echo [OK] Внутри уже есть готовый main.py, тесты и пример app.log.
echo [OK] Откройте папку в VS Code и запустите scripts\run_project.bat.
pause
exit /b 0