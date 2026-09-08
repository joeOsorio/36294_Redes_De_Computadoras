# Exposición: SSH (Secure Shell) — Protocolo de Capa 7 (Aplicación)

**Alumno:** Joshua Osorio Osorio (1293271)
**Materia:** Redes de Computadoras
**Fecha:** 28/08/2026

---

## 1. ¿Qué es SSH?

**SSH (Secure Shell)** es un protocolo de red de la capa de aplicación que permite el **acceso remoto seguro** a otro equipo (servidor) a través de una red no confiable, cifrando toda la comunicación: comandos, contraseñas, archivos y cualquier dato transmitido.

Fue creado en **1995 por Tapio Ylönen** (Universidad Tecnológica de Helsinki) como respuesta a un ataque de sniffing de contraseñas en su universidad, con el objetivo de reemplazar protocolos inseguros como **Telnet, rlogin y FTP**, que transmiten todo en texto plano.

Actualmente se usa la versión **SSH-2**, estandarizada por el IETF, que corrigió vulnerabilidades de la versión original SSH-1.

**Fuente primaria:** IETF, RFC 4251 — *The Secure Shell (SSH) Protocol Architecture* (2006), https://www.rfc-editor.org/rfc/rfc4251

---

## 2. ¿Para qué se usa?

- Administración remota de servidores (Linux, routers, switches).
- Transferencia segura de archivos (**SFTP**, **SCP**).
- Túneles cifrados / *port forwarding* para proteger otros protocolos.
- Automatización remota y despliegues (DevOps, CI/CD, Git sobre SSH).
- Acceso remoto en la nube (AWS EC2, servidores VPS, Raspberry Pi, etc.).

---

## 3. Arquitectura del protocolo (3 capas internas)

SSH-2 se compone de tres subprotocolos definidos en RFCs separados:

| Subprotocolo | RFC | Función |
|---|---|---|
| **SSH Transport Layer Protocol** | RFC 4253 | Establece el canal cifrado, autentica al **servidor** y negocia el algoritmo de cifrado. |
| **SSH Authentication Protocol** | RFC 4252 | Autentica al **cliente/usuario** (contraseña, clave pública, etc.). |
| **SSH Connection Protocol** | RFC 4254 | Multiplexa el canal cifrado en varios "canales lógicos" (sesión de shell, reenvío de puertos, SFTP, etc.). |

---

## 4. ¿Cómo funciona? (paso a paso)

1. **Conexión TCP inicial:** el cliente se conecta al servidor, normalmente por el **puerto 22/TCP**.
2. **Negociación de versión y algoritmos:** ambos intercambian qué versión de SSH y qué algoritmos de cifrado, intercambio de claves (*key exchange*) y verificación de integridad (HMAC) soportan.
3. **Intercambio de claves (Diffie-Hellman):** cliente y servidor generan de forma colaborativa una **clave de sesión simétrica** sin transmitirla directamente por la red (usando el algoritmo Diffie-Hellman o variantes modernas como ECDH/Curve25519).
4. **Autenticación del servidor:** el servidor presenta su **clave pública del host**; el cliente la compara contra su archivo `known_hosts` para verificar que no está hablando con un impostor (protección contra ataques *man-in-the-middle*).
5. **Autenticación del cliente:** el usuario se autentica mediante:
   - **Contraseña** (cifrada por el túnel, pero menos segura).
   - **Clave pública/privada** (recomendado): el cliente prueba poseer la clave privada correspondiente a una clave pública ya registrada en el servidor (`authorized_keys`), sin enviar la clave privada nunca por la red.
6. **Canal cifrado establecido:** a partir de aquí, toda la sesión (comandos, salida de terminal, archivos) viaja cifrada con la clave de sesión simétrica (p. ej. AES) y protegida con verificación de integridad (HMAC), evitando que un atacante intercepte o modifique los datos.
7. **Multiplexación de canales:** sobre esa única conexión cifrada se pueden abrir múltiples canales lógicos simultáneos: una shell interactiva, una transferencia SFTP, un túnel de reenvío de puertos, etc.

---

## 5. Autenticación por clave pública (punto clave para exponer)

Es el mecanismo más usado en producción porque es más seguro que las contraseñas:

1. El usuario genera un **par de claves** (`ssh-keygen`): una **privada** (se queda en su equipo, nunca se comparte) y una **pública** (se copia al servidor).
2. La clave pública se agrega al archivo `~/.ssh/authorized_keys` del servidor.
3. Al conectarse, el servidor envía un reto (*challenge*) cifrado con la clave pública del usuario.
4. Solo quien tenga la clave privada correspondiente puede descifrarlo y responder correctamente, demostrando su identidad **sin revelar la clave privada**.

---

## 6. Comparación SSH vs. Telnet (para reforzar el "por qué importa")

| Característica | Telnet | SSH |
|---|---|---|
| Cifrado | No (texto plano) | Sí (AES, ChaCha20, etc.) |
| Autenticación del servidor | No | Sí (clave de host) |
| Puerto por defecto | 23/TCP | 22/TCP |
| Integridad de datos | No verificada | Verificada (HMAC) |
| Uso actual | Obsoleto/inseguro | Estándar de facto |

**Fuente:** IETF RFC 854 (Telnet) vs. RFC 4251–4254 (SSH).

---

## 7. Herramientas y comandos comunes

```bash
ssh usuario@servidor              # conexión remota interactiva
ssh -p 2222 usuario@servidor      # especificar puerto distinto
scp archivo.txt usuario@servidor:/ruta   # copiar archivo (usa SSH)
sftp usuario@servidor             # sesión de transferencia de archivos
ssh-keygen -t ed25519             # generar par de claves modernas
ssh -L 8080:localhost:80 usuario@servidor  # túnel de reenvío de puertos
```

---

## 8. Relación con el resto del modelo OSI (para tu exposición)

- **Capa 7 (Aplicación):** SSH define el formato de los mensajes y la lógica del protocolo (autenticación, comandos, canales).
- **Capa 4 (Transporte):** se apoya en **TCP** (puerto 22) porque necesita entrega confiable y ordenada de los datos cifrados.
- **Capa 6 (Presentación):** aunque SSH no depende de TLS, realiza funciones equivalentes a la capa de presentación al cifrar y verificar la integridad de los datos dentro de su propio protocolo.

Este punto es útil para conectar tu exposición con el ejercicio EGEL de Capa 7 del taller: SSH es un ejemplo perfecto de un protocolo que "provee servicios de red directamente al usuario final" (opción C del ejercicio de HTTP/HTTPS), pero para acceso remoto seguro en lugar de navegación web.

---

## 9. Guion sugerido para la exposición oral (3–5 min)

1. **Gancho inicial:** "¿Alguna vez han tenido que administrar un servidor sin estar físicamente frente a él? Así es como se hace de forma segura."
2. **Definición:** qué es SSH y por qué nació (reemplazar Telnet inseguro).
3. **Cómo funciona:** explica el handshake (TCP → negociación → Diffie-Hellman → autenticación → canal cifrado) apoyándote en un diagrama simple.
4. **Demostración conceptual:** compara una conexión Telnet (texto plano, vulnerable) contra SSH (cifrado), usando la tabla comparativa.
5. **Ejemplo práctico:** muestra el comando `ssh usuario@servidor` y menciona claves públicas/privadas.
6. **Cierre:** relevancia actual de SSH en DevOps, la nube y ciberseguridad.

---

## Referencias

- IETF, RFC 4251 — *The Secure Shell (SSH) Protocol Architecture*, https://www.rfc-editor.org/rfc/rfc4251
- IETF, RFC 4252 — *The Secure Shell (SSH) Authentication Protocol*, https://www.rfc-editor.org/rfc/rfc4252
- IETF, RFC 4253 — *The Secure Shell (SSH) Transport Layer Protocol*, https://www.rfc-editor.org/rfc/rfc4253
- IETF, RFC 4254 — *The Secure Shell (SSH) Connection Protocol*, https://www.rfc-editor.org/rfc/rfc4254
- Ylönen, T. & Lonvick, C., Eds. (2006). *SSH Protocol Architecture*, IETF Network Working Group.
- Barrett, D. J., Silverman, R. E., & Byrnes, R. G. (2005). *SSH, The Secure Shell: The Definitive Guide* (2nd ed.). O'Reilly Media. (referenciado en Google Académico)
