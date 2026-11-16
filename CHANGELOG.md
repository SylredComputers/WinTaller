# Historial de cambios

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
