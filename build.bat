@echo off
chcp 65001 >nul
title SKYBOX HYDRO OS - Установщик v3.0
color 0A

:: ==========================================
:: ПРОВЕРКА ПРАВ АДМИНИСТРАТОРА
:: ==========================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo ========================================
    echo   ОШИБКА: Требуются права администратора!
    echo   Запустите файл ПРАВОЙ КНОПКОЙ МЫШИ
    echo   -^> "Запуск от имени администратора"
    echo ========================================
    echo.
    pause
    exit
)

:: ==========================================
:: ПЕРЕХОД В ПАПКУ С БАТНИКОМ
:: ==========================================
cd /d "%~dp0"
set "SCRIPT_DIR=%CD%"

:: ==========================================
:: ЦВЕТА (РАБОТАЮТ В WINDOWS 10/11)
:: ==========================================
set "GREEN="
set "RED="
set "YELLOW="
set "BLUE="
set "RESET="

:: ==========================================
:: ГЛАВНОЕ МЕНЮ
:: ==========================================
:MENU
cls
echo.
echo ╔════════════════════════════════════════════════╗
echo ║                                                ║
echo ║       SKYBOX HYDRO OS v3.0                     ║
echo ║       Установщик (всё в одном файле)          ║
echo ║                                                ║
echo ╚════════════════════════════════════════════════╝
echo.
echo [1] Собрать систему
echo [2] Установить на флешку
echo [3] Установить на жёсткий диск
echo [4] Всё сразу (собрать + установить)
echo [5] Выйти
echo.
set /p CHOICE="Выберите действие (1-5): "

if "%CHOICE%"=="1" goto BUILD
if "%CHOICE%"=="2" goto FLASH
if "%CHOICE%"=="3" goto HDD
if "%CHOICE%"=="4" goto ALL
if "%CHOICE%"=="5" exit
goto MENU

:: ==========================================
:: 1. СБОРКА
:: ==========================================
:BUILD
cls
echo.
echo ════════════════════════════════════════
echo    СБОРКА СИСТЕМЫ
echo ════════════════════════════════════════
echo.

:: ИЩЕМ FASM
set "FASM_EXE="
if exist "fasm.exe" set "FASM_EXE=fasm.exe"
if exist "FASM.EXE" set "FASM_EXE=FASM.EXE"
if exist "fasm\fasm.exe" set "FASM_EXE=fasm\fasm.exe"
if exist "FASM\FASM.EXE" set "FASM_EXE=FASM\FASM.EXE"

:: ЕСЛИ FASM НЕ НАЙДЕН - СКАЧИВАЕМ
if "%FASM_EXE%"=="" (
    echo [!] FASM не найден! Скачиваю...
    echo.
    powershell -Command "Invoke-WebRequest -Uri 'https://flatassembler.net/fasmw17332.zip' -OutFile 'fasm.zip'"
    powershell -Command "Expand-Archive -Path fasm.zip -DestinationPath ."
    
    if exist "FASM\FASM.EXE" (
        copy "FASM\FASM.EXE" "fasm.exe"
        rd /s /q FASM
        del fasm.zip
        set "FASM_EXE=fasm.exe"
        echo [OK] FASM установлен!
    ) else (
        echo [ОШИБКА] Не удалось скачать FASM!
        echo.
        echo Скачайте вручную: https://flatassembler.net/download.php
        echo и поместите fasm.exe в папку:
        echo %SCRIPT_DIR%
        echo.
        pause
        goto MENU
    )
)

:: ОПРЕДЕЛЯЕМ ИСХОДНЫЙ ФАЙЛ
set "SOURCE_FILE="
if exist "skybox_hydro.asm" set "SOURCE_FILE=skybox_hydro.asm"
if exist "Os.asm" set "SOURCE_FILE=Os.asm"
if exist "hydro.asm" set "SOURCE_FILE=hydro.asm"

if "%SOURCE_FILE%"=="" (
    echo [ОШИБКА] Исходный файл (.asm) не найден!
    echo.
    echo Ищем файлы: skybox_hydro.asm, Os.asm, hydro.asm
    echo.
    echo Поместите один из этих файлов в папку:
    echo %SCRIPT_DIR%
    echo.
    pause
    goto MENU
)

echo Найден исходник: %SOURCE_FILE%
echo Компиляция...

"%FASM_EXE%" "%SOURCE_FILE%" "skybox_hydro.efi"

if %errorlevel% neq 0 (
    echo.
    echo [ОШИБКА] Сборка не удалась!
    echo Проверьте синтаксис %SOURCE_FILE%
    echo.
    pause
    goto MENU
)

if exist "skybox_hydro.efi" (
    echo.
    echo [OK] Сборка успешна!
    echo Файл: skybox_hydro.efi
    for %%A in ("skybox_hydro.efi") do echo Размер: %%~zA байт
) else (
    echo [ОШИБКА] Файл не создан!
)

echo.
pause
goto MENU

:: ==========================================
:: 2. УСТАНОВКА НА ФЛЕШКУ
:: ==========================================
:FLASH
cls
echo.
echo ════════════════════════════════════════
echo    УСТАНОВКА НА ФЛЕШКУ
echo ════════════════════════════════════════
echo.

:: ПРОВЕРЯЕМ ФАЙЛ
set "EFI_FILE="
if exist "skybox_hydro.efi" set "EFI_FILE=skybox_hydro.efi"
if exist "bootx64.efi" set "EFI_FILE=bootx64.efi"

if "%EFI_FILE%"=="" (
    echo [ОШИБКА] Файл .efi не найден!
    echo.
    echo Сначала соберите систему (пункт 1)
    echo Или поместите skybox_hydro.efi в папку
    echo.
    pause
    goto MENU
)

:: ПОКАЗЫВАЕМ ФЛЕШКИ
echo Доступные флешки:
echo.
wmic logicaldisk where drivetype=2 get deviceid,volumename,size
echo.
set /p DRIVE="Введите букву флешки (например E): "

if "%DRIVE%"=="" (
    echo [ОШИБКА] Не введена буква!
    pause
    goto MENU
)

:: УБИРАЕМ ДВОЕТОЧИЕ
set "DRIVE=%DRIVE::=%"

if not exist "%DRIVE%:\" (
    echo [ОШИБКА] Диск %DRIVE%: не найден!
    pause
    goto MENU
)

:: ФОРМАТИРОВАНИЕ
echo.
set /p FORMAT="Форматировать диск %DRIVE%: в FAT32? (y/n): "
if /i "%FORMAT%"=="y" (
    echo Форматирование %DRIVE%: в FAT32...
    format %DRIVE%: /FS:FAT32 /Q /V:HYDROOS /Y
    if %errorlevel% neq 0 (
        echo [ОШИБКА] Не удалось отформатировать!
        echo Попробуйте вручную: format %DRIVE%: /FS:FAT32 /Q
        pause
        goto MENU
    )
    echo [OK] Форматирование завершено
)

:: СОЗДАЁМ ПАПКИ
echo.
echo Создание структуры...
if not exist "%DRIVE%:\EFI" mkdir "%DRIVE%:\EFI"
if not exist "%DRIVE%:\EFI\BOOT" mkdir "%DRIVE%:\EFI\BOOT"
if not exist "%DRIVE%:\BOOT" mkdir "%DRIVE%:\BOOT"

:: КОПИРУЕМ
echo Копирование %EFI_FILE%...
copy "%EFI_FILE%" "%DRIVE%:\EFI\BOOT\bootx64.efi"

if %errorlevel% neq 0 (
    echo [ОШИБКА] Не удалось скопировать!
    pause
    goto MENU
)

:: КОПИРУЕМ ДОПОЛНИТЕЛЬНЫЕ ФАЙЛЫ
if exist "boot.bin" (
    echo Копирование boot.bin...
    copy "boot.bin" "%DRIVE%:\BOOT\"
)
if exist "boot2.bin" (
    echo Копирование boot2.bin...
    copy "boot2.bin" "%DRIVE%:\BOOT\"
)
if exist "box.txt" (
    echo Копирование box.txt...
    copy "box.txt" "%DRIVE%:\"
)

:: СОЗДАЁМ STARTUP.NSH
(
    echo echo "========================================"
    echo echo "   SKYBOX HYDRO OS v3.0"
    echo echo "   Загрузка с USB..."
    echo echo "========================================"
    echo echo.
    echo fs0:
    echo cd EFI\BOOT
    echo bootx64.efi
) > "%DRIVE%:\startup.nsh"

echo Skybox Hydro OS v3.0 > "%DRIVE%:\version.txt"

echo.
echo [OK] Флешка готова!
echo Путь: %DRIVE%:\EFI\BOOT\bootx64.efi
echo.
echo ДЕЙСТВИЯ:
echo 1. Перезагрузите компьютер
echo 2. Войдите в BIOS/UEFI (F2/DEL/F10)
echo 3. Включите UEFI Boot, отключите Secure Boot
echo 4. Выберите загрузку с USB %DRIVE%:
echo.
pause
goto MENU

:: ==========================================
:: 3. УСТАНОВКА НА ЖЁСТКИЙ ДИСК
:: ==========================================
:HDD
cls
echo.
echo ════════════════════════════════════════
echo    УСТАНОВКА НА ЖЁСТКИЙ ДИСК
echo ════════════════════════════════════════
echo.

if not exist "skybox_hydro.efi" (
    if not exist "bootx64.efi" (
        echo [ОШИБКА] Файл .efi не найден!
        echo Сначала соберите систему (пункт 1)
        echo.
        pause
        goto MENU
    )
)

