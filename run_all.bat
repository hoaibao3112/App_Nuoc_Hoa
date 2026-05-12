@echo off
title Khoi chay Do an Nuoc Hoa - MOBILE MODE
echo -----------------------------------------
echo [1/3] Dang khoi chay Backend (Docker)...
echo -----------------------------------------
docker-compose up -d

echo.
echo [2/3] Dang khoi chay May ao Android...
echo -----------------------------------------
:: Kiem tra xem co may ao nao dang chay san khong
set "EMU_ID="
for /f "tokens=2 delims=•" %%a in ('flutter devices ^| findstr /i "emulator-"') do (
    set "EMU_ID=%%a"
)

if not "%EMU_ID%"=="" (
    echo May ao dang chay san roi, bo qua buoc khoi dong...
    goto wait_loop
)

:: Tim may ao co san dau tien de bat
set "TARGET_EMU="
for /f "tokens=1 delims=•" %%a in ('flutter emulators ^| findstr /i "android"') do (
    set "TARGET_EMU=%%a"
    goto launch_emu
)
:launch_emu
if "%TARGET_EMU%"=="" (
    echo [Loi] Khong tim thay may ao Android nao! Vui long tao may ao trong Android Studio.
    pause
    exit /b 1
)
set TARGET_EMU=%TARGET_EMU: =%
echo Dang bat may ao: %TARGET_EMU%
start /b flutter emulators --launch %TARGET_EMU%

echo Dang cho may ao ket noi...
:wait_loop
set "EMU_ID="
for /f "tokens=2 delims=•" %%a in ('flutter devices ^| findstr /i "emulator-"') do (
    set "EMU_ID=%%a"
)

if "%EMU_ID%"=="" (
    timeout /t 5 /nobreak > nul 2>nul || ping -n 5 127.0.0.1 > nul
    goto wait_loop
)

:: Xoa khoang trang xung quanh ID
set EMU_ID=%EMU_ID: =%

echo May ao da san sang voi ID: %EMU_ID%!

echo.
echo [3/3] Dang build va chay Frontend (Mobile)...
echo -----------------------------------------
cd my_app
flutter run --no-enable-impeller -d %EMU_ID%

pause
