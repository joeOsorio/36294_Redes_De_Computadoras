|     |     | T R | A N | S P | O   | R T | E   |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| M   | O   | D   | E   | L   | O   |     | O   | S   | I   |
Capa 4

I N T R O D U C C I Ó N
La capa de transporte (Capa 4 del modelo OSI) es el núcleo operativo de la comunicación en red,
responsable de establecer, gestionar y finalizar las conexiones lógicas directas entre aplicaciones que
se ejecutan en diferentes dispositivos. Mientras que las capas inferiores se encargan de manipular
cables, switches y routers para enrutar paquetes mediante direcciones IP, la capa 4 abstrae toda esa
complejidad física para garantizar que los datos entregados al software de destino sean coherentes,
utilizables y dirigidos al proceso correcto.
Mientras la capa 3 (red) se ocupa de mover paquetes entre dispositivos, la capa 4 garantiza que esos
datos lleguen sin errores, en orden y completos hasta la aplicación correcta.

P I L A R E S Q U E L O
D E F I N E N
1
Direccionamiento a nivel de proceso: Utiliza puertos
1
lógicos para identificar la aplicación específica dentro del
dispositivo origen y destino.
2
Control extremo a extremo (End-to-End): Supervisa el
2
flujo de la información de aplicación a aplicación,
ignorando los nodos intermediarios de la red física.
3
Calidad y modalidad de entrega: Establece el criterio de
3
transporte adaptado al tipo de datos. Puede operar bajo
un esquema confiable y ordenado o bajo un esquema de
alta velocidad.

| F U          | N   | C   | I O | N   | E S |   P | R I | N   | C   | I P              | A   | L E | S   |
| ------------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---------------- | --- | --- | --- |
|              | 0   | 1   |     |     |     |     |     |     |     |                  | 0   | 2   |     |
| Segmentación |     |     |     |     |     |     |     |     |     | Control de flujo |     |     |     |
Ajusta la velocidad de transmisión para
Es el encapsulado de capa 4.
evitar que algun emisor rápido sature a
Se encarga de dividir los flujos de
un receptor que sea mas lento.
datos grandes que llegan de la capa
superiór en segmentos manejables que
son unidos una vez llegan a su destino.

0 3
Control de errores
Se encarga de verificar si hay algún segmento dañado usando
sumas de verificación (checksums) y solicita su retransmición.
0 4 0 5
Multiplexión Conexión confiable o no
confiable
Utiliza números de puertos lógicos para
distinguir qué proceso o aplicación
Son diferentes modelos para el
específica debe recibir los datos
transporte de datos, con TCP siendo la
dentro de un mismo dispositivo (ej.
opcion segura y UDP la mas rápida
puerto 80 para HTTP, 443 para HTTPS).
pero menos confiable.

|     |       |     |       |       | T     | C   | P     |       |     |     |     |     |
| --- | ----- | --- | ----- | ----- | ----- | --- | ----- | ----- | --- | --- | --- | --- |
|     | T R A | N S | M I S | S I O | N   C | O N | T R O | L   P | R O | T O | C O | L   |
TCP proporciona una entrega continua fiable de datos entre sistemas
principales de internet
C A R A C T E R I S T I C A S   O P E R A T I V A S   D E L   T C P
| Transferencia |     |     |     |     | Fiabilidad |     |     |     |     | Control de flujo |     |     |
| ------------- | --- | --- | --- | --- | ---------- | --- | --- | --- | --- | ---------------- | --- | --- |
Transfiere una corriente continua TCP debe recuperar datos que Controla la cantidad de datos
de octetos de 8 bits, esten dañados, perdidos, enviados devolviendo una ventana
empaquetando un numero de bytes duplicados o entregados en mal con cada ACK. La ventana indica
de segmentos para transmitirlos orden el numero permitido de octetos
por el internet que el remitente puede transmitir
antes de recibir permiso adicional

T C P
C A R A C T E R I S T I C A S O P E R A T I V A S D E L T C P
Multiplexado Conexiones
Prioridad y seguridad
TCP permite que muchos procesos TCP debe inicializar y mantener Los usuarios de TCP pueden
en un solo sistema principal utilicen determinada informacion de indicar la seguridad y prioridad de
recursos de comunicaciones TCP estado para cada corriente de las comunicaciones.
de forma simultanea. datos. Cada conexion se
especifica de forma exclusiva
mediante un par de sockets que
identifican sus dos lados

|     |     |     |     | T C   | P     |     |       |       |     |
| --- | --- | --- | --- | ----- | ----- | --- | ----- | ----- | --- |
| C A | B E | C E | R A |   D E |   P A | Q U | E T E |   T C | P   |

T C P
E J E M P L O : D E S C A R G A D E U N A C A N C I O N E N L I N E A
El usuario ingresa a una pagina web y hace click en descargar un
archivo mp3
El equipo intenta establecer una comunicacion segura con el servidor
antes de comenzar
El archivo mp3 se divide en pequeñas unidades de datos que TCP
controla y numera
Cada paquete recibido es verificado y reconocido
Si un paquete de la cancion se pierde en el camino, TCP lo detecta y
lo vuelve a enviar
El 100% de los paquetes llega y el usuario puede disfrutar de su
descarga legal.

|     |     |     |       | U   | D   | P       |     |     |     |     |
| --- | --- | --- | ----- | --- | --- | ------- | --- | --- | --- | --- |
|     | U S | E R |   D A | T A | G R | A M   P | R O | T O | C O | L   |
 UDP protocolo de transporte NO CONFIABLE y SIN CONEXIÓN
