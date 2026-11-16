# WinTaller

Herramienta gráfica para Windows 10/11 que permite:

- Ver todos los servicios del sistema y **cuáles están en ejecución** (resaltados en rojo).
- Saber **qué se puede quitar**: columna de consejo y ficha explicativa por servicio.
- **Marcar servicios con casillas** y finalizarlos.
- **Detener y deshabilitar** servicios de forma permanente.
- **Reactivar** servicios deshabilitados (tipo de inicio Manual).
- Aplicar **tareas de optimización y limpieza** con un solo clic.
- **Instalar programas habituales** con winget, al estilo de Ninite (7-Zip, VLC, Chrome, LibreOffice, Discord…).
- **Ajustar el rendimiento según el equipo**: detecta si es **sobremesa o portátil** (y si el disco es SSD o HDD), muestra cómo está cada ajuste y propone solo los que faltan. Incluye **diagnóstico**: salud de discos, pantallazos azules, test de memoria e **informe del equipo en HTML** para el cliente.
- **Buscar e instalar los drivers de los componentes** del equipo con Windows Update, guardar una copia de los actuales o instalar un archivo `.inf` descargado a mano.
- **Hacer copias de seguridad**: copiar carpetas concretas a otra unidad o crear una **imagen completa del sistema** para restaurar Windows si algo falla.
- **Revisar la seguridad y analizar el equipo con Microsoft Defender**: estado del antivirus, análisis rápido, completo, de una carpeta o USB y sin conexión, y lista de amenazas.
- **Ver y deshabilitar los programas que arrancan con Windows**, con su firma digital.
- **Escanear los puertos abiertos** del equipo: qué programa los usa, si el cortafuegos deja entrar conexiones y cuáles conviene revisar o bloquear.
- **Buscar y desactivar la telemetría** de Windows y de los programas instalados (y volver a activarla).
- **Activar opciones útiles que Windows trae desactivadas**, como *Finalizar tarea* en la barra de tareas.
- Guardar un **registro de actividad** de todo lo que se hace.

No requiere instalación ni dependencias externas: usa PowerShell 5.1 y WinForms, incluidos en Windows. La pestaña **Programas** utiliza **winget**, que ya viene en Windows 10/11 (si falta, la propia herramienta te lleva a la Store para instalarlo). Las pestañas **Drivers** y **Copias** usan herramientas del propio Windows: **Windows Update**, **robocopy** y **wbadmin**.

---

## Organización de la ventana

Desde la versión 2.0 hay **4 pestañas principales**, cada una con sus subpestañas:

| Pestaña | Subpestañas |
|---|---|
| **Sistema** | Servicios · Inicio · Drivers |
| **Optimización** | Limpieza y mantenimiento · Rendimiento |
| **Programas** | Instalar · Desinstalar |
| **Protección** | Seguridad · Puertos · Privacidad · Copias |

---

## Cómo se ejecuta

