@echo off
title SKYBOX HYDRO OS - Установщик

:: ==========================================
:: ЦВЕТА ДЛЯ КРАСОТЫ
:: ==========================================
color 0A
set "GREEN=[92m"
set "RED=[91m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "RESET=[0m"

:: ==========================================
:: ЗАГОЛОВОК
:: ==========================================
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
choice /c 12345 /n /m "Выберите действие: "

if errorlevel 5 exit /b
if errorlevel 4 goto ALL
if errorlevel 3 goto HDD
if errorlevel 2 goto FLASH
if errorlevel 1 goto BUILD

:: ==========================================
:: СБОРКА
:: ==========================================
:BUILD
cls
echo.
echo ════════════════════════════════════════
echo    СБОРКА СИСТЕМЫ
echo ════════════════════════════════════════
echo.

:: Проверяем FASM
fasm >nul 2>&1
if %errorlevel% neq 0 (
    echo [ОШИБКА] FASM не найден!
    echo.
    echo Скачайте FASM с https://flatassembler.net
    echo Или поместите fasm.exe в эту папку
    echo.
    pause
    goto MENU
)

:: Проверяем файл
if not exist "skybox_hydro.asm" (
    echo [ОШИБКА] Файл skybox_hydro.asm не найден!
    echo.
    pause
    goto MENU
)

echo Сборка...
fasm skybox_hydro.asm skybox_hydro.efi

if %errorlevel% neq 0 (
    echo.
    echo [ОШИБКА] Сборка не удалась!
    pause
    goto MENU
)

echo.
echo [OK] Сборка успешна!
echo Файл: skybox_hydro.efi
dir skybox_hydro.efi | find "skybox_hydro.efi"
echo.
pause
goto MENU

:: ==========================================
:: УСТАНОВКА НА ФЛЕШКУ
:: ==========================================
:FLASH
cls
echo.
echo ════════════════════════════════════════
echo    УСТАНОВКА НА ФЛЕШКУ
echo ════════════════════════════════════════
echo.

:: Проверяем файл
if not exist "skybox_hydro.efi" (
    echo [ОШИБКА] Сначала соберите систему (пункт 1)
    echo.
    pause
    goto MENU
)

:: Показываем флешки
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

if not exist "%DRIVE%:\" (
    echo [ОШИБКА] Диск %DRIVE%: не найден!
    pause
    goto MENU
)

:: Спрашиваем про форматирование
echo.
set /p FORMAT="Форматировать диск в FAT32? (y/n): "
if /i "%FORMAT%"=="y" (
    echo Форматирование %DRIVE%: в FAT32...
    format %DRIVE%: /FS:FAT32 /Q /Y
    if %errorlevel% neq 0 (
        echo [ОШИБКА] Не удалось отформатировать!
        pause
        goto MENU
    )
)

:: Создаём папки
echo.
echo Создание структуры...
if not exist "%DRIVE%:\EFI" mkdir "%DRIVE%:\EFI"
if not exist "%DRIVE%:\EFI\BOOT" mkdir "%DRIVE%:\EFI\BOOT"

:: Копируем файл
echo Копирование...
copy "skybox_hydro.efi" "%DRIVE%:\EFI\BOOT\bootx64.efi"

if %errorlevel% neq 0 (
    echo [ОШИБКА] Не удалось скопировать!
    pause
    goto MENU
)

:: Дополнительные файлы
if exist "box.txt" copy "box.txt" "%DRIVE%:\"
if exist "images" xcopy "images" "%DRIVE%:\images" /E /I /Y >nul

echo.
echo [OK] Флешка готова!
echo Путь: %DRIVE%:\EFI\BOOT\bootx64.efi
echo.
pause
goto MENU

:: ==========================================
:: УСТАНОВКА НА ЖЁСТКИЙ ДИСК
:: ==========================================
:HDD
cls
echo.
echo ════════════════════════════════════════
echo    УСТАНОВКА НА ЖЁСТКИЙ ДИСК
echo ════════════════════════════════════════
echo.

if not exist "skybox_hydro.efi" (
    echo [ОШИБКА] Сначала соберите систему (пункт 1)
    echo.
    pause
    goto MENU
)

:: Показываем диски
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

if not exist "%DRIVE%:\" (
    echo [ОШИБКА] Диск %DRIVE%: не найден!
    pause
    goto MENU
)

:: Проверяем права администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ОШИБКА] Запустите от имени администратора!
    echo.
    pause
    goto MENU
)

:: Создаём папку EFI
echo.
if not exist "%DRIVE%:\EFI" mkdir "%DRIVE%:\EFI"
if not exist "%DRIVE%:\EFI\BOOT" mkdir "%DRIVE%:\EFI\BOOT"

:: Копируем
copy "skybox_hydro.efi" "%DRIVE%:\EFI\BOOT\bootx64.efi"

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
echo 2. Добавьте загрузочный пункт
echo 3. Или используйте загрузочное меню (F12)
echo.
pause
goto MENU

:: ==========================================
:: ВСЁ СРАЗУ
:: ==========================================
:ALL
cls
echo.
echo ════════════════════════════════════════
echo    ВСЁ В ОДНОМ РЕЖИМЕ
echo ════════════════════════════════════════
echo.

:: Сборка
echo [1/3] Сборка системы...
fasm skybox_hydro.asm skybox_hydro.efi >nul 2>&1
if %errorlevel% neq 0 (
    echo [ОШИБКА] Сборка не удалась!
    echo.
    pause
    goto MENU
)
echo [OK] Собрано

:: Флешка
echo [2/3] Установка на флешку...
echo.
echo Доступные флешки:
wmic logicaldisk where drivetype=2 get deviceid
echo.
set /p DRIVE="Введите букву флешки: "

if not exist "%DRIVE%:\" (
    echo [ОШИБКА] Диск не найден!
    pause
    goto MENU
)

if not exist "%DRIVE%:\EFI\BOOT" mkdir "%DRIVE%:\EFI\BOOT"
copy "skybox_hydro.efi" "%DRIVE%:\EFI\BOOT\bootx64.efi" >nul
echo [OK] Флешка готова

:: Жёсткий диск
echo [3/3] Установка на жёсткий диск...
net session >nul 2>&1
if %errorlevel% equ 0 (
    echo.
    echo Доступные диски:
    wmic logicaldisk where drivetype=3 get deviceid
    echo.
    set /p HDD="Введите букву диска: "
    
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
echo Система установлена на:
echo - Флешку: %DRIVE%:
echo - Диск: %HDD% (если установлен)
echo.
pause
goto MENU

:: ==========================================
:: ГЛАВНОЕ МЕНЮ
:: ==========================================
:MENU
cls
goto :eof