@echo off
setlocal EnableExtensions
title WinTaller
cd /d "%~dp0"

set "PS1=%~dp0WinTaller.ps1"
if not exist "%PS1%" (
    echo.
    echo No se encontro WinTaller.ps1 en esta carpeta.
    echo Asegurate de que este archivo .bat y el .ps1 estan juntos.
    echo.
    pause
    exit /b 1
)

rem --- Evitar bucles de elevacion: si ya venimos elevados, ejecutar ---
if /i "%~1"=="/elevated" goto :run

rem --- Comprobar permisos de administrador (rutas completas: cmd busca primero en esta carpeta) ---
"%SystemRoot%\System32\fltmc.exe" >nul 2>&1
if not errorlevel 1 goto :run

echo Solicitando permisos de administrador...
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "try { Start-Process -FilePath '%~f0' -ArgumentList '/elevated' -Verb RunAs -ErrorAction Stop } catch { Write-Host ''; Write-Host 'No se pudo solicitar la elevacion de permisos:'; Write-Host $_.Exception.Message; exit 1 }"
if errorlevel 1 pause
exit /b 0

:run
echo.
echo  WinTaller
echo  ---------
echo  Esta ventana puede quedarse abierta detras del programa.
echo  Si la ventana grafica no aparece, revisa diagnostico.log.
echo.
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -STA -File "%PS1%"
set "RC=%ERRORLEVEL%"
if not "%RC%"=="0" (
    echo.
    echo El programa termino con el codigo %RC%.
    echo Revisa diagnostico.log para ver el detalle.
    echo.
    pause
)
exit /b %RC%
