# Investigación: Protocolos y Estándares del Modelo OSI

**Materia:** Redes de Computadoras
**Alumno:** Joshua Osorio Osorio (1293271)
**Fecha:** 28/08/2026

> Para cada protocolo se responde: **¿Qué es?** y **¿Cómo funciona?**, con referencias a fuentes primarias confiables (RFC del IETF, estándares IEEE, recomendaciones UIT/ISO) y literatura académica indexada en Google Académico.

---

## Capa 1 — Física

### Ethernet (IEEE 802.3)
**¿Qué es?** Familia de estándares que define la transmisión de datos en redes de área local (LAN) cableadas, especificando tanto la capa física como el control de acceso al medio (subcapa MAC de la capa 2).
**¿Cómo funciona?** Codifica los bits de datos en señales eléctricas u ópticas que se transmiten sobre cable de cobre (UTP/STP) o fibra óptica. Cada trama incluye direcciones MAC de origen y destino; en las variantes modernas (full-duplex, con switches) evita colisiones mediante conmutación dedicada, mientras que en versiones antiguas usaba CSMA/CD para detectar y resolver colisiones en el medio compartido.
**Fuente:** IEEE Standards Association, *IEEE 802.3 Ethernet Working Group* — https://www.ieee802.org/3/ ; IEEE Std 802.3-2022.

### Wi-Fi (IEEE 802.11)
**¿Qué es?** Conjunto de estándares para redes inalámbricas de área local (WLAN) que permiten la transmisión de datos por radiofrecuencia sin necesidad de cableado.
**¿Cómo funciona?** Los dispositivos (estaciones) se comunican con un punto de acceso mediante ondas de radio en bandas de 2.4 GHz, 5 GHz o 6 GHz. Usa CSMA/CA (evitación de colisiones) porque los dispositivos inalámbricos no pueden detectar colisiones mientras transmiten; antes de enviar, el dispositivo "escucha" el canal y espera si está ocupado.
**Fuente:** IEEE Std 802.11-2020, *IEEE Standard for Wireless LAN*; Gast, M. (2005). *802.11 Wireless Networks: The Definitive Guide*, O'Reilly (citado en Google Académico).

### Bluetooth (IEEE 802.15)
**¿Qué es?** Estándar para redes inalámbricas personales (WPAN) de corto alcance, orientado a la interconexión de dispositivos como teléfonos, auriculares y periféricos.
**¿Cómo funciona?** Opera en la banda ISM de 2.4 GHz utilizando salto de frecuencia adaptativo (AFH) para minimizar interferencias, formando redes pequeñas llamadas *piconets* donde un dispositivo maestro coordina hasta siete dispositivos esclavos activos.
**Fuente:** Bluetooth SIG, *Bluetooth Core Specification*; IEEE 802.15 Working Group — https://www.ieee802.org/15/.

---

## Capa 2 — Enlace de Datos

### PPP (Point-to-Point Protocol)
**¿Qué es?** Protocolo estándar de Internet para establecer una conexión directa entre dos nodos, comúnmente usado en enlaces seriales, dial-up y VPN.
**¿Cómo funciona?** Usa el protocolo LCP (Link Control Protocol) para establecer, configurar y probar el enlace, y protocolos NCP (Network Control Protocol) para negociar los protocolos de capa de red que se transportarán (p. ej. IPCP para IP). Puede incluir autenticación (PAP/CHAP).
**Fuente:** IETF, RFC 1661 — *The Point-to-Point Protocol (PPP)*, https://www.rfc-editor.org/rfc/rfc1661.

### HDLC (High-Level Data Link Control)
**¿Qué es?** Protocolo orientado a bit para la transmisión de datos en enlaces WAN, estandarizado por la ISO.
**¿Cómo funciona?** Encapsula los datos en tramas delimitadas por una bandera especial (01111110), incluye control de errores mediante CRC y soporta modos de operación balanceados (conexión punto a punto entre pares iguales).
**Fuente:** ISO/IEC 13239:2002, *High-level data link control (HDLC) procedures*.

