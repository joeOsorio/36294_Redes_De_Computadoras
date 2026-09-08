Taller: Organizaciones y Estándares en Telecomunicaciones

Objetivo del taller

Que el estudiante identifique los fundamentos del modelo OSI a través de una
investigación crítica y ejercicios prácticos, con enfoque técnico y metodológico, aplicando
una estructura de reporte profesional y desarrollando habilidades de presentación oral.

Actividad central

Ejercicio tipo EGEL – Capa 1 (Física)

Una empresa presenta problemas intermitentes de conectividad en varios equipos conectados
por medio de cableado estructurado categoría 5e en un entorno industrial con maquinaria
pesada. El técnico de redes revisa el cableado y nota que los cables UTP están tendidos junto a
líneas eléctricas de alta potencia y transformadores. Algunos empleados reportan pérdida de
conexión durante picos de voltaje o cuando se activan máquinas grandes.

Ante esta situación, el técnico decide realizar una serie de pruebas con un certiﬁcador de
cableado y detecta un nivel de atenuación más alto de lo permitido y un incremento del NEXT
(crosstalk de extremo cercano), pero no se identiﬁcan errores de capa 2 o superior.

¿Cuál sería la causa más probable del problema y qué acción sería más adecuada desde el
punto de vista de la capa física?

Opciones de respuesta:

A) Cambiar el switch principal por uno de mayor capacidad que tenga soporte para QoS y PoE, y
aplicar prioridades de tráﬁco por VLAN.

B) Sustituir el cableado UTP actual por cable STP o FTP y alejarlo físicamente de fuentes de
interferencia electromagnética, como maquinaria y líneas de alta tensión.

C) Conﬁgurar nuevamente las direcciones IP de los equipos para evitar conﬂictos en la capa de
red y usar cable categoría 6 por ser más reciente.

D) Aplicar un protocolo de compresión y cifrado de datos en la capa de aplicación para reducir el
tráﬁco de red e interferencia con las máquinas industriales.

Justiﬁcar la respuesta

Ejercicio tipo EGEL – Capa 2 (Enlace de Datos)

Un técnico de redes está resolviendo un problema de conectividad entre dos computadoras
dentro de la misma red local. Ambas están conectadas al mismo switch y tienen direcciones IP
válidas, pero no pueden comunicarse entre sí. Al ejecutar arp -a, el técnico nota que una de las
computadoras no tiene registrada la dirección MAC de la otra. Tras analizar la situación,
descubre que el switch presenta fallas en una de sus tablas internas.

¿Qué función de la Capa 2 está relacionada directamente con este
problema?

Opciones:

A) Encaminamiento de paquetes entre redes diferentes utilizando direcciones IP.

B) Traducción de nombres de dominio a direcciones IP mediante DNS.

C) Mapeo de direcciones IP a direcciones físicas mediante tablas ARP y uso de direcciones MAC.

D) Fragmentación y reensamblado de paquetes para garantizar la entrega ordenada.

Justiﬁcar la respuesta

Ejercicio tipo EGEL – Capa 3 (Red)

Una empresa está segmentando su red interna para mejorar la seguridad y el rendimiento. El
administrador decide dividir la red 192.168.10.0/24 en subredes más pequeñas. Después de
implementar las nuevas subredes y conﬁgurar los enrutadores, algunas estaciones no logran
comunicarse con otras en subredes distintas, aunque sí tienen conexión con equipos dentro de
su misma subred. Al analizar con tracert, se observa que el tráﬁco no pasa más allá del router
local.

¿Cuál de los siguientes componentes o conﬁguraciones es

fundamental para que las estaciones se comuniquen entre diferentes
subredes?

Opciones:

A) Asignar correctamente los nombres de host mediante un servidor DNS interno.

B) Conﬁgurar una puerta de enlace predeterminada (gateway) en las estaciones de trabajo.

C) Establecer reglas de acceso en el cortafuegos para restringir puertos.

D) Sincronizar el tiempo en los switches mediante NTP para evitar errores de tiempo de red.

Justiﬁcar la respuesta

Ejercicio tipo EGEL – Capa 4 (Transporte)