diseñado para ser extremadamente RÁPIDO y LIGERO
C A R A C T E R I S T I C A S   O P E R A T I V A S   D E L   U D P
| Sin Conexion |     |     | No Fiabilidad |     |     |     |     | Sin Control de flujo |     |     |
| ------------ | --- | --- | ------------- | --- | --- | --- | --- | -------------------- | --- | --- |
No establece una comunicación No garantiza que los No regula la velocidad de envío
previa con el destino antes de datagramas lleguen a su según la capacidad del receptor.
enviar datos. No existe un "apretón destino. El emisor transmite al ritmo que la
de manos" o handshake de tres Cada datagrama viaja de aplicación le indique, sin
pasos como en TCP forma independiente y el preguntar si el destino puede
|     |     |     | emisor envía sin saber si el |     |     |     |     |     |     | procesarlos. |
| --- | --- | --- | ---------------------------- | --- | --- | --- | --- | --- | --- | ------------ |
receptor está activo.

U D P
U S E R D A T A G R A M P R O T O C O L
C A R A C T E R I S T I C A S O P E R A T I V A S D E L U D P
Sin Control de
Datagramas Bajo Overhead
Congestión
No detecta si la red está
Si se envían 100 bytes, el Tiene un encabezado de solo 8
saturada ni reduce su velocidad
receptor recibe 100 bytes bytes, compuesto por cuatro
de envío. Sigue transmitiendo al
exactos como un bloque único. campos simples: puerto origen,
mismo ritmo aunque haya
No fragmenta ni reensambla puerto destino, longitud y
congestión, lo que puede
datos, y no garantiza el orden checksum.
empeorar el problema y
de llegada.
contribuir a la pérdida masiva
de paquetes.

|     |       |     |     | U     | D     | P     |     |     |     |       |     |
| --- | ----- | --- | --- | ----- | ----- | ----- | --- | --- | --- | ----- | --- |
| E S | T R U | C T | U R | A   D | E   L | A   C | A B | E C | E R | A   U | D P |

U D P
E J E M P L O : R E P R O D U C I R U N V I D E O
Cuando ves cualquier video por Internet, ya sea en YouTube, Netflix,
TikTok, Instagram o cualquier otra plataforma, el video viaja desde un
servidor hasta tu dispositivo a través de la red. Para que esto sea
posible, el video se divide en pequeños fragmentos y cada uno se
envía en un paquete independiente usando UDP.
Si algún fragmento se pierde durante el viaje, UDP no lo reenvía.
Simplemente lo ignora y sigue enviando los siguientes. En tu pantalla,
ese fragmento perdido se traduce en un pequeño pixelado, una baja
momentánea de calidad o un pequeño salto en la reproducción, pero
el video nunca se detiene ni se pausa.

U D P
E J E M P L O : R E P R O D U C I R U N V I D E O
Cuando ves cualquier video por Internet, ya sea en YouTube, Netflix,
TikTok, Instagram o cualquier otra plataforma, el video viaja desde un
servidor hasta tu dispositivo a través de la red. Para que esto sea
posible, el video se divide en pequeños fragmentos y cada uno se
envía en un paquete independiente usando UDP.
Si algún fragmento se pierde durante el viaje, UDP no lo reenvía.
Simplemente lo ignora y sigue enviando los siguientes. En tu pantalla,
ese fragmento perdido se traduce en un pequeño pixelado, una baja
momentánea de calidad o un pequeño salto en la reproducción, pero
el video nunca se detiene ni se pausa.

| E L |   E | Q   | U   | I P | O   |
| --- | --- | --- | --- | --- | --- |
Carlos Gael Torres Sosa - 2218655
Luis Angel Ruiz Lopez - 2219019
Joshua Osorio Osorio - 1293271
Yahir Antonio Prado Hernandez - 01298051

E J E M P L O P R A C T I C O
E J E M P L O : N A V E G A C I Ó N E N U N A P Á G I N A W E B ( T C P )
Cuando ves cualquier video por Internet, ya sea en YouTube, Netflix,
TikTok, Instagram o cualquier otra plataforma, el video viaja desde un
servidor hasta tu dispositivo a través de la red. Para que esto sea
posible, el video se divide en pequeños fragmentos y cada uno se
envía en un paquete independiente usando UDP.
Si algún fragmento se pierde durante el viaje, UDP no lo reenvía.
Simplemente lo ignora y sigue enviando los siguientes. En tu pantalla,
ese fragmento perdido se traduce en un pequeño pixelado, una baja
momentánea de calidad o un pequeño salto en la reproducción, pero
el video nunca se detiene ni se pausa.

E J E M P L O P R A C T I C O
E J E M P L O : N A V E G A C I Ó N E N U N A P Á G I N A W E B ( T C P )
Cuando ves cualquier video por Internet, ya sea en YouTube, Netflix,
TikTok, Instagram o cualquier otra plataforma, el video viaja desde un
servidor hasta tu dispositivo a través de la red. Para que esto sea
posible, el video se divide en pequeños fragmentos y cada uno se
envía en un paquete independiente usando UDP.
Si algún fragmento se pierde durante el viaje, UDP no lo reenvía.
Simplemente lo ignora y sigue enviando los siguientes. En tu pantalla,
ese fragmento perdido se traduce en un pequeño pixelado, una baja
momentánea de calidad o un pequeño salto en la reproducción, pero
el video nunca se detiene ni se pausa.

| M   | U   | C   | H   | A   | S   |
| --- | --- | --- | --- | --- | --- |
| G   | R   | A C |     | I A | S   |
Lorem ipsum dolor sit amet, consectetur adipiscing
elit. Duis vulputate nulla at ante rhoncus, vel
efficitur felis condimentum. Proin odio odio.