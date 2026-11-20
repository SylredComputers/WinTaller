@echo off
setlocal EnableExtensions
cd /d "%~dp0"

set "PS1=%~dp0WinTaller.ps1"
if not exist "%PS1%" (
    title WinTaller
    echo.
    echo No se encontro WinTaller.ps1 en esta carpeta.
    echo Asegurate de que este archivo .bat y el .ps1 estan juntos.
    echo.
    pause
    exit /b 1
)

rem --- Abre WinTaller sin consola visible y con permisos de administrador ---
rem Si algo falla al arrancar, usa Diagnostico.bat: deja la consola abierta
rem y el detalle queda en diagnostico.log.
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "$a = '-NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File {0}{1}{0}' -f [char]34, $env:PS1; try { Start-Process -FilePath (Join-Path $PSHOME 'powershell.exe') -ArgumentList $a -Verb RunAs -WindowStyle Hidden -ErrorAction Stop } catch { Add-Type -AssemblyName System.Windows.Forms; [void][System.Windows.Forms.MessageBox]::Show('No se ha podido abrir WinTaller con permisos de administrador.' + [Environment]::NewLine + [Environment]::NewLine + $_.Exception.Message, 'WinTaller', 'OK', 'Warning') }"
exit /b 0