1. Descarga el ZIP de la última versión desde [Releases](https://github.com/SylredComputers/WinTaller/releases/latest), descomprímelo y abre la carpeta.
2. Haz doble clic en **`Iniciar.bat`**.
3. Acepta el aviso de **Control de cuentas de usuario (UAC)**.

El lanzador pide permisos de administrador y abre la interfaz. La ventana de consola se queda abierta detrás del programa a propósito: si algo falla, ahí verás el mensaje de error. No la cierres hasta que aparezca la ventana gráfica (puede tardar unos segundos mientras carga los servicios).

Si algo va mal, ejecuta **`Diagnostico.bat`**: la consola se quedará abierta al cerrarse la ventana para que puedas copiar el error. También se genera el archivo **`diagnostico.log`** en esta misma carpeta con todos los pasos y errores.

> **Importante:** no abras `WinTaller.ps1` con doble clic ni con «Ejecutar con PowerShell». En muchos equipos la política de scripts está restringida y la ventana se cerraría al instante sin mostrar nada. Usa siempre `Iniciar.bat` (o `Diagnostico.bat`).

También puedes ejecutarlo manualmente desde una consola de PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -STA -File .\WinTaller.ps1
```

Si Windows bloquea el archivo por haber venido de otro equipo:

```powershell
Unblock-File .\WinTaller.ps1
Unblock-File .\Iniciar.bat
```

### Acceso directo en el Escritorio

Para abrirlo con su icono desde el Escritorio, ejecuta esto en **PowerShell** dentro de la carpeta del programa:

```powershell
$ws = New-Object -ComObject WScript.Shell
$acceso = $ws.CreateShortcut("$([Environment]::GetFolderPath('Desktop'))\WinTaller.lnk")
$acceso.TargetPath = "$PWD\Iniciar.bat"
$acceso.WorkingDirectory = "$PWD"
$acceso.IconLocation = "$PWD\WinTaller.ico"
$acceso.Save()
```

---

## Sistema › Servicios

La tabla muestra, por cada servicio:

| Columna | Significado |
|---|---|
| Casilla | Marca el servicio para actuar sobre él. |
| Servicio | Nombre interno (el que usa Windows). |
| Nombre visible | Nombre descriptivo. |
| Estado | En ejecución o detenido. |
| Tipo de inicio | Automático, Manual o Deshabilitado. |
| PID | Identificador del proceso asociado. |
| Riesgo | `Bajo`, `Medio` o `Critico`. |
| Consejo | `Quitar` (verde), `Opcional` (naranja) o `No tocar` (rojo). |
| Descripción | Texto explicativo del servicio. |

- Los servicios **en ejecución se muestran en rojo**.
- Los servicios **críticos aparecen en negrita** y no se pueden detener ni deshabilitar desde la herramienta.
- Por defecto solo se muestran los servicios en ejecución. Desmarca **«Solo en ejecución»** para ver todos.
- Usa el buscador para filtrar por nombre o descripción.
- **Clic derecho** sobre la tabla: marcar todos, desmarcar todos o invertir la selección.

### ¿Cómo sé qué servicio puedo quitar?

Tres formas, todas equivalentes:

1. **Columna «Consejo»**: en verde `Quitar` (se puede deshabilitar sin perder nada importante), en naranja `Opcional` (solo si no usas esa función) y en rojo `No tocar`.
2. **Botón «Qué pasa si lo quito?»** (o **doble clic** sobre el servicio, o **F1**, o clic derecho → *Qué pasa si lo quito?*): abre una ficha con:
   - qué es el servicio y para qué sirve;
   - qué ocurre exactamente si lo **detienes** y si lo **deshabilitas**;
   - si es seguro quitarlo;
   - con qué otros servicios está relacionado;
   - un botón **«Marcar este servicio»** para seleccionarlo sin cerrar la ficha.
3. **Casilla «Solo los que se pueden quitar»**: filtra la tabla y deja únicamente los servicios recomendados para deshabilitar.

La ficha es orientativa: si después de quitar un servicio algo deja de funcionar, vuelve a marcarlo y pulsa **«Reactivar»**.

Botones:

| Botón | Qué hace |
|---|---|
| **Finalizar** | Detiene los servicios marcados (y sus dependencias). Volverán a arrancar al reiniciar si su inicio es Automático. |
| **Deshabilitar permanente** | Detiene los servicios marcados y cambia su inicio a Deshabilitado. **No volverán a arrancar al reiniciar.** |
| **Reactivar** | Vuelve a poner los servicios marcados en inicio Manual. |
| **Actualizar** | Recarga la lista de servicios. |

### Antes de detener servicios

- Pulsa primero **Actualizar** para ver el estado real.
- Revisa la columna **Riesgo**. Los servicios `Critico` están protegidos y se ignoran automáticamente.
- Si no estás seguro, usa **Finalizar** (temporal) antes que **Deshabilitar permanente**.
- Algunos servicios se reinician solos por sus acciones de recuperación. En ese caso, usa la opción permanente.

### Cómo revertir un servicio deshabilitado

1. En la herramienta, desmarca «Solo en ejecución», busca el servicio, marca su casilla y pulsa **Reactivar (Manual)**.
2. O abre `services.msc`, busca el servicio, doble clic y cambia **Tipo de inicio** a Manual o Automático.

---

## Sistema › Inicio (programas que arrancan con Windows)

Lista los programas que se ejecutan al iniciar sesión: los de las claves **Run** del registro (de tu usuario, de todos los usuarios y de 32 bits) y los de las **carpetas Inicio**.

| Columna | Qué indica |
|---|---|
| **Programa** | Nombre de la entrada. |
| **Estado** | *Habilitado* (arranca con Windows) o *Deshabilitado*. |
| **Firma digital** | Quién firma el ejecutable. En naranja y negrita los habilitados **sin firma**; en gris los deshabilitados o los que apuntan a un archivo que ya no existe. |
| **Origen** | Dónde está registrado. |

| Botón | Qué hace |
|---|---|
| **Deshabilitar** / **Habilitar** | Impide o vuelve a permitir que los seleccionados arranquen. Usa el mismo mecanismo que el Administrador de tareas (`StartupApproved`): **no borra nada** y se puede deshacer aquí o allí. Los de *todos los usuarios* necesitan administrador. |
| **Abrir ubicación** | Abre la carpeta del ejecutable en el Explorador. |
| **Analizar con Defender** | Analiza el ejecutable con Microsoft Defender (el progreso se ve en Protección › Seguridad). |
| **Administrador de tareas** | Lo abre en su pestaña de aplicaciones de arranque, que además muestra el impacto en el inicio. |
| **Actualizar** | Vuelve a leer la lista. |

El botón **Programas de inicio** de Optimización lleva directamente a esta subpestaña.

---

## Optimización › Limpieza y mantenimiento

Marca las tareas que quieras y pulsa **Ejecutar seleccionadas**. Cada tarea se explica al seleccionarla.

Tareas incluidas:

- **Crear punto de restauración** — red de seguridad antes de cambiar nada.
- **Limpieza:** archivos temporales, papelera, caché DNS, caché de Windows Update, Optimización de entrega, volcados de memoria, miniaturas e iconos, caché de navegadores y componentes de Windows (WinSxS).
- **Privacidad:** desactivar telemetría y quitar Copilot, Recall, widgets y sugerencias.
- **Servicios:** deshabilitar servicios innecesarios (Xbox, Fax, RemoteRegistry, MapsBroker…) y, opcionalmente, el índice de búsqueda (WSearch).
- **Mantenimiento:** optimizar el disco del sistema (TRIM o desfragmentar) y reparar archivos del sistema (DISM + SFC, 15–40 minutos).
- **Restablecer la red** (Winsock e IP), solo si hay fallos de conexión.

El plan de energía y los efectos visuales ya no están aquí: se ajustan en la pestaña **Rendimiento**, que muestra cómo están antes de cambiarlos.

Además:

- **Programas de inicio** muestra en el registro los programas que arrancan con Windows y abre el Administrador de tareas para deshabilitarlos.
- **Guardar registro** exporta todo el historial a un archivo `.txt`.
- Al finalizar se muestra el espacio libre ganado y el tiempo empleado.

### Recomendaciones

- Ejecuta primero **Crear punto de restauración**.
- Empieza por las tareas marcadas como recomendadas (ya vienen marcadas).
- SFC/DISM y la optimización de disco pueden tardar mucho: no cierres la ventana.
- Reinicia el equipo después de aplicar cambios importantes (telemetría, servicios, efectos visuales).

---

## Programas › Instalar (instalador tipo Ninite)

Sirve para dejar un equipo recién instalado listo en una sola pasada: marcas los programas y la herramienta los instala uno detrás de otro.

- La mayoría usa **winget**, el instalador oficial de línea de comandos de Windows. No descarga nada propio ni instala componentes adicionales.
- **TinyWall** no está en winget: se descarga su instalador `.msi` **de la web oficial** (`tinywall.pados.hu`) por HTTPS y se instala en silencio. Antes de instalarlo se comprueba que la **firma digital es válida**; si no lo es, no se ejecuta. Necesita administrador.
- El catálogo incluye **65 programas** agrupados por categoría: Esenciales, Navegadores, Oficina, Multimedia, Comunicación, Desarrollo, Utilidades, Juegos, Seguridad y Acceso remoto. Entre ellos están **Malwarebytes** y **TinyWall**.

Usa el **buscador** de la parte superior para filtrar por nombre, categoría o descripción (por ejemplo, escribe `malware`, `pdf` o `seguridad`). El contador del grupo indica cuántos programas se están mostrando. El filtro no pierde las casillas marcadas: al limpiarlo vuelven a aparecer tal como estaban.

| Botón | Qué hace |
|---|---|
| **Instalar seleccionados** | Instala en cola los programas marcados, de uno en uno. Antes muestra un aviso: *«Vas a realizar una instalación desde la página oficial del programa. ¿Quieres continuar?»* con **Aceptar** y **Cancelar**. |
| **Detener** | Cancela la instalación en curso y la cola pendiente. |
| **Abrir Store** | Abre la ficha de *Instalador de aplicaciones* (App Installer) por si winget no está disponible. |
| **Comprobar instalados** | Marca como «Instalado» los programas que ya están en el equipo y los desmarca. |
| **Marcar recomendados** | Marca solo los programas esenciales. |
| **Desmarcar** | Quita todas las marcas. |

Detalles:

- La columna **Estado** muestra `Instalando...`, `Instalado`, `Aviso` o `Cancelado`.
- Cada programa se instala de forma silenciosa (`--silent` en winget, `/qn` en los MSI) aceptando los acuerdos de licencia; se descarta la interacción manual.
- Si un programa falla, la cola continúa con el siguiente y el motivo se anota en el **registro de instalación** (se puede guardar en `.txt`).
- Necesita conexión a Internet. Para los programas de winget hace falta **winget** disponible; en Windows 10/11 recientes viene instalado. Si la etiqueta superior dice *winget no disponible*, pulsa **Abrir Store** e instala **Instalador de aplicaciones**.
- **TinyWall** requiere abrir la herramienta como administrador (`Iniciar.bat`). Tras instalarlo bloquea casi toda la conexión: usa su menú para permitir los programas que necesites.
- La instalación se hace **por usuario** o **por equipo** según lo que defina cada paquete. No requiere reiniciar, aunque algunos programas piden cerrar sesión la primera vez.

---

## Optimización › Rendimiento (ajustes según el equipo y diagnóstico)

Al abrirla detecta el equipo (sobremesa o portátil, tipo de disco, RAM, CPU, gráfica y batería) y muestra los ajustes que tienen sentido para él, agrupados en **Energía**, **Rendimiento y aspecto**, **Windows más ágil**, **Disco** y **Juegos**.

Cada ajuste tiene tres columnas:

| Columna | Qué indica |
|---|---|
| **Ajuste** | Qué cambia. En negrita, los recomendados que todavía no están aplicados. |
| **Estado actual** | Cómo está ahora en este equipo, por ejemplo *No (ahora: Equilibrado)* o *Activada (ocupa 12,7 GB)*. Si ya está aplicado sale en verde con ✓. |
| **Recomendado** | Si conviene para este tipo de equipo. |

- Al abrir la pestaña quedan **marcados solo los recomendados que faltan por aplicar**. Si todo está bien, no hay nada marcado.
- **Solo un plan de energía**: al marcar uno se desmarcan los otros.
- **Aplicar marcados** muestra qué va a cambiar (con el estado actual), guarda antes una **copia de los ajustes** (se deshace con *Revertir cambios* en Optimización) y, al terminar, actualiza la columna *Estado actual*.
- Si el plan *Alto rendimiento* está oculto (pasa en muchos portátiles modernos), la herramienta reutiliza una copia existente o la crea.
- Algunos ajustes necesitan administrador (hibernación, inicio rápido, TRIM, Game DVR) y otros cerrar sesión o reiniciar para notarse.

| Ajuste | Sobremesa | Portátil |
|---|---|---|
| Plan **Alto rendimiento** | Recomendado | No (consume batería) |
| Plan **Equilibrado** | Disponible | Recomendado |
| Plan **Economizador** | — | Disponible |
| **Desactivar hibernación** (libera 4–16 GB) | Recomendado | No (pierdes hibernar) |
| **Desactivar Inicio rápido** | Disponible | Disponible |
| **Efectos visuales: máximo rendimiento** | Recomendado | Recomendado |
| **Quitar transparencias y animaciones** | Recomendado | Recomendado |
| **Desactivar apps en segundo plano** | Disponible | Disponible |
| **Activar TRIM** (solo SSD) | Recomendado | Recomendado |
| **Activar modo juego** | Recomendado | Recomendado |
| **Desactivar Game DVR** | Recomendado | Recomendado |

### Windows más ágil (desde la 2.1.0)

Opciones útiles que Windows trae desactivadas. A diferencia del resto, estos ajustes tienen botón **Deshacer**: selecciona uno ya aplicado y vuelve al valor de fábrica de Windows.

| Ajuste | Qué hace | Recomendado |
|---|---|---|
| **«Finalizar tarea» en la barra de tareas** | Botón derecho sobre un programa de la barra › *Finalizar tarea*. Cierra un programa colgado sin abrir el Administrador de tareas. Solo Windows 11 23H2 o posterior. | Sí |
| **Menú contextual clásico** | El botón derecho muestra el menú completo, sin «Mostrar más opciones». Solo Windows 11. | Opcional |
| **Mostrar las extensiones de los archivos** | Deja a la vista los `factura.pdf.exe`. | Sí |
| **Abrir el Explorador en «Este equipo»** | Evita la carga de Inicio / Acceso rápido. | Opcional |
| **Historial del portapapeles (Win+V)** | Pegar cualquiera de las últimas cosas copiadas. Ojo: también guarda lo copiado de un gestor de contraseñas. | Opcional |
| **Rutas largas (más de 260 caracteres)** | Evita errores al copiar o descomprimir carpetas muy anidadas. Necesita administrador. | Sí |
| **Cerrar antes los programas colgados al apagar** | Windows no se queda esperando en «Esta aplicación impide el apagado». Un programa con cambios sin guardar se cierra sin preguntar. | Opcional |
| **Mensajes detallados al arrancar y al apagar** | Muestra qué hace Windows en cada paso; útil para ver qué retrasa el arranque. Necesita administrador. | Opcional |

### Diagnóstico (no cambia nada)

| Botón | Qué hace |
|---|---|
| **Informe del equipo** | Crea un informe HTML con hardware, número de serie, BIOS, Windows, discos (salud, temperatura, desgaste), espacio libre, batería, componentes con problemas, pantallazos azules y el estado de seguridad. Se guarda en `Documentos\WinTaller\Informes` y se abre solo. Sirve para entregarlo al cliente o imprimirlo en PDF desde el navegador. |
| **Salud de los discos** | Salud, temperatura, desgaste del SSD, horas de uso y errores de lectura/escritura (SMART), y espacio libre de cada unidad. Temperatura y desgaste necesitan administrador. |
| **Pantallazos y apagados** | Pantallazos azules (con su código) y apagados inesperados de los últimos 60 días, y los minivolcados guardados. |
| **Test de memoria RAM** | Abre el Diagnóstico de memoria de Windows para hacer la prueba al reiniciar. |
| **Informe de batería** | Solo portátiles: informe de Windows con la capacidad real, los ciclos y la autonomía, en el Escritorio. |

## Sistema › Drivers (componentes y controladores)

Al abrirla, la herramienta inventaría los componentes del equipo y marca en **rojo y negrita** los que tienen problemas (`Error`, típicamente el código 28: «no se han instalado los controladores de este dispositivo»).

La lista se puede ver de tres formas con el desplegable superior:

| Vista | Qué muestra |
|---|---|
| **Dispositivos con problemas** | Solo los componentes que fallan o no tienen driver. Es la vista inicial. |
| **Todos los dispositivos** | Todos los componentes presentes (red, pantalla, sonido, USB, disco…). |
| **Drivers disponibles (Windows Update)** | Los controladores que Microsoft ofrece para este equipo. |

En la vista **Drivers disponibles** aparece la casilla **«Seleccionar todos los drivers disponibles»**, encima de la lista: marca o desmarca de golpe todos los drivers que ofrece Windows Update (los ya instalados se quedan fuera). Si desmarcas uno a mano, la casilla se desmarca sola para que sepas que ya no están todos.

Botones:

| Botón | Qué hace |
|---|---|
| **Buscar en Windows Update** | Consulta Windows Update en segundo plano y muestra los drivers disponibles. Los que corresponden a componentes con problemas aparecen **en negrita y ya marcados**. |
| **Instalar seleccionados** | Descarga e instala los drivers marcados, de uno en uno. Pide confirmación antes de empezar. |
| **Detener** | Cancela la búsqueda o la instalación en curso. |
| **Actualizar lista** | Vuelve a inventariar los componentes (útil tras conectar un dispositivo). |
| **Copia de drivers** | Exporta todos los drivers instalados a `Documentos\WinTaller\Drivers-<fecha>` con `pnputil`. Sirve para recuperarlos después. |
| **Instalar .inf...** | Instala un driver ya descargado a mano seleccionando su archivo `.inf`. |
| **Soporte** | Abre la página de drivers del fabricante (Lenovo, HP, Dell, ASUS, Acer, MSI…) y copia el modelo del equipo al portapapeles. |

Detalles importantes:

- La **búsqueda** y la **instalación** se ejecutan en un proceso aparte: la ventana sigue respondiendo y puedes cancelarlas con **Detener**.
- Los drivers se descargan **de los servidores de Microsoft (Windows Update)**, no de webs de terceros.
- **Instalar, exportar y aplicar un `.inf` necesitan permisos de administrador.** Abre el programa con `Iniciar.bat`; si no, la herramienta avisa y no ejecuta la acción. La búsqueda sí funciona sin elevación.
- La primera búsqueda puede tardar **entre 15 y 60 segundos** según la conexión. Hace falta Internet y el servicio Windows Update activo.
- Algunos drivers piden **reiniciar** para terminar de aplicarse; la herramienta lo avisa al finalizar.
- Si un componente sigue con problemas después de instalar, prueba **Soporte** para descargar el driver específico del fabricante o **Instalar .inf...** con un paquete descargado.
- Tras instalar o actualizar drivers conviene **reiniciar** y volver a abrir la pestaña para comprobar que el componente ya aparece como `Correcto`.
- La columna **Estado** de la vista de drivers muestra `Descargando...`, `Instalando...`, `Instalado`, `Error`, `No disponible` o `Cancelado`.

### ¿Y si mi equipo es HP, ASUS, Dell, Lenovo…?

La búsqueda funciona **igual en cualquier marca**. Windows Update es un catálogo común de Microsoft: Lenovo, HP, Dell, ASUS, Acer, MSI y el resto publican ahí los controladores de sus equipos, y Windows sabe qué modelo tienes y te ofrece solo los que encajan. No hay que configurar nada según el fabricante.

Lo que **no** suele estar en Windows Update son los programas propios de cada marca (Lenovo Vantage, MyASUS, HP Support Assistant, Dell SupportAssist…) ni las actualizaciones de **BIOS/UEFI**. Para eso está el botón **Soporte**:

- Detecta el fabricante y abre su página oficial de drivers (Lenovo, HP, Dell/Alienware, ASUS, Acer/Packard Bell, MSI, Samsung, Toshiba, Microsoft/Surface, Huawei, Xiaomi, Medion, VAIO, LG, Razer, Chuwi…).
- Copia el **modelo exacto** del equipo al portapapeles para que lo pegues en el buscador de esa web.
- Si descargas un paquete `.zip` o `.exe`, puedes instalarlo con **Instalar .inf...** (el `.inf` suele estar dentro de la carpeta descomprimida) o ejecutando el instalador del fabricante.

Recomendación: usa primero **Buscar en Windows Update** (es lo más seguro y no requiere saber el modelo) y recurre a la web del fabricante solo si un componente sigue con problemas, si necesitas el lector de huellas o teclas de función especiales, o si el fabricante recomienda una BIOS nueva.

---

## Protección › Copias (carpetas o imagen del sistema)

Sirve para poner a salvo tus datos antes de tocar nada, o para tener una imagen de Windows de la que restaurar. Usa solo herramientas incluidas en Windows: **robocopy** para carpetas y **wbadmin** para la imagen completa.

### Copia de carpetas y archivos

1. Elige **«Carpetas y archivos»**.
2. Marca las carpetas de la lista. Vienen preparadas **Documentos**, **Escritorio**, **Imágenes**, **Música**, **Vídeos**, **Descargas** y **Favoritos**; las dos primeras ya están marcadas.
3. Pulsa **«Añadir carpeta...»** si quieres incluir cualquier otra (por ejemplo, una carpeta de proyectos).
4. Escribe o elige el **destino** con **«Examinar...»**. Lo normal es un disco externo o una segunda unidad.
5. Pulsa **«Iniciar copia»**.

Qué hace exactamente:

- Copia el **contenido** de cada carpeta dentro de una subcarpeta con su nombre en el destino (por ejemplo, `E:\Copia-WinTaller\Documentos\...`).
- **No borra nada en el origen.** Los archivos que ya son iguales se saltan, así que puedes repetir la copia para mantenerla al día.
- Conserva fechas de modificación y creación, y **omite los puntos de unión** (`/XJ`) para no entrar en bucles.
- Reintenta 2 veces los archivos bloqueados y sigue adelante; al final indica cuántos archivos se han procesado y si hubo errores.
- Opcionalmente **comprueba la copia** al terminar (cuenta archivos y tamaño en el destino) y deja un **registro detallado** `_registro-copia.txt` en el destino.

### Imagen completa del sistema

1. Elige **«Imagen completa del sistema»**.
2. Selecciona la unidad de destino con **«Examinar...»**. Debe ser **otra unidad distinta de `C:`**, en **NTFS** y con espacio libre suficiente (la herramienta calcula lo necesario y avisa si no llega).
3. Pulsa **«Iniciar copia»** y confirma.

- Crea una imagen de los **volúmenes críticos** (Windows, arranque y recuperación) con `wbadmin start backup ... -allCritical`.
- Se guarda en la carpeta **`WindowsImageBackup`** de esa unidad.
- **Necesita permisos de administrador**: abre el programa con `Iniciar.bat`.
- Puede tardar **entre 10 y 60 minutos** y ocupar varios GB. No apagues el equipo mientras se crea.
- Para restaurarla se arranca desde un medio de recuperación de Windows y se elige *Reparar el equipo → Solución de problemas → Recuperación de imagen del sistema*. La imagen no sustituye a la copia de tus documentos en otro disco: si el disco se estropea, la imagen del mismo disco tampoco sirve.

### Botones y opciones

| Botón / opción | Qué hace |
|---|---|
| **Iniciar copia** | Lanza la copia o la imagen en segundo plano (la ventana sigue respondiendo). |
| **Detener** | Cancela el proceso. Lo ya copiado se conserva. |
| **Abrir destino** | Abre en el Explorador la carpeta donde se está guardando la copia. |
| **Marcar habituales / Desmarcar** | Marca o desmarca todas las carpetas de la lista. |
| **Añadir carpeta... / Quitar** | Añade una carpeta cualquiera o quita las marcadas de la lista. |
| **Abrir la carpeta al terminar** | Abre el destino automáticamente al finalizar con éxito. |
| **Comprobar la copia al terminar** | Verifica que el número de archivos y el tamaño del destino coinciden con el origen. |
| **Guardar un registro detallado en el destino** | Crea `_registro-copia.txt` con el detalle de robocopy (incluidos los archivos omitidos). |

Avisos que muestra la herramienta:

- Si el destino está en el **mismo disco físico** que el origen, aparece un aviso: la copia te protege de borrados accidentales, pero no de que el disco falle.
- La barra de progreso avanza con los archivos procesados (incluidos los que se saltan por ser iguales), así que no se queda parada en copias repetidas.
- Si cierras la ventana con una copia en curso, pide confirmación y la cancela; lo copiado se mantiene.

---

## Protección › Seguridad (antivirus y revisión del equipo)

Al abrirla revisa el estado de la seguridad del equipo. **La revisión no cambia nada**: solo informa y explica qué hacer. Cada comprobación sale en verde (correcto), naranja (aviso), rojo (problema grave) o gris (información). Al seleccionarla, el panel **Detalle** explica qué significa y cómo corregirla.

| Grupo | Qué comprueba |
|---|---|
| **Antivirus** | Antivirus activo (Defender u otro), modo de Defender, protección en tiempo real, antigüedad de las firmas, último análisis rápido y completo, protección contra alteraciones y bloqueo de aplicaciones no deseadas. |
| **Sistema** | Firewall, Control de cuentas (UAC), SMBv1, BitLocker, arranque seguro, última actualización de Windows, reinicio pendiente y escritorio remoto. |
| **Cuentas** | Cuenta Invitado, Administrador integrado y cuentas que pueden no tener contraseña. |
| **Inicio** | Programas que arrancan con Windows y si tienen firma digital válida. |

Botones:

| Botón | Qué hace |
|---|---|
| **Análisis rápido** | Analiza memoria, inicio y carpetas del sistema. Tarda unos minutos. |
| **Análisis completo** | Analiza todos los archivos de todos los discos. Puede tardar horas. |
| **Analizar carpeta o USB...** | Analiza solo la carpeta o unidad que elijas. |
| **Detener** | Cancela el análisis o la actualización en curso. |
| **Análisis sin conexión** | Reinicia el equipo y analiza antes de que arranque Windows (unos 15 minutos). Es el más eficaz contra rootkits. Pide confirmación. |
| **Actualizar firmas** | Descarga las últimas firmas de Defender. |
| **Revisar de nuevo** | Repite la revisión y recarga las amenazas. |
| **Eliminar amenazas activas** | Aplica la acción recomendada de Defender (cuarentena o eliminación) a las amenazas que siguen activas. |
| **Abrir Seguridad de Windows** | Abre la protección antivirus de Windows, donde está el historial y se puede restaurar un archivo de la cuarentena. |

Detalles:

- Usa **Microsoft Defender** (`MpCmdRun.exe`), incluido en Windows. No descarga motores de terceros.
- Los análisis se ejecutan en segundo plano: la ventana sigue respondiendo y se pueden detener. La barra solo indica que sigue trabajando; Defender no informa del porcentaje.
- **Análisis, actualización de firmas y eliminar amenazas necesitan administrador** (`Iniciar.bat`). La revisión funciona sin elevación, aunque BitLocker y el arranque seguro solo se comprueban como administrador.
- Si el equipo tiene **otro antivirus** (ESET, Avast, Kaspersky…), Defender queda en **modo pasivo**: se puede analizar bajo demanda, pero la protección en tiempo real y la eliminación automática las hace el otro antivirus. La pestaña lo indica.
- Un programa de inicio **sin firma** no es necesariamente malware, pero conviene revisarlo y analizar su carpeta.

---

## Protección › Puertos (puertos abiertos en el equipo)

Al abrirla escanea los puertos **a la escucha** en este equipo. El escaneo solo lee: no envía tráfico ni cambia nada.

Para cada puerto muestra el **servicio** habitual (SMB, Escritorio remoto, base de datos…), el **programa** que lo abre (con sus servicios de Windows y su firma digital) y el **alcance**:

| Grupo | Significado |
|---|---|
| **Abiertos a la red** | Otros equipos pueden conectarse: hay una regla de entrada en el cortafuegos que lo permite, o el cortafuegos no está filtrando. |
| **A la escucha, pero el cortafuegos no deja entrar** | El programa escucha, pero no hay regla de entrada (o hay un bloqueo). |
| **Solo este equipo** | Escucha en `127.0.0.1` / `::1`. Es comunicación interna entre programas. |

La columna **Valoración** combina el riesgo del puerto con su alcance: *Revisar ya* (rojo) para puertos delicados abiertos a la red —Escritorio remoto, FTP, Telnet, VNC, SMB en red pública…—, *Revisar* (naranja), *Informativo* y *Correcto*. Un programa **sin firma digital** abierto a la red se marca siempre para revisar.

- **Bloquear puerto** crea una regla de entrada en el cortafuegos de Windows (grupo *WinTaller*) que impide a otros equipos conectarse a ese puerto. **Quitar bloqueo** la elimina. Necesita administrador.
- **Incluir UDP** añade los puertos UDP (suelen ser muchos y de uso interno). **Solo abiertos a la red** oculta el resto.
- **Cortafuegos** abre el cortafuegos de Windows con seguridad avanzada.
- **Otro cortafuegos instalado (TinyWall y similares):** estos programas dejan en el cortafuegos de Windows una regla general que lo permite todo y filtran por su cuenta. WinTaller lo detecta y agrupa los puertos de red como *Lo decide TinyWall*: muestra qué programa escucha, pero no puede leer las excepciones de ese cortafuegos. *Bloquear puerto* sigue funcionando.

- **Si usas otro cortafuegos** (TinyWall y similares), este deja una regla general «permitir todo» en el de Windows y filtra por su cuenta. WinTaller lo detecta, agrupa esos puertos como *lo filtra otro cortafuegos* y no los valora como abiertos: hay que comprobarlos en las excepciones de ese cortafuegos. *Bloquear puerto* sigue funcionando.

> La valoración del cortafuegos es orientativa: se calcula con las reglas de entrada del cortafuegos de Windows para el perfil de red activo. No tiene en cuenta el router ni otros cortafuegos instalados, y no sustituye a un escaneo desde fuera (por ejemplo con Nmap desde otro equipo).

---

## Protección › Privacidad (telemetría de Windows y de los programas)

**Escanear telemetría** busca en este equipo lo que envía datos de uso al fabricante y lo agrupa en:

| Grupo | Qué incluye |
|---|---|
| **Windows: servicios y tareas** | DiagTrack, dmwappushservice, tareas del Programa de mejora (CEIP), de compatibilidad (Appraiser), de comentarios y del diagnóstico de disco, e informe de errores. |
| **Windows: ajustes de privacidad** | Nivel de datos de diagnóstico (directiva), Id. de publicidad, experiencias personalizadas, encuestas, historial de actividad, personalización de escritura y seguimiento de aplicaciones. |
| **Programas instalados** | Solo aparecen los que existen en el equipo: Microsoft Office, Edge, Firefox, Visual Studio, SDK de .NET, PowerShell 7, NVIDIA, Intel, HP y Dell. |
| **Otros detectados (revisar antes)** | Servicios y tareas de cualquier otro programa cuyo nombre indica telemetría (*telemetry*, *CEIP*, *analytics*, *feedback*, *usage report*…). Salen sin marcar: comprueba qué son antes de desactivarlos. |

- Los **recomendados que siguen activos** quedan marcados. **Desactivar marcados** guarda antes una copia de los ajustes y aplica los cambios; la columna *Estado* muestra cómo queda.
- **Volver a activar marcados** lo deshace: habilita servicios y tareas (con su tipo de inicio original, que se anota en `C:\ProgramData\WinTaller\privacidad.json`) y devuelve los ajustes al valor de Windows.
- La ficha de cada elemento detalla **qué se cambia exactamente** (servicio, tarea, valor del registro o variable de entorno) y sus efectos secundarios.
- Las directivas de Edge y Firefox hacen que el navegador muestre «administrado por tu organización»; por eso no vienen marcadas.
- En Windows Home y Pro el nivel mínimo de diagnóstico son los *datos obligatorios*: el envío cero solo existe en Enterprise y Education.
- **Chrome** y **Visual Studio Code** no admiten este ajuste desde fuera en equipos domésticos: se desactiva en sus propias opciones.
- Windows Update puede volver a activar algunas tareas tras una actualización grande; basta con escanear de nuevo.

---

## Seguridad y limitaciones

- El programa **no puede detener ni deshabilitar servicios críticos** (RPC, DCOM, seguridad, red, audio, etc.). Se listan en `$script:CriticalServices` dentro del script.
- Detener servicios del sistema puede afectar a programas concretos. La herramienta no conoce qué usa cada equipo.
- Las tareas de optimización modifican servicios, el registro y la configuración de energía. Crea un punto de restauración antes.
- La pestaña **Rendimiento** cambia el registro (efectos visuales, Game DVR, inicio rápido) y la configuración de energía. Antes de aplicar guarda una copia de los ajustes que se puede revertir desde Optimización (salvo la hibernación, que se vuelve a activar con `powercfg /hibernate on`). Algunos ajustes solo se aplican al cerrar sesión o reiniciar.
- La pestaña **Programas** descarga software real de Internet: los paquetes de winget y, en el caso de TinyWall, su instalador `.msi` desde la web oficial. Antes de empezar muestra un aviso con los programas seleccionados para que confirmes. Comprueba los nombres y revisa la columna **Estado** para ver cuáles fallaron.
- La pestaña **Drivers** descarga e instala controladores reales desde Windows Update. Instalar un driver incorrecto puede provocar que un componente deje de funcionar; antes de cambiar algo, usa **Copia de drivers** para guardar los actuales. Algunos drivers requieren reiniciar y no se pueden desinstalar desde la herramienta: se haría desde el Administrador de dispositivos.
- La pestaña **Copias** escribe en el disco de destino. La copia de carpetas **no borra nada en el origen**, pero sí puede sobrescribir archivos con el mismo nombre en el destino; elige una carpeta vacía o específica. La imagen del sistema **necesita administrador**, otra unidad NTFS y espacio libre; se crea con `wbadmin` y no se puede cancelar de forma limpia a mitad, así que no la interrumpas. Una copia en el mismo disco físico que el original no protege frente a un fallo del disco.
- La pestaña **Puertos** valora el cortafuegos de forma orientativa (reglas de entrada de Windows para el perfil de red activo); no ve el router ni otros cortafuegos. **Bloquear puerto** crea reglas en el grupo *WinTaller* del cortafuegos de Windows.
- La pestaña **Privacidad** cambia servicios, tareas programadas, directivas del registro y variables de entorno. Todo se puede volver a activar desde la propia pestaña. Los elementos del grupo *Otros detectados* se identifican solo por su nombre: revísalos antes de desactivarlos.
- Los ajustes de usuario (`HKCU`) se aplican a la cuenta con la que se elevó el programa: si un usuario estándar eleva con la cuenta de otro administrador, se aplican al perfil de ese administrador.
- Se necesita PowerShell 5.1 (Windows 10/11). En Windows 7 faltan algunos comandos; las tareas afectadas se omiten con un aviso.
- Es un script sin firma digital: algunos antivirus pueden marcarlo como sospechoso. Es código abierto y legible en `WinTaller.ps1`.
- Ejecutar desde una memoria USB funciona, siempre que la ruta sea accesible.

---

### Protecciones añadidas en la versión 1.7.0

- **Limpiezas sin seguir enlaces:** al borrar temporales, volcados y cachés solo se quita el enlace (junction o symlink), nunca el contenido de la carpeta a la que apunta.
- **Carpeta de trabajo protegida:** con permisos de administrador, los scripts internos, las descargas y los registros temporales se guardan en `C:\ProgramData\WinTaller\tmp`, accesible solo para SYSTEM y Administradores.
- **Copias de ajustes (snapshots) protegidas:** ahora se guardan en `C:\ProgramData\WinTaller\snapshots`. Al revertir solo se importan archivos `.reg` de la lista permitida y con sus claves correspondientes. Solo se restauran los servicios y tareas que han cambiado, y se respeta el inicio «Automático (retrasado)».
- **Desinstaladores de HKCU:** los programas registrados solo para el usuario muestran el comando completo y piden confirmación antes de ejecutarse con permisos de administrador.
- **Servicios:** no se detiene un servicio si algún servicio crítico depende de él. Los servicios marcados «No tocar» piden una confirmación extra. `defragsvc` y `DsmSvc` ya no se consideran de riesgo bajo.
- **Punto de restauración:** el límite de un punto cada 24 horas se quita solo mientras se crea el punto y después vuelve a su valor.
- **winget** se ejecuta desde su ruta fija de instalación, no desde el PATH.
- **Una sola ventana abierta a la vez.**

## Estructura del proyecto

```
WinTaller\                 (la carpeta que descomprimes)
├─ WinTaller.ico           Icono para crear un acceso directo
├─ Iniciar.bat             Lanzador con elevación de permisos
├─ Diagnostico.bat         Lanzador que conserva la consola abierta
├─ WinTaller.ps1    Programa completo (interfaz + lógica)
├─ diagnostico.log         Se crea al ejecutar (pasos y errores)

C:\ProgramData\WinTaller\   (solo SYSTEM y Administradores)
├─ snapshots\              Copias de ajustes para «Revertir cambios»
└─ tmp\                    Archivos temporales de las operaciones elevadas
└─ README.md               Este documento
```

### Opciones internas de diagnóstico

```powershell
# Comprobar que el script carga y leer servicios
powershell -NoProfile -ExecutionPolicy Bypass -STA -File .\WinTaller.ps1 -SelfTest

# Abrir la interfaz, comprobar el diseño y cerrar (para pruebas)
powershell -NoProfile -ExecutionPolicy Bypass -STA -File .\WinTaller.ps1 -UiSmokeTest
```

---

## Si el programa se abre y se cierra

1. Ejecuta **`Diagnostico.bat`** y espera: la consola no se cerrará aunque falle la ventana.
2. Copia el texto de error que aparezca o revisa **`diagnostico.log`**.
3. Causas habituales:
   - **Política de ejecución de scripts bloqueada** por la empresa o por antivirus: el mensaje lo verás en la consola de `Diagnostico.bat`.
   - **Antivirus** que bloquea scripts de PowerShell: añade la carpeta a exclusiones o usa otro equipo.
   - **El archivo se copió desde otro PC** y Windows lo bloqueó: ejecuta `Unblock-File .\WinTaller.ps1` y `Unblock-File .\Iniciar.bat`.
   - **La ventana tarda en aparecer**: la primera carga de servicios puede tardar varios segundos. No cierres la consola.
4. Si el log está vacío, el script ni siquiera llegó a ejecutarse: casi siempre es la política de ejecución o el antivirus.