:: ПОКАЗЫВАЕМ ДИСКИ
echo Доступные диски:
echo.
wmic logicaldisk where drivetype=3 get deviceid,volumename,size
echo.
set /p DRIVE="Введите букву диска (например C): "

if "%DRIVE%"=="" (
    echo [ОШИБКА] Не введена буква!
    pause
    goto MENU
)

set "DRIVE=%DRIVE::=%"

if not exist "%DRIVE%:\" (
    echo [ОШИБКА] Диск %DRIVE%: не найден!
    pause
    goto MENU
)

:: СОЗДАЁМ ПАПКУ EFI
echo.
if not exist "%DRIVE%:\EFI" mkdir "%DRIVE%:\EFI"
if not exist "%DRIVE%:\EFI\BOOT" mkdir "%DRIVE%:\EFI\BOOT"

:: КОПИРУЕМ
if exist "skybox_hydro.efi" (
    copy "skybox_hydro.efi" "%DRIVE%:\EFI\BOOT\bootx64.efi"
) else (
    copy "bootx64.efi" "%DRIVE%:\EFI\BOOT\bootx64.efi"
)

if %errorlevel% neq 0 (
    echo [ОШИБКА] Не удалось скопировать!
    pause
    goto MENU
)

echo.
echo [OK] Система установлена!
echo Путь: %DRIVE%:\EFI\BOOT\bootx64.efi
echo.
echo Внимание! Чтобы загрузиться:
echo 1. Войдите в BIOS/UEFI
echo 2. Добавьте загрузочный пункт в UEFI
echo 3. Или используйте загрузочное меню (F12)
echo.
pause
goto MENU

:: ==========================================
:: 4. ВСЁ СРАЗУ
:: ==========================================
:ALL
cls
echo.
echo ════════════════════════════════════════
echo    ВСЁ В ОДНОМ РЕЖИМЕ
echo ════════════════════════════════════════
echo.

:: СБОРКА
echo [1/3] Сборка системы...
call :BUILD_SILENT
if %errorlevel% neq 0 (
    echo [ОШИБКА] Сборка не удалась!
    pause
    goto MENU
)
echo [OK] Собрано

:: ФЛЕШКА
echo [2/3] Установка на флешку...
echo.
echo Доступные флешки:
wmic logicaldisk where drivetype=2 get deviceid
echo.
set /p DRIVE="Введите букву флешки: "

if "%DRIVE%"=="" (
    echo [ОШИБКА] Не введена буква!
    pause
    goto MENU
)

set "DRIVE=%DRIVE::=%"

if not exist "%DRIVE%:\" (
    echo [ОШИБКА] Диск не найден!
    pause
    goto MENU
)

if not exist "%DRIVE%:\EFI\BOOT" mkdir "%DRIVE%:\EFI\BOOT"
copy "skybox_hydro.efi" "%DRIVE%:\EFI\BOOT\bootx64.efi" >nul
echo [OK] Флешка %DRIVE%: готова

:: ЖЁСТКИЙ ДИСК
echo [3/3] Установка на жёсткий диск...
echo.
echo Доступные диски:
wmic logicaldisk where drivetype=3 get deviceid
echo.
set /p HDD="Введите букву диска (или Enter для пропуска): "

if not "%HDD%"=="" (
    set "HDD=%HDD::=%"
    if exist "%HDD%:\" (
        if not exist "%HDD%:\EFI\BOOT" mkdir "%HDD%:\EFI\BOOT"
        copy "skybox_hydro.efi" "%HDD%:\EFI\BOOT\bootx64.efi" >nul
        echo [OK] Установлено на диск %HDD%:
    )
)

echo.
echo ════════════════════════════════════════
echo    ВСЁ ГОТОВО!
echo ════════════════════════════════════════
echo.
echo Система установлена!
pause
goto MENU

:: ==========================================
:: ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
:: ==========================================

:BUILD_SILENT
set "FASM_EXE="
if exist "fasm.exe" set "FASM_EXE=fasm.exe"
if exist "FASM.EXE" set "FASM_EXE=FASM.EXE"

if "%FASM_EXE%"=="" (
    echo [ОШИБКА] FASM не найден!
    exit /b 1
)

set "SOURCE_FILE="
if exist "skybox_hydro.asm" set "SOURCE_FILE=skybox_hydro.asm"
if exist "Os.asm" set "SOURCE_FILE=Os.asm"

if "%SOURCE_FILE%"=="" (
    echo [ОШИБКА] Исходный файл не найден!
    exit /b 1
)

"%FASM_EXE%" "%SOURCE_FILE%" "skybox_hydro.efi" >nul 2>&1
exit /b %errorlevel%

:: ==========================================
:: КОНЕЦ
:: ==========================================