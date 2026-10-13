# Práctica 10 — Redes Inalámbricas (802.11)

**Taller · Unidad 2 — Análisis de seguridad 802.11**
**Objetivo:** poner la tarjeta en modo monitor, auditar **tu propia red de pruebas** con `wifite` y entender los métodos de ataque (WPS, PMKID, handshake WPA).

---

> ## ⚠️ Antes de empezar — regla de oro
>
> Audita **únicamente la red que tú controlas** (tu propio router de pruebas, con contraseña conocida). Capturar handshakes, enviar *deauth* o atacar WPS de una red ajena —aunque sea del vecino— es **ilegal** en México (Código Penal Federal, art. 211 bis) y rompe la ética del curso.
>
> En la práctica, además, apuntar a **una sola red tuya** es lo que hace que el ataque *funcione*: identificas su BSSID, te acercas y tienes un cliente real para reconectar.

| | |
|---|---|
| **Objetivo** | Entender WPA/WPS y capturar un handshake |
| **SO** | Kali Linux Rolling |
| **Herramienta** | `wifite` + `aircrack-ng` |
| **Requisito clave** | Tarjeta con modo monitor **+ inyección** |

---

## 1. Preparación del sistema

Actualiza el sistema e instala las herramientas inalámbricas y las de captura PMKID.
**Importante:** si faltan las de PMKID, `wifite` salta ese ataque (es uno de los errores que viste).

```bash
sudo apt update
sudo apt install -y wireless-tools aircrack-ng
sudo apt install -y hcxdumptool hcxtools   # provee hcxpcapngtool (PMKID)
```

Verifica el nombre de tu interfaz inalámbrica (normalmente `wlan0`):

```bash
iwconfig
iw dev            # lista interfaces y su nombre
```

---

## 2. Activar el modo monitor

El modo monitor permite a la tarjeta **escuchar** todo el tráfico 802.11 del aire.
`airmon-ng check kill` cierra los procesos que estorban (NetworkManager, wpa_supplicant).

```bash
sudo airmon-ng                 # lista adaptadores compatibles
sudo airmon-ng check           # procesos que pueden interferir
sudo airmon-ng check kill      # los cierra
sudo airmon-ng start wlan0     # activa monitor -> wlan0mon
```

> 💡 **Comprueba que SÍ tengas modo monitor.** Vuelve a correr `iwconfig`: debe aparecer `Mode:Monitor`.
> Si tu tarjeta no soporta modo monitor o **inyección de paquetes**, el *deauth* no llega a los clientes y nunca capturarás el handshake — es la **causa #1 de fallo**.
> Verifica la inyección con: `sudo aireplay-ng --test wlan0mon`

---

## 3. Ejecutar wifite sobre tu red

Prepara el diccionario `rockyou.txt` (para intentar descifrar el handshake de tu propia red después) y lanza `wifite`.

```bash
# Preparar diccionario
cp /usr/share/wordlists/rockyou.txt.gz ~/Desktop/
gunzip ~/Desktop/rockyou.txt.gz        # queda ~/Desktop/rockyou.txt
```

```bash
# Lanzar wifite
sudo wifite --kill --dict ~/Desktop/rockyou.txt

# MEJOR: fija TU red por BSSID y canal para no tocar
# las de nadie más y concentrar el ataque:
sudo wifite --kill --bssid AA:BB:CC:DD:EE:FF --channel 6 --dict ~/Desktop/rockyou.txt
```

Cuando aparezca la lista de redes, escribe **solo el número de tu red** y Enter (**no** `all`).
Déjalo correr mientras un dispositivo tuyo —tu celular— esté conectado a esa red: `wifite` lo desconecta un instante (*deauth*) y, al reconectarse, captura el handshake.

---

## 4. Qué hace cada método de ataque *(lo que pide investigar la práctica)*

| Método | Tipo | Qué hace |
|---|---|---|
| **WPS Pixie-Dust** | `wps` | Ataque *offline* al PIN de WPS. Explota routers que generan los nonces con poca aleatoriedad y permite calcular el PIN en segundos. Solo en modelos vulnerables; los routers modernos ya no lo son. |
| **WPS NULL PIN** | `wps` | Prueba si el router acepta un PIN vacío por un bug de firmware. Muy específico de chipsets antiguos. |
| **WPS PIN Attack** | `wps` | Fuerza bruta de los ~11 000 PINs posibles (el 8.º dígito es checksum). Lento; los routers actuales hacen *lock* del WPS tras varios intentos fallidos → «AP is Locked». |
| **PMKID capture** | `pmkid` | Captura el PMKID del primer mensaje del **AP**, **sin necesidad de clientes conectados**. El método más rápido — pero requiere `hcxpcapngtool` (paquete `hcxtools`). Si falta, se salta. |
| **WPA Handshake** | `wpa` | Captura el *4-way handshake* cuando un cliente se autentica. `wifite` fuerza la reconexión con *deauth*. Con handshake + diccionario se recupera la contraseña *offline*. **Requiere al menos un cliente conectado y buena señal.** |

---

## 5. Por qué no capturaste nada — diagnóstico

Tu salida de `wifite` ya trae todas las pistas:

| Lo que mostró wifite | Qué significa | Cómo corregir |
|---|---|---|
| `Skipping PMKID attack, missing required tools: hcxpcapngtool` | Faltaba `hcxtools`, así que el método más fácil ni se intentó. | `sudo apt install hcxtools hcxdumptool` y relanza. |
| `WPA handshake capture FAILED: Timed out after 300 seconds` | Enviaste *deauth* pero ningún cliente completó el 4-way handshake a tiempo. | Apunta a **una sola** red tuya, acércate al router, ten un dispositivo tuyo conectado. Sube el timeout: `--wpat 120`. |
| Señal saltando **22db ↔ 82db** | Señal muy inestable: estás lejos o la tarjeta/antena es débil; el *deauth* no llega bien. | Acércate al AP; usa un adaptador con buena inyección (chipset Atheros/Ralink). |
| `WPS ... Because access point is Locked` | El router bloqueó WPS tras los intentos fallidos (protección normal). | Espera a que se desbloquee o usa PMKID/handshake. Es un hallazgo válido que documentar. |
| `Pixie-Dust: WPS pin not found` | El AP no es vulnerable a Pixie-Dust (router moderno). | Normal hoy. Documenta que el equipo está parchado. |
| Seleccionaste `all` (10 redes) | Repartiste 300 s entre 10 objetivos ajenos: poco tiempo por red y fuera del alcance ético. | Selecciona **solo el número de tu red**. |

> ✅ **Receta que sí captura un handshake (en tu red):**
> 1. Instala `hcxtools`.
> 2. Modo monitor confirmado + test de inyección.
> 3. `sudo wifite --kill --bssid <tu-bssid> --channel <n> --dict ~/Desktop/rockyou.txt`
> 4. Mantén tu celular conectado a esa red y **cerca** del router.
> 5. Espera a ver `Captured handshake`. (Para probar sin clientes, deja correr el PMKID.)

---

## 6. Restaurar la red al terminar

```bash
sudo airmon-ng stop wlan0mon
sudo systemctl restart NetworkManager
```

---

## 7. Cómo tomar las capturas (Hyprland / Wayland)

En la carpeta de la práctica hay un script listo: **`capturar.sh`**. Guarda cada captura en `evidencias/` con fecha y hora y la copia al portapapeles para pegarla directo en el reporte.

```bash
./capturar.sh              # selecciona una región con el mouse
./capturar.sh full         # toda la pantalla
./capturar.sh paso3        # región, nombrada "paso3_<fecha>.png"
```

**Opcional — atajo de teclado en Hyprland.** Agrega esto a `~/.config/hypr/hyprland.conf` para capturar una región con **Súper + Shift + S** directo al portapapeles:

```conf
bind = SUPER SHIFT, S, exec, grim -g "$(slurp)" - | wl-copy
```

Luego `hyprctl reload` o reinicia la sesión para aplicarlo.

---

*Guía educativa · Redes de Computadoras, UABC · Úsese solo sobre redes propias de prueba.*

---

## 8. Hardware: modo monitor vs. inyección (¡clave!)

El factor que decide si una red "cae" o no suele ser **la tarjeta**, no el comando. Hay dos capacidades distintas:

| Capacidad | Para qué sirve | ¿La tiene una Intel AX200? |
|---|---|---|
| **Modo monitor** | Escuchar/capturar tráfico del aire (pasivo) | ✅ Sí (2.4 y 5 GHz) |
| **Inyección de paquetes** | Enviar *deauth*, forzar handshake, PMKID (activo) | ❌ **No** (driver `iwlwifi`) |

Por eso, con una **Intel AX200/AX210/BE200 interna** puedes *ver* redes pero no *atacarlas* de forma fiable. Para auditoría activa se usa un **adaptador USB externo con inyección**:

- **MediaTek MT7612U** — Alfa AWUS036ACM (doble banda 2.4/5 GHz). El estándar del curso.
- **Atheros AR9271** — Alfa AWUS036NHA (solo 2.4 GHz, muy estable).

### Comprobar tu tarjeta

```bash
lspci -nnk | grep -iA3 net                          # ¿qué chip tienes?
iw list | grep -A5 "Supported interface modes"      # ¿aparece "* monitor"?
sudo aireplay-ng --test wlan0mon                     # ¿funciona la inyección?
```

### Escanear la banda de 5 GHz

Por defecto `wifite` solo ve 2.4 GHz. Para 5 GHz:

```bash
sudo wifite --kill --5ghz
# o manual:
sudo iw dev wlan0mon set channel 36
sudo airodump-ng wlan0mon --band a      # 'a'=5GHz, 'bg'=2.4, 'abg'=ambas
```

> 💡 Si `aireplay-ng --test` falla o el *deauth* no desconecta a tus clientes, tu tarjeta no inyecta: necesitas un adaptador externo. Es exactamente lo que diferencia a la tarjeta interna del adaptador de auditoría del laboratorio.

### 💰 Para los curiosos: qué adaptador comprar y precios (México, 2026)

Lo importante es el **chipset**, no la marca. Precios aproximados —varían según vendedor y tipo de cambio:

| Adaptador / chipset | Bandas | Inyección | Precio aprox. (MXN) | Nota |
|---|---|---|---|---|
| **AR9271 genérico** (Atheros) | 2.4 GHz | ✅ Nativa en Kali | **$200 – $350** | 💡 La mejor relación precio/valor. Sin instalar drivers. |
| **Alfa AWUS036NHA** (AR9271) | 2.4 GHz | ✅ | $500 – $800 | El AR9271 "de marca", más robusto. |
| **Alfa AWUS036ACM** (MT7612U) | 2.4 + **5 GHz** | ✅ | $1,200 – $1,800 | El estándar del curso; doble banda. |
| **Alfa AWUS036ACH** (RTL8812AU) | 2.4 + 5 GHz | ⚠️ Requiere drivers | $1,000 – $1,600 | Potente pero más quisquillosa. |
| RT5370 / clones ultra-baratos | 2.4 GHz | ⚠️ A veces falsa | $80 – $150 | Muchos clones **sin inyección real**. Evitar. |

> ⚠️ **Ojo con los clones:** hay adaptadores que dicen "AR9271" pero traen otro chip y **no inyectan** (se ven en Kali pero el deauth no funciona). Compra AR9271 genuino y verifica con `sudo aireplay-ng --test wlan0mon` al recibirlo.

---

# 📝 Texto listo para el reporte (plantilla: Objetivo · Desarrollo · Conclusiones · Dificultades · Bibliografía)

## Objetivo

Comprender los mecanismos de seguridad de las redes inalámbricas 802.11 (WPA/WPA2 y WPS) mediante una auditoría práctica sobre redes de prueba propias, utilizando la suite `wifite` en Kali Linux. Se busca identificar los distintos vectores de ataque (WPS Pixie-Dust, WPS PIN, PMKID y captura de handshake WPA), ejecutarlos en un entorno controlado y evaluar la resistencia de los equipos ante cada uno.

## Desarrollo

Las pruebas se realizaron sobre redes propias distribuidas en un predio amplio y subdividido, por lo que coexisten varios enlaces de distintos proveedores a los que se tiene acceso autorizado. El procedimiento fue:

1. **Preparación.** Se actualizó el sistema (`apt update`) y se instalaron `wireless-tools`, `aircrack-ng` y las herramientas de captura PMKID (`hcxdumptool`, `hcxtools`).
2. **Modo monitor.** Se activó el modo monitor con `airmon-ng check kill` y `airmon-ng start wlan0`, generando la interfaz `wlan0mon`.
3. **Escaneo.** `wifite` detectó las redes del entorno mostrando ESSID, canal, cifrado (WPA/WPA2-P), potencia (PWR) y estado de WPS.
4. **Ataque.** Se lanzaron los métodos automáticos de `wifite` contra las redes objetivo: WPS Pixie-Dust, WPS NULL PIN, WPS PIN por fuerza bruta, captura PMKID y captura de handshake WPA mediante *deauth* de los clientes.

Cada método corresponde a un vector distinto: los ataques **WPS** intentan recuperar el PIN de configuración del router; el **PMKID** extrae el identificador directamente del AP sin necesidad de clientes; y el **handshake WPA** captura el intercambio de 4 vías (*4-way handshake*) para después intentar descifrar la contraseña de forma *offline* con un diccionario (`rockyou.txt`).

Las pruebas se ejecutaron con **dos configuraciones de hardware** para contrastar resultados:

- **Tarjeta interna Intel Wi-Fi 6 AX200** (driver `iwlwifi`): soporta modo monitor en 2.4 y 5 GHz, pero **no soporta inyección de paquetes**, limitación conocida del driver de Intel.
- **Adaptador USB externo de auditoría** (tipo Alfa/MediaTek, con inyección soportada, facilitado por el docente): permite enviar *deauth* de forma confiable y, por tanto, forzar la captura del handshake.

## Conclusiones

La práctica permitió observar que el **factor determinante del éxito fue el hardware de captura**, más que el método de ataque en sí:

- Con la **tarjeta interna Intel AX200 no se logró vulnerar ninguna red**: al no soportar inyección, los paquetes *deauth* no llegaban de forma fiable a los clientes y la captura del handshake agotaba el tiempo límite (300 s). Los ataques WPS tampoco prosperaron — *«WPS pin not found»* (router no vulnerable a Pixie-Dust) y *«access point is Locked»* (bloqueo de WPS tras varios intentos), ambos indicadores de equipos correctamente protegidos.
- Con el **adaptador USB externo de auditoría** (con inyección soportada) **sí se capturó el handshake WPA de una red TP-Link y se descifró con el diccionario** `rockyou.txt` en poco tiempo, al tratarse de una contraseña débil presente en la lista.

En conjunto se concluye que: (1) la **inyección de paquetes es un requisito indispensable** para los ataques activos de 802.11, y una tarjeta sin ese soporte (como la Intel AX200) solo sirve para escucha pasiva; (2) un router con **WPS bloqueado y firmware actualizado** resiste bien los ataques WPS; y (3) frente al handshake WPA la defensa real es una **contraseña robusta**, ya que una débil cae de inmediato ante un ataque de diccionario, como demostró el caso de la red TP-Link.

## Dificultades

- **Limitación principal — la tarjeta Intel AX200 no soporta inyección** (driver `iwlwifi`). Aunque hace modo monitor, no puede enviar *deauth* de forma fiable, por lo que no se capturó ningún handshake con ella. Se resolvió usando el adaptador USB externo de auditoría, del que **solo se contaba con una unidad en el laboratorio**, por lo que hubo que turnarlo entre equipos.
- **Faltó la herramienta `hcxpcapngtool`** (del paquete `hcxtools`), por lo que `wifite` saltó por completo el ataque PMKID (*«Skipping PMKID attack, missing required tools»*). Se resolvió instalando `hcxtools`.
- **No se detectaban redes de 5 GHz:** por defecto `wifite` solo escanea la banda de 2.4 GHz; hay que indicar la bandera `--5ghz`. Además, la AX200 no expone banda de 6 GHz, por lo que WiFi 6E/7 queda fuera del alcance.
- **Crash de WPS en wifite** (`'NoneType' object has no attribute 'poll'`): un subproceso de `reaver`/`bully` murió y abortó la cadena de ataques de esa red antes de llegar a los demás métodos. Se evita con `--no-wps` para ir directo a PMKID/handshake.
- **Selección de objetivos demasiado amplia:** al elegir `all` el tiempo de captura se repartió entre muchas redes, dejando pocos segundos efectivos por objetivo. La corrección fue fijar una sola red por BSSID y canal.

## Bibliografía

- Kurose, J. F. y Ross, K. W. (2017). *Redes de computadoras: un enfoque descendente* (7.ª ed.). Pearson.
- Tanenbaum, A. S. y Wetherall, D. J. (2012). *Redes de computadoras* (5.ª ed.). Prentice Hall.
- IEEE. (2020). *IEEE Std 802.11-2020 — Wireless LAN Medium Access Control (MAC) and Physical Layer (PHY) Specifications*.
- Kali Linux. *wifite — Documentation*. https://www.kali.org/tools/wifite/
- Aircrack-ng. *aircrack-ng suite documentation*. https://www.aircrack-ng.org/documentation.html
