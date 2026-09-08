# Capa 4 – Transporte (Modelo OSI)

> **Idea central:** la capa de transporte se asegura de que los datos lleguen a la
> **aplicación correcta**, de forma **confiable, ordenada y completa** (TCP) o
> **rápida y eficiente** (UDP).

---

## 1. Ubicación dentro del modelo

| Capa | Nombre | PDU | Se preocupa por... |
|------|--------|-----|--------------------|
| 7 | Aplicación | Datos | Lo que el usuario ve |
| 6 | Presentación | Datos | Formato, cifrado, compresión |
| 5 | Sesión | Datos | Diálogo entre aplicaciones |
| **4** | **Transporte** | **Segmento / Datagrama** | **Entrega extremo a extremo, puerto a puerto** |
| 3 | Red | Paquete | Llevar el paquete al host correcto (IP) |
| 2 | Enlace de datos | Trama | Llevar la trama al siguiente salto (MAC) |
| 1 | Física | Bits | Señales eléctricas, ópticas, de radio |

La capa 4 es la **frontera**: de la 1 a la 3 el trabajo es de la red (routers, switches,
cables); de la 4 hacia arriba el trabajo es de los **dispositivos finales** (host a host).

**PDU de la capa 4:**
- Con TCP se llama **segmento**.
- Con UDP se llama **datagrama**.

---

## 2. ¿Qué problema resuelve realmente?

La capa 3 sabe llegar a la **computadora** correcta usando la dirección IP.
Pero dentro de esa computadora hay decenas de programas abiertos al mismo tiempo:
navegador, Spotify, WhatsApp, el antivirus actualizándose.

La capa 3 no sabe a cuál de todos entregarle los datos. La capa 4 sí, gracias a los
**puertos**. Además resuelve tres problemas que la capa 3 deja abiertos:

1. Los mensajes grandes no caben en un solo paquete → hay que **partirlos y rearmarlos**.
2. Los paquetes pueden **perderse, duplicarse o llegar desordenados** → hay que corregirlo.
3. Un emisor rápido puede **saturar** a un receptor lento o a la red → hay que regular.

---

## 3. Funciones principales

### 3.1 Segmentación y reensamblado
- Divide los mensajes grandes en **segmentos** más pequeños para su transmisión.
- Cada segmento lleva un **número de secuencia**.
- En el destino se vuelven a unir **en el orden correcto**, aunque hayan llegado
  desordenados por tomar rutas distintas.

### 3.2 Control de errores
- Verifica la integridad de los datos mediante **sumas de verificación (checksum)**.
- Si el checksum no coincide, el segmento se descarta.
- En TCP, además, se **retransmite** el segmento perdido o dañado.
- En UDP el checksum existe pero es opcional en IPv4 (obligatorio en IPv6), y si falla
  simplemente se descarta: no hay reenvío.

### 3.3 Control de flujo
- Ajusta la velocidad de transmisión para evitar que un emisor rápido **sature a un
  receptor lento**.
- TCP lo hace con la **ventana deslizante** (*sliding window*): el receptor anuncia en
  cada acuse cuánto espacio libre le queda en su búfer, y el emisor no envía más que eso.

### 3.4 Control de congestión
*(No confundir con control de flujo: el de flujo protege al **receptor**, el de congestión
protege a la **red**.)*
- TCP detecta congestión cuando empieza a perder segmentos y **reduce su velocidad**.
- Usa mecanismos como **inicio lento (*slow start*)** y aumento gradual de la ventana.
- Es la razón por la que una descarga arranca lento y va acelerando.

### 3.5 Multiplexación / demultiplexación
- **Multiplexación:** varias aplicaciones comparten una sola conexión de red.
- **Demultiplexación:** al llegar los datos, se reparten a la aplicación correcta.
- Se logra mediante **puertos lógicos** (ej. 80, 443, 25).

### 3.6 Establecimiento y cierre de conexión
- TCP es **orientado a conexión**: negocia antes de enviar y cierra de forma ordenada.
- UDP es **no orientado a conexión**: envía directamente, sin negociación previa.

---

## 4. Direccionamiento: puertos y sockets

Un **puerto** es un número de 16 bits (0 a 65535) que identifica una aplicación o servicio.

| Rango | Nombre | Uso |
|-------|--------|-----|
| 0 – 1023 | Bien conocidos (*well-known*) | Servicios estándar del sistema |
| 1024 – 49151 | Registrados | Aplicaciones de terceros |
| 49152 – 65535 | Dinámicos / efímeros | Los que tu PC asigna al azar como puerto de origen |

**Socket = dirección IP + número de puerto.** Ejemplo: `192.168.1.10:52341`
Una conexión TCP queda identificada de forma única por **cuatro datos**:
IP origen, puerto origen, IP destino, puerto destino.

### Puertos que conviene memorizar

| Puerto | Protocolo | Servicio |
|--------|-----------|----------|
| 20 / 21 | TCP | FTP (datos / control) |
| 22 | TCP | SSH |
| 23 | TCP | Telnet |
| 25 | TCP | SMTP (correo saliente) |
| 53 | UDP y TCP | DNS |
| 67 / 68 | UDP | DHCP |
| 80 | TCP | HTTP |
| 110 | TCP | POP3 |
| 143 | TCP | IMAP |
| 161 | UDP | SNMP |
| 443 | TCP | HTTPS |
| 3389 | TCP | RDP (Escritorio remoto) |

---

## 5. Protocolos principales de la Capa 4

### TCP – Transmission Control Protocol
- **Confiable** y **orientado a conexión**.
- Garantiza entrega **ordenada, completa y sin duplicados**.
- Retransmite lo que se pierde y confirma cada recepción con **ACK**.
- Cabecera de **20 bytes** como mínimo.
- Usado en: web (HTTP/HTTPS), correo electrónico, FTP, SSH, transferencia de archivos.

**Campos clave de la cabecera TCP:** puerto origen, puerto destino, número de secuencia,
número de acuse (ACK), banderas (SYN, ACK, FIN, RST, PSH, URG), tamaño de ventana, checksum.

### UDP – User Datagram Protocol
- **No confiable** y **sin conexión**.
- Rápido, sin control de errores, sin reenvío y sin orden garantizado.
- Cabecera de solo **8 bytes** → mucho menos sobrecarga.
- Usado en: streaming de video/audio, juegos en línea, VoIP, DNS, DHCP.

**Campos de la cabecera UDP:** puerto origen, puerto destino, longitud, checksum. Nada más.

### Comparativa TCP vs UDP

| Característica | TCP | UDP |
|----------------|-----|-----|
| Conexión previa | Sí (handshake de 3 vías) | No |
| Confiabilidad | Garantizada | No garantizada |
| Orden de llegada | Garantizado | No garantizado |
| Retransmisión | Sí | No |
| Control de flujo | Sí | No |
| Control de congestión | Sí | No |
| Tamaño de cabecera | 20 bytes o más | 8 bytes |
| Velocidad | Menor (más sobrecarga) | Mayor |
| Difusión / multidifusión | No | Sí |
| Analogía | Llamada telefónica | Mensaje en una botella |

### Dato extra: otros protocolos de transporte
- **SCTP** (*Stream Control Transmission Protocol*): combina ventajas de TCP y UDP,
  usado en redes de telefonía móvil.
- **QUIC**: desarrollado por Google, corre **sobre UDP** pero implementa confiabilidad y
  cifrado por su cuenta. Es la base de **HTTP/3**, lo que usa hoy YouTube y gran parte de
  la web moderna.

---

## 6. Cómo funciona

### Ejemplo con TCP (cuando abres una página web)

1. La PC cliente envía un segmento TCP con la solicitud al puerto **80** (HTTP) o **443**
   (HTTPS) del servidor, usando un puerto de origen efímero.
2. Se establece una conexión confiable mediante el **handshake de 3 vías**:
   - **SYN** → el cliente pide abrir la conexión y propone un número de secuencia inicial.
   - **SYN-ACK** → el servidor acepta y propone el suyo.
   - **ACK** → el cliente confirma. Conexión establecida.
3. Los datos viajan segmentados; cada segmento lleva un **número de secuencia** para
   reensamblarse en orden.
4. El receptor confirma con **ACK**. Si un segmento se pierde, el receptor pide su reenvío
   (o el emisor lo detecta por *timeout*) y se **retransmite**.
5. La **ventana deslizante** regula cuántos segmentos pueden ir "en el aire" sin confirmar.
6. Una vez transmitidos todos los datos, la conexión se cierra de forma ordenada con un
   **cierre de 4 vías**: FIN → ACK → FIN → ACK.

### Ejemplo con UDP (cuando ves un partido en streaming)

1. El emisor manda datagramas directamente al puerto de la aplicación de video,
   **sin negociación previa**.
2. Si un datagrama se pierde, **no se reenvía** → se prefiere velocidad sobre perfección.
3. El receptor reproduce lo que recibe de inmediato, aunque haya algunos saltos o
   *pixelado* momentáneo.
4. Reenviar un cuadro de video que ya pasó no tendría sentido: llegaría tarde y solo
   añadiría retraso a toda la transmisión.

---

## 7. Diferencia clave con las capas vecinas

- **Capa 3 (Red):** entrega **paquetes entre dispositivos**. Su dirección es la **IP**.
  Responde a *"¿a qué computadora va esto?"*
- **Capa 4 (Transporte):** entrega **datos a la aplicación correcta**, de forma confiable o
  rápida. Su dirección es el **puerto**. Responde a *"¿a qué programa dentro de esa
  computadora va esto, y llegó completo?"*
- **Capa 5 (Sesión):** administra el **diálogo** entre las aplicaciones (apertura,
  sincronización y cierre de la sesión de trabajo).

**Regla mnemotécnica:** la IP te lleva al edificio, el puerto te lleva al departamento.

---

## 8. La capa 4 en el mundo real

Donde se nota la capa 4 fuera del salón de clases:

- **Firewalls de capa 4:** filtran tráfico según puerto y protocolo. Bloquear el puerto 23
  (Telnet) o permitir solo el 443 son decisiones de capa 4.
- **NAT / PAT:** tu router en casa usa **puertos** para que muchos dispositivos compartan
  una sola IP pública. Sin capa 4, esto no sería posible.
- **Balanceadores de carga L4:** reparten conexiones entre varios servidores mirando
  únicamente IP y puerto.
- **Diagnóstico de red:** herramientas como `netstat`, `ss` o Wireshark muestran
  directamente conexiones, puertos y estados TCP.

---

## 9. Ejemplos prácticos para exponer

### Ejemplo práctico 1 – Navegación en una página web (TCP)

- La **PC1** abre el navegador e ingresa a `www.uabc.mx`.
- La capa de transporte del cliente usa **TCP** para enviar la solicitud al servidor
  (puerto destino 443).
- Se establece el **handshake de 3 vías** (SYN, SYN-ACK, ACK) entre cliente y servidor.
- Los datos (código HTML de la página) se dividen en **segmentos TCP** con números de
  secuencia.
- El servidor confirma la recepción de cada segmento; si falta uno, se pide
  **retransmisión**.
- El navegador recibe todos los segmentos, los **reensambla** y muestra la página completa.
- La conexión se cierra ordenadamente.

**Por qué TCP aquí:** una página web con la mitad del código faltante simplemente no se
muestra. La exactitud importa más que unos milisegundos.

### Ejemplo práctico 2 – Videollamada por Zoom (UDP)

- La **PC2** inicia una videollamada con un compañero.
- La aplicación genera un flujo de audio y video que se encapsula en **datagramas UDP**.
- La capa de transporte envía los datagramas **sin establecer conexión previa**,
  priorizando la velocidad.
- Si se pierde algún datagrama, **no se retransmite**, para no retrasar la llamada.
- El receptor reproduce los datos recibidos de inmediato, aunque falten pequeños
  fragmentos, asegurando fluidez.

**Por qué UDP aquí:** en una conversación en vivo, un audio perfecto que llega 3 segundos
tarde es peor que un audio con un pequeño corte que llega a tiempo.

### Ejemplo práctico 3 – Consulta DNS (UDP, opcional)

- Al escribir un dominio, la PC envía una consulta al puerto **53** por UDP.
- Es una sola pregunta y una sola respuesta: montar una conexión TCP completa sería un
  desperdicio.
- Si no hay respuesta, la aplicación simplemente **vuelve a preguntar**.

---

## 10. Resumen

**En una frase:** la capa de transporte del modelo OSI se encarga de que los datos lleguen
de forma confiable, completa y en orden (**TCP**), o de forma rápida y eficiente (**UDP**),
diferenciando aplicaciones mediante **puertos lógicos**.

**Tres ideas para que nadie se vaya sin ellas:**
1. La capa 4 conecta **aplicaciones**, no computadoras. Su dirección es el **puerto**.
2. **TCP** = confiabilidad. **UDP** = velocidad. No hay uno mejor: hay uno adecuado
   para cada caso.
3. Segmentar, numerar, confirmar y regular: cuatro verbos que resumen todo el trabajo
   de esta capa.

---

## 11. Preguntas para el grupo

> **Nota para el expositor:** lanza la pregunta, deja 3 a 5 segundos de silencio real
> (aunque se sienta incómodo) y recién entonces desarrolla la respuesta. El silencio es
> lo que hace que la gente piense.

### Pregunta 1 — Apertura del tema
**"Tu computadora tiene una sola dirección IP, pero ahora mismo tienes abierto el
navegador, Spotify y WhatsApp. Cuando llega un paquete, ¿cómo sabe la computadora a cuál
de los tres entregárselo?"**

*Respuesta guía:* Por el **número de puerto**. La IP identifica al dispositivo; el puerto
identifica a la aplicación. A eso se le llama **demultiplexación**, y es la razón de ser
de la capa 4.

### Pregunta 2 — Núcleo del tema: TCP vs UDP
**"Si TCP garantiza que no se pierda ni un solo dato, ¿por qué Netflix, Zoom y los juegos
en línea prefieren usar UDP, que no garantiza nada?"**

*Respuesta guía:* Porque en comunicación **en tiempo real**, un dato retransmitido llega
tarde y ya no sirve. Reenviar un cuadro de video que ya pasó solo agrega retraso a todo
lo demás. Es preferible un pequeño pixelado a que la llamada se congele. La confiabilidad
tiene un **costo en tiempo**, y no todas las aplicaciones pueden pagarlo.

### Pregunta 3 — Cierre y conexión con la capa 3
**"Si la capa 3 ya se encargó de llevar el paquete hasta la computadora correcta,
¿para qué necesitamos entonces la capa 4?"**

*Respuesta guía:* Porque llegar al **dispositivo** correcto no es lo mismo que llegar a la
**aplicación** correcta, ni garantiza que haya llegado **completo y en orden**. La capa 3
entrega el sobre en el edificio; la capa 4 lo sube al departamento correcto y verifica
que no falte ninguna hoja.

### Preguntas de reserva

- **"¿Qué pasa si tu PC con fibra óptica le manda datos a toda velocidad a un dispositivo
  IoT viejito y lento?"** → Se satura y pierde datos. Por eso existe el **control de flujo**
  y la ventana deslizante.
- **"¿Por qué crees que una descarga arranca lenta y va acelerando poco a poco, en vez de
  ir a máxima velocidad desde el primer segundo?"** → Por el **control de congestión**
  (*slow start*): TCP tantea la red antes de confiarse.
- **"En casa tienen una sola IP pública y diez dispositivos conectados. ¿Cómo sabe el
  router de quién es cada respuesta que llega de internet?"** → Por **PAT**, que usa
  puertos de capa 4 para distinguirlos.

---

## 12. Glosario rápido

| Término | Definición |
|---------|-----------|
| **Segmento** | PDU de la capa 4 en TCP |
| **Datagrama** | PDU de la capa 4 en UDP |
| **Puerto** | Número de 16 bits que identifica una aplicación |
| **Socket** | Combinación de dirección IP + puerto |
| **Handshake de 3 vías** | SYN → SYN-ACK → ACK, para abrir una conexión TCP |
| **ACK** | Acuse de recibo: confirma que un segmento llegó bien |
| **Checksum** | Suma de verificación para detectar errores |
| **Ventana deslizante** | Mecanismo de control de flujo de TCP |
| **Multiplexación** | Varias aplicaciones compartiendo un mismo enlace |
| **MSS** | Tamaño máximo de datos que cabe en un segmento TCP |
