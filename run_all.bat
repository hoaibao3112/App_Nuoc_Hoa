@echo off
title Khoi chay Do an Nuoc Hoa - MOBILE MODE
echo -----------------------------------------
echo [1/3] Dang khoi chay Backend (Docker)...
echo -----------------------------------------
docker-compose up -d

echo.
echo [2/3] Dang khoi chay May ao Android (Pixel 8)...
echo -----------------------------------------
:: Bat may ao
start /b flutter emulators --launch Pixel_8

echo Dang cho may ao ket noi...
:wait_loop
:: Kiem tra xem co thiet bi emulator nao online chua
flutter devices | findstr /i "emulator-" > nul
if errorlevel 1 (
    timeout /t 5 /nobreak > nul 2>nul || ping -n 5 127.0.0.1 > nul
    goto wait_loop
)

echo May ao da san sang!

echo.
echo [3/3] Dang build va chay Frontend (Mobile)...
echo -----------------------------------------
cd my_app
:: Su dung ID mac dinh cua may ao de chay
flutter run -d emulator-5554

pause
