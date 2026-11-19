# Historial de cambios

## Sin publicar

**Seguridad**
- Módulo común de seguridad: punto de restauración verificado (`New-WinTallerRestorePoint`), copia de claves del registro antes de borrarlas y cuarentena en `C:\ProgramData\WinTaller\cuarentena` (carpetas, archivos y claves) con restauración a su ruta original. Nunca se mueven ni borran rutas o claves protegidas del sistema.
- Desinstalar: crea un punto de restauración antes de empezar y pide confirmación si no se puede verificar.

**Correcciones**
- Desinstalar: se espera a los procesos hijo del desinstalador (NSIS, Inno Setup…). Antes, los que se copian a TEMP y salen enseguida se daban por terminados mientras seguían trabajando. Al detener la cola también se cierran esos procesos.

## v2.1.2

Segunda tanda de correcciones de la auditoría de seguridad.

**Seguridad**
- Copias: aviso cuando la unidad de destino no está cifrada con BitLocker.
- Los desinstaladores que se ejecutan mediante `cmd.exe /c` muestran el comando y piden confirmación con permisos de administrador.
- Fallos que antes se ignoraban al cambiar el sistema ahora se avisan o se anotan: límite de puntos de restauración, arranque de Windows Update y de la Optimización de entrega, tareas programadas al revertir, restablecimiento de red y cambios de la pestaña Privacidad.

**Proyecto**
- `SECURITY.md`: cómo avisar de una vulnerabilidad en privado y cómo se publica cada versión.
- Análisis automático en GitHub Actions en cada cambio: sintaxis en PowerShell 5.1, PSScriptAnalyzer y autocomprobación `-SelfTest`.

## v2.1.1

Correcciones de la auditoría de seguridad (ISO/IEC 27001 / 27002).

**Seguridad**
- Las páginas web y los informes se abren con la sesión normal del usuario: el navegador ya no arranca con permisos de administrador.
- El instalador de TinyWall solo se ejecuta si lo firma su autor (Károly Dávid Pados), no basta con cualquier firma válida.
- Las herramientas de Windows se ejecutan por su ruta completa en `System32`, también en `Iniciar.bat` y `Diagnostico.bat`. Los desinstaladores que indican un programa sin ruta (`rundll32.exe`…) se buscan en `System32`.
- Aviso al arrancar si el programa se eleva con la cuenta de otro administrador: los ajustes de usuario irían a esa cuenta.

**Mejoras**
- `diagnostico.log` se renueva al pasar de 1 MB (se conserva el anterior como `diagnostico.anterior.log`).
- El informe de batería lleva la fecha en el nombre y ya no sobrescribe el anterior.
- El informe del equipo indica que contiene datos confidenciales.

## v2.1.0

**Novedades**
- **Protección › Puertos:** escáner de los puertos a la escucha, con el programa que los abre, sus servicios y su firma digital. Indica si el cortafuegos de Windows deja entrar conexiones para el perfil de red activo y valora cada puerto. Permite bloquear un puerto con una regla propia (grupo *WinTaller*) y quitar el bloqueo. Si hay otro cortafuegos que filtra por su cuenta (TinyWall), lo detecta y lo indica.
- **Protección › Privacidad:** busca la telemetría de Windows (servicios, tareas programadas y ajustes) y de los programas instalados (Office, Edge, Firefox, Visual Studio, SDK de .NET, PowerShell 7, NVIDIA, Intel, HP, Dell), además de servicios y tareas de otros programas cuyo nombre indica telemetría. Cada elemento se desactiva y se vuelve a activar desde la pestaña.
- **Rendimiento › Windows más ágil:** «Finalizar tarea» en la barra de tareas, menú contextual clásico, extensiones de archivo, Explorador en «Este equipo», historial del portapapeles, rutas largas, cierre de programas colgados al apagar y mensajes detallados de arranque. Botón **Deshacer** para volver al valor de Windows.

**Seguridad**
- Las herramientas nuevas llaman a `sc.exe` y `netstat.exe` por su ruta completa.
- El tipo de inicio original de los servicios desactivados se guarda en la carpeta protegida (`C:\ProgramData\WinTaller\privacidad.json`).
- Los servicios críticos tampoco se pueden desactivar desde Privacidad.

## v2.0.0

Primera versión pública. El programa pasa a llamarse **WinTaller** (antes «Optimizar Windows») y estrena icono.

**Nueva organización:** 4 pestañas principales con subpestañas: Sistema (Servicios, Inicio, Drivers), Optimización (Limpieza y mantenimiento, Rendimiento), Programas (Instalar, Desinstalar) y Protección (Seguridad, Copias).

**Novedades**
- **Inicio:** programas que arrancan con Windows, con su firma digital. Se pueden deshabilitar y volver a habilitar (igual que en el Administrador de tareas), abrir su ubicación o analizarlos con Microsoft Defender.
- **Seguridad:** revisión del equipo (antivirus, firewall, UAC, SMBv1, BitLocker, arranque seguro, actualizaciones, cuentas e inicio) y análisis con Microsoft Defender: rápido, completo, de una carpeta o USB y sin conexión. Lista de amenazas detectadas.
- **Rendimiento** (antes «Equipo»): muestra el estado actual de cada ajuste antes de aplicarlo, marca solo los recomendados que faltan y permite un único plan de energía. Guarda una copia de los ajustes antes de aplicar.
- **Diagnóstico:** salud de discos (SMART), pantallazos azules y apagados inesperados, test de memoria e informe HTML del equipo.

**Seguridad**
- Las limpiezas ya no siguen enlaces de carpeta (junctions).
- Los scripts internos, descargas y copias de ajustes se guardan en una carpeta protegida (`C:\ProgramData\WinTaller`).
- El instalador de TinyWall solo se ejecuta si su firma digital es válida.
- Los desinstaladores registrados solo para el usuario piden confirmación antes de ejecutarse como administrador.
- No se detiene un servicio si algún servicio crítico depende de él.
- winget se ejecuta desde su ruta fija, no desde el PATH.

**Correcciones**
- «Revertir cambios» ya no activa tareas programadas que Windows trae deshabilitadas.
- Búsqueda de drivers por identificador: se evita el aviso «ya no está disponible».
- El límite de un punto de restauración cada 24 h vuelve a su valor después de crear el punto.
- Copias de carpetas más rápidas con muchos archivos.
- Una sola ventana del programa abierta a la vez.
