# Política de seguridad

WinTaller se ejecuta con permisos de administrador y cambia servicios, registro y archivos del sistema. Por eso cualquier fallo de seguridad se trata con prioridad.

## Versiones con soporte

Solo se corrigen fallos en la **última versión publicada** (ver [Releases](https://github.com/SylredComputers/WinTaller/releases)). Si usas una versión anterior, actualiza antes de informar.

## Cómo avisar de una vulnerabilidad

**No abras una incidencia pública.** Usa el aviso privado de GitHub:

1. Entra en la pestaña **Security** del repositorio.
2. Pulsa **Report a vulnerability**.
3. Indica la versión de WinTaller y de Windows, los pasos para reproducirlo y qué permite hacer.

Recibirás respuesta en cuanto sea posible. Cuando haya corrección, se publicará una versión nueva y se citará el aviso en el [CHANGELOG](CHANGELOG.md), con tu nombre si lo deseas.

## Qué se considera vulnerabilidad

- Que un proceso o usuario **sin permisos de administrador** consiga ejecutar código o cambiar algo a través de WinTaller elevado.
- Que se ejecute o instale software **sin verificar su firma** o desde un origen no previsto.
- Que una limpieza o una copia **borre o sobrescriba** algo fuera de lo indicado.
- Que se expongan datos del equipo o del usuario fuera de él.

Un ajuste que no funciona o una función que falla sin consecuencias de seguridad es una incidencia normal: ábrela en **Issues**.

## Cómo se protege WinTaller

- Sin telemetría propia: el programa no envía nada a Sylred Computers ni a terceros.
- Los archivos temporales, las descargas y las copias de ajustes se guardan en `C:\ProgramData\WinTaller`, accesible solo para SYSTEM y Administradores.
- Las limpiezas no siguen enlaces (junctions ni symlinks).
- Los instaladores descargados se comprueban antes de ejecutarse: HTTPS, firma digital válida y firmante esperado.
- Las herramientas de Windows se ejecutan por su ruta completa en `System32`; winget y Microsoft Defender, desde su ruta de instalación.
- Las páginas web y los informes se abren con la sesión normal del usuario, no como administrador.
- Cada cambio pide confirmación y guarda antes una copia de los ajustes para poder revertirlo.

## Comprobar una descarga

Cada versión publica el SHA-256 de su ZIP en las notas de la release. Compruébalo en PowerShell:

```powershell
Get-FileHash .\WinTaller-vX.Y.Z.zip -Algorithm SHA256
```

## Proceso de cada versión

1. El análisis automático de GitHub (sintaxis, PSScriptAnalyzer y `-SelfTest`) termina sin errores.
2. Se ejecuta `WinTaller.ps1 -UiSmokeTest` en Windows 11 y se prueba a mano cada función nueva.
3. Se revisan los identificadores de winget del catálogo y los firmantes de los instaladores que se descargan.
4. Se publica la release con su etiqueta `vX.Y.Z`, el ZIP y su SHA-256.
