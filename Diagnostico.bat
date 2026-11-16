@echo off
setlocal EnableExtensions
title Diagnostico - WinTaller
cd /d "%~dp0"

if not exist "%~dp0WinTaller.ps1" (
    echo No se encontro WinTaller.ps1 en esta carpeta.
    pause
    exit /b 1
)

if /i "%~1"=="/elevated" goto :run
"%SystemRoot%\System32\fltmc.exe" >nul 2>&1
if not errorlevel 1 goto :run

echo Solicitando permisos de administrador...
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "try { Start-Process -FilePath '%~f0' -ArgumentList '/elevated' -Verb RunAs -ErrorAction Stop } catch { Write-Host ''; Write-Host 'No se pudo solicitar la elevacion de permisos:'; Write-Host $_.Exception.Message; exit 1 }"
if errorlevel 1 pause
exit /b 0

:run
echo.
echo  Modo diagnostico
echo  ----------------
echo  La consola permanecera abierta aunque la ventana grafica se cierre.
echo  Asi podras ver cualquier mensaje de error.
echo.
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -STA -NoExit -File "%~dp0WinTaller.ps1"