### STP (Spanning Tree Protocol)
**¿Qué es?** Protocolo de capa 2 que evita bucles (loops) en redes con switches redundantes.
**¿Cómo funciona?** Los switches intercambian mensajes BPDU (Bridge Protocol Data Unit) para elegir un switch raíz y calcular el camino más corto hacia él; los enlaces redundantes que crearían un bucle se bloquean lógicamente hasta que sean necesarios (por falla de otro enlace).
**Fuente:** IEEE Std 802.1D-2004, *Media Access Control (MAC) Bridges*.

---

## Capa 3 — Red

### IP (Internet Protocol)
**¿Qué es?** Protocolo principal de direccionamiento y entrega de paquetes en Internet, sin conexión y sin garantía de entrega ("best effort").
**¿Cómo funciona?** Cada paquete lleva una dirección IP de origen y destino; los routers usan tablas de enrutamiento para decidir el siguiente salto hacia el destino, sin mantener estado de la sesión.
- **IPv4** (32 bits, ej. 192.168.1.1) — IETF, RFC 791.
- **IPv6** (128 bits, ej. 2001:0db8::1) — IETF, RFC 8200.
**Fuente:** IETF, RFC 791 — *Internet Protocol*; RFC 8200 — *Internet Protocol, Version 6 (IPv6) Specification*.

### ICMP (Internet Control Message Protocol)
**¿Qué es?** Protocolo auxiliar de IP usado para el diagnóstico y reporte de errores en la red (p. ej. `ping`, `traceroute`).
**¿Cómo funciona?** Los routers y hosts envían mensajes ICMP (como "destino inalcanzable" o "tiempo excedido") cuando ocurre un problema al procesar un paquete IP; no transporta datos de aplicación.
**Fuente:** IETF, RFC 792 — *Internet Control Message Protocol*.

### ARP (Address Resolution Protocol)
**¿Qué es?** Protocolo que traduce direcciones IP a direcciones MAC dentro de una red local (opera en el límite entre capa 2 y 3).
**¿Cómo funciona?** Un dispositivo envía una solicitud broadcast preguntando "¿quién tiene esta IP?"; el dueño responde con su dirección MAC, que se almacena en una tabla ARP local (caché) para futuras comunicaciones.
**Fuente:** IETF, RFC 826 — *An Ethernet Address Resolution Protocol*.

### RARP (Reverse ARP)
**¿Qué es?** Protocolo obsoleto que realiza la operación inversa a ARP: traduce una dirección MAC a una dirección IP.
**¿Cómo funciona?** Un dispositivo sin IP configurada envía su dirección MAC en broadcast; un servidor RARP responde con la IP asignada. Fue reemplazado por BOOTP y DHCP.
**Fuente:** IETF, RFC 903 — *A Reverse Address Resolution Protocol*.

### Protocolos de enrutamiento dinámico
- **RIP (Routing Information Protocol):** protocolo de vector distancia que elige rutas según el número de saltos (máximo 15); intercambia periódicamente toda la tabla de enrutamiento con sus vecinos. Fuente: IETF, RFC 2453.
- **OSPF (Open Shortest Path First):** protocolo de estado de enlace que construye un mapa completo de la topología de red y calcula la ruta más corta con el algoritmo de Dijkstra. Fuente: IETF, RFC 2328.
- **BGP (Border Gateway Protocol):** protocolo de vector de ruta usado entre sistemas autónomos; es el protocolo que permite el enrutamiento a gran escala en Internet, seleccionando rutas según políticas y atributos de trayectoria. Fuente: IETF, RFC 4271.

---

## Capa 4 — Transporte

### TCP (Transmission Control Protocol)
**¿Qué es?** Protocolo orientado a conexión que garantiza la entrega confiable y ordenada de datos.
**¿Cómo funciona?** Establece la conexión mediante un saludo de tres vías (*three-way handshake*: SYN, SYN-ACK, ACK), numera los segmentos para reensamblarlos en orden, confirma su recepción y retransmite los que se pierden; además implementa control de flujo y control de congestión.
**Fuente:** IETF, RFC 9293 — *Transmission Control Protocol (TCP)*.

### UDP (User Datagram Protocol)
**¿Qué es?** Protocolo sin conexión, más simple y rápido que TCP, sin garantías de entrega ni orden.
**¿Cómo funciona?** Envía datagramas de forma independiente sin establecer conexión previa ni confirmar su recepción, lo que reduce la latencia y lo hace adecuado para aplicaciones en tiempo real (streaming, VoIP, DNS).
**Fuente:** IETF, RFC 768 — *User Datagram Protocol*.

---

## Capa 5 — Sesión

### PPTP (Point-to-Point Tunneling Protocol)
**¿Qué es?** Protocolo usado para crear redes privadas virtuales (VPN) mediante la tunelización de tráfico PPP sobre una red IP.
**¿Cómo funciona?** Encapsula tramas PPP dentro de paquetes GRE (Generic Routing Encapsulation) que viajan sobre una conexión TCP de control; hoy se considera inseguro y ha sido sustituido por protocolos como IPsec o WireGuard.
**Fuente:** IETF, RFC 2637 — *Point-to-Point Tunneling Protocol (PPTP)*.

### RPC (Remote Procedure Call)
**¿Qué es?** Mecanismo que permite que un programa ejecute una función o procedimiento en otra computadora como si fuera local.
**¿Cómo funciona?** El cliente invoca una función local (*stub*) que serializa los parámetros, los envía por la red al servidor, éste ejecuta el procedimiento real y devuelve el resultado, que el stub del cliente deserializa de forma transparente.
**Fuente:** IETF, RFC 5531 — *RPC: Remote Procedure Call Protocol Specification Version 2*.

### SIP (Session Initiation Protocol)
**¿Qué es?** Protocolo de señalización usado para iniciar, modificar y terminar sesiones multimedia como llamadas de telefonía IP y videoconferencias.
**¿Cómo funciona?** Usa mensajes de tipo solicitud/respuesta (similares a HTTP) como INVITE, ACK y BYE para negociar la sesión entre los participantes; la negociación de parámetros multimedia (códecs, puertos) se hace mediante SDP (Session Description Protocol).
**Fuente:** IETF, RFC 3261 — *SIP: Session Initiation Protocol*.

---

## Capa 6 — Presentación

### SSL/TLS
**¿Qué es?** Protocolos criptográficos que proveen comunicación segura sobre una red (SSL es el predecesor obsoleto de TLS), usados por HTTPS.
**¿Cómo funciona?** Durante el *handshake* TLS, cliente y servidor negocian un algoritmo de cifrado, el servidor presenta un certificado digital para autenticarse, y ambos generan claves de sesión simétricas que cifran el resto de la comunicación.
**Fuente:** IETF, RFC 8446 — *The Transport Layer Security (TLS) Protocol Version 1.3*.

### ASCII, EBCDIC, Unicode
**¿Qué es?** Estándares de codificación de caracteres que definen cómo se representan letras, números y símbolos en formato binario.
**¿Cómo funciona?** ASCII asigna un valor numérico de 7 bits a cada carácter (128 símbolos); EBCDIC es un esquema alterno de 8 bits usado históricamente en mainframes IBM; Unicode (con codificaciones como UTF-8) usa un espacio de código mucho más amplio para representar prácticamente todos los idiomas del mundo, garantizando compatibilidad entre sistemas.
**Fuente:** The Unicode Consortium, *The Unicode Standard*, https://www.unicode.org/standard/standard.html; ANSI X3.4 (ASCII).

---

## Capa 7 — Aplicación

### HTTP / HTTPS
**¿Qué es?** Protocolo de transferencia de hipertexto usado para la comunicación entre navegadores y servidores web; HTTPS es su variante cifrada mediante TLS.
**¿Cómo funciona?** El cliente envía solicitudes (GET, POST, etc.) a un servidor, que responde con un código de estado y el contenido solicitado (HTML, JSON, etc.), usando un modelo sin estado sobre una conexión TCP.
**Fuente:** IETF, RFC 9110 — *HTTP Semantics*; RFC 9113 — *HTTP/2*.

### SMTP, IMAP, POP3
**¿Qué es?** Protocolos para el envío (SMTP) y la recepción/lectura (IMAP, POP3) de correo electrónico.
**¿Cómo funciona?** SMTP transmite el mensaje entre servidores de correo mediante comandos de texto; IMAP permite gestionar el correo directamente en el servidor (sincronización entre dispositivos), mientras que POP3 descarga los mensajes al cliente y normalmente los elimina del servidor.
**Fuente:** IETF, RFC 5321 (SMTP); RFC 3501 (IMAP4); RFC 1939 (POP3).

### FTP / SFTP
**¿Qué es?** Protocolos para la transferencia de archivos entre un cliente y un servidor. SFTP añade cifrado al ejecutarse sobre SSH.
**¿Cómo funciona?** FTP usa dos conexiones TCP separadas (control y datos); el cliente autentica y envía comandos por el canal de control mientras los archivos se transfieren por el canal de datos, sin cifrado nativo. SFTP transfiere todo (comandos y datos) cifrado dentro de un único túnel SSH.
**Fuente:** IETF, RFC 959 (FTP); RFC 4253 y draft *SSH File Transfer Protocol* (SFTP, IETF).

### DNS (Domain Name System)
**¿Qué es?** Sistema jerárquico y distribuido que traduce nombres de dominio legibles por humanos a direcciones IP.
**¿Cómo funciona?** Cuando un cliente solicita resolver un nombre, la consulta se reenvía a través de servidores raíz, servidores de dominio de nivel superior (TLD) y servidores autoritativos hasta obtener la IP correspondiente, que puede almacenarse en caché para acelerar consultas futuras.
**Fuente:** IETF, RFC 1034 y RFC 1035 — *Domain Names*.

### DHCP (Dynamic Host Configuration Protocol)
**¿Qué es?** Protocolo que asigna automáticamente direcciones IP y otros parámetros de red a los dispositivos de una red.
**¿Cómo funciona?** Sigue el proceso DORA: el cliente envía un mensaje *Discover* en broadcast, el servidor responde con una *Offer*, el cliente confirma con *Request* y el servidor finaliza con un *Acknowledge*, entregando IP, máscara, gateway y DNS.
**Fuente:** IETF, RFC 2131 — *Dynamic Host Configuration Protocol*.

### Telnet / SSH
**¿Qué es?** Protocolos para el acceso remoto a la línea de comandos de otro equipo. SSH es la evolución segura de Telnet.
**¿Cómo funciona?** Telnet transmite todo el tráfico (incluidas contraseñas) en texto claro sobre TCP. SSH cifra toda la sesión mediante criptografía de clave pública para autenticar al servidor y, opcionalmente, al cliente, protegiendo la confidencialidad e integridad de la comunicación.
**Fuente:** IETF, RFC 854 (Telnet); RFC 4251 — *The Secure Shell (SSH) Protocol Architecture*.

### SNMP (Simple Network Management Protocol)
**¿Qué es?** Protocolo estándar para monitorear y administrar dispositivos en una red (routers, switches, servidores).
**¿Cómo funciona?** Los dispositivos administrados ejecutan un *agente* que mantiene una base de información (MIB); una estación gestora consulta (GET) o modifica (SET) esos valores, y los agentes pueden enviar notificaciones (*traps*) ante eventos relevantes.
**Fuente:** IETF, RFC 1157 (SNMPv1); RFC 3411–3418 (SNMPv3).

---

## Conclusiones

1. La mayoría de los protocolos usados en Internet están documentados como RFC del **IETF**, el organismo que estandariza los protocolos de la capa de red en adelante, mientras que el **IEEE** domina los estándares de las capas física y de enlace en redes LAN/WAN.
2. Existe una tendencia clara hacia el reemplazo de protocolos inseguros (Telnet, FTP, PPTP, SSL) por sus versiones cifradas (SSH, SFTP/FTPS, IPsec/WireGuard, TLS), reflejando la evolución de los requisitos de seguridad en redes.
3. Conocer el propósito y funcionamiento de cada protocolo por capa facilita el diagnóstico de fallas (como en los ejercicios tipo EGEL), ya que permite ubicar en qué nivel de la comunicación se originan los problemas.

## Referencias

- IETF — *RFC Editor*, https://www.rfc-editor.org/
- IEEE Standards Association, https://standards.ieee.org/
- ISO/IEC, https://www.iso.org/
- The Unicode Consortium, https://www.unicode.org/
- Kurose, J. F. & Ross, K. W. (2021). *Computer Networking: A Top-Down Approach* (8th ed.). Pearson. (indexado en Google Académico)
- Tanenbaum, A. S. & Wetherall, D. (2011). *Computer Networks* (5th ed.). Prentice Hall. (indexado en Google Académico)