Durante una prueba de rendimiento entre dos servidores ubicados en diferentes ciudades, se
observa que la transferencia de archivos mediante FTP es mucho más lenta que la descarga de
archivos a través de HTTP/HTTPS en las mismas condiciones de red. Ambos protocolos usan el
mismo enlace de ﬁbra óptica dedicado. El administrador revisa las estadísticas de paquetes y
detecta una alta cantidad de retransmisiones en la sesión FTP, mientras que en HTTP no se
presentan problemas notables.

¿Cuál es la explicación más adecuada desde el punto de vista de la
capa de transporte?

Opciones de respuesta:

A) El protocolo FTP utiliza UDP, que no implementa control de ﬂujo ni conﬁrmación de
recepción, lo que provoca pérdida de datos y retransmisiones.

B) La Capa 4 asigna diferentes prioridades a FTP y HTTP, y por defecto prioriza HTTP,
reduciendo el rendimiento de FTP.

C) Las retransmisiones en FTP indican congestión o pérdida de paquetes. Como FTP usa TCP, la
Capa 4 intenta garantizar la entrega, lo cual reduce el rendimiento en condiciones inestables.

D) El protocolo FTP depende exclusivamente del rendimiento de la Capa de Aplicación, por lo
que no se ve afectado por problemas de la Capa de Transporte.

Justiﬁcar la respuesta

Ejercicio tipo EGEL – Capa 5 (Sesión)

Una empresa de desarrollo de software implementa una plataforma de colaboración en línea
que permite múltiples funcionalidades: edición simultánea de documentos, videoconferencia,
chat en tiempo real y uso compartido de pantalla. Durante una sesión de trabajo, dos usuarios
están editando el mismo archivo de forma concurrente. El sistema mantiene las ediciones
sincronizadas y evita conﬂictos mediante sesiones independientes para cada usuario.

¿Cuál es la principal función de la Capa de Sesión que se evidencia en
este escenario?

Opciones:

A) Establecer los puertos lógicos necesarios para separar las aplicaciones concurrentes entre los
usuarios.

B) Encapsular los datos del archivo editado en paquetes con dirección IP de origen y destino.

C) Mantener, controlar y coordinar el diálogo entre las aplicaciones, asegurando sesiones únicas
y sincronizadas.

D) Garantizar la entrega conﬁable de los segmentos de datos a través de la red mediante el
protocolo TCP.

Justiﬁcar la respuesta

Ejercicio tipo EGEL – Capa 6 (Presentación)

Una empresa multinacional utiliza una aplicación de mensajería instantánea corporativa que
permite a los usuarios intercambiar documentos PDF, archivos ZIP y mensajes con emojis en
distintos idiomas. La aplicación incluye funciones automáticas de compresión y encriptación de
los archivos antes de enviarlos, además de conversión de caracteres entre distintos formatos
(por ejemplo, UTF-8 y ASCII) para garantizar que todos los mensajes se visualicen correctamente
en diferentes sistemas operativos.

¿Qué función de la Capa de Presentación se observa principalmente
en este escenario?

Opciones:

A) Formatear, cifrar y comprimir los datos para que puedan ser interpretados por el sistema
receptor.

B) Determinar la mejor ruta para enviar los datos entre diferentes ubicaciones geográﬁcas.

C) Encapsular los archivos en segmentos para su envío ordenado a través de la red.

D) Establecer y mantener las sesiones entre los usuarios conectados a la aplicación.

Justiﬁcar la respuesta

Ejercicio tipo EGEL – Capa 7 (Aplicación)

Una ingeniera de sistemas necesita veriﬁcar si un servidor web remoto está funcionando
correctamente. Abre su navegador e ingresa una URL para acceder a una aplicación web de
gestión empresarial. El navegador envía una solicitud HTTP al servidor, el cual responde con una
página HTML. La usuaria interactúa con formularios, sube archivos, y recibe respuestas
dinámicas del servidor según sus acciones. Todo esto ocurre en tiempo real, usando el protocolo
HTTPS.

¿Qué característica fundamental de la Capa 7 se evidencia en este
escenario?

Opciones:

A) Establecer conexiones virtuales entre dispositivos mediante direcciones IP y enrutamiento
de paquetes.

B) Administrar sesiones y sincronizar diálogos entre el cliente y el servidor.

C) Proveer servicios de red directamente al usuario ﬁnal y gestionar protocolos como HTTP y
FTP.

D) Codiﬁcar los datos para asegurar compatibilidad entre diferentes plataformas y sistemas.

Justiﬁcar la respuesta

