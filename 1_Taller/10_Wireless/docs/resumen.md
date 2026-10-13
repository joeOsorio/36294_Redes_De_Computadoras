# Resumen — Práctica 10 (Redes Inalámbricas)

Recopilación de todo lo trabajado y descubierto en la práctica de auditoría WiFi 802.11 con `wifite` en Kali Linux.

---

## 🎯 En una línea

El intento de auditoría "falló" no por errores de procedimiento, sino porque la **tarjeta interna Intel AX200 no soporta inyección de paquetes**. Con un **adaptador USB externo de auditoría** sí se capturó y descifró el handshake de una red TP-Link.

---

## 🔍 Diagnóstico de por qué no se vulneró nada (con la tarjeta interna)

| Síntoma en wifite | Causa real | Solución |
|---|---|---|
| `Skipping PMKID attack, missing required tools: hcxpcapngtool` | Faltaba el paquete `hcxtools` | `sudo apt install hcxtools hcxdumptool` |
| `WPA handshake capture FAILED: Timed out after 300 s` | La Intel AX200 **no inyecta** → el deauth no forzaba la reconexión | Usar adaptador externo con inyección |
| Señal saltando 22–82 db | Distancia / antena interna débil | Acercarse al AP |
| `WPS ... access point is Locked` | El router bloquea WPS tras intentos (protección normal) | Hallazgo válido; usar PMKID/handshake |
| `Pixie-Dust: WPS pin not found` | Router moderno no vulnerable | Hallazgo válido |
| `'NoneType' object has no attribute 'poll'` | Bug de wifite: murió el subproceso de reaver/bully | `--no-wps` para saltar WPS |
| Solo veía redes 2.4 GHz | wifite solo escanea 2.4 por defecto | `--5ghz` (y la AX200 no expone 6 GHz) |
| Se eligió `all` (10 redes) | Tiempo repartido entre demasiados objetivos | Fijar una sola red por `--bssid` + `--channel` |

---

## 🖥️ Hallazgo clave: hardware (modo monitor ≠ inyección)

**Tarjeta detectada:** `Intel Corporation Wi-Fi 6 AX200 [8086:2723]`, driver `iwlwifi`.

| Capacidad | AX200 interna |
|---|---|
| Modo monitor (escucha pasiva) 2.4/5 GHz | ✅ Sí |
| **Inyección** (deauth, PMKID, forzar handshake) | ❌ **No** (limitación de Intel) |
| Banda 6 GHz (WiFi 6E/7) | ❌ No expuesta |

➡️ Para ataques activos se necesita un adaptador externo con inyección soportada.

### Qué comprar (México, 2026)
| Adaptador / chipset | Bandas | Precio aprox. |
|---|---|---|
| **AR9271 genérico** (mejor precio/valor) | 2.4 GHz | $200–350 MXN |
| Alfa AWUS036NHA (AR9271) | 2.4 GHz | $500–800 MXN |
| **Alfa AWUS036ACM (MT7612U)** — doble banda | 2.4 + 5 GHz | $1,200–1,800 MXN |

⚠️ Cuidado con clones que dicen "AR9271" y no inyectan. Verificar con `sudo aireplay-ng --test wlan0mon`.

---

## ⚙️ Comandos clave (flujo correcto)

```bash
# 1. Preparación
sudo apt update
sudo apt install -y wireless-tools aircrack-ng hcxdumptool hcxtools

# 2. Modo monitor
sudo airmon-ng check kill
sudo airmon-ng start wlan0

# 3. Diccionario
cp /usr/share/wordlists/rockyou.txt.gz ~/Desktop/ && gunzip ~/Desktop/rockyou.txt.gz

# 4. Atacar UNA red propia (sin atorarse en WPS)
sudo wifite --kill --no-wps --bssid <TU_BSSID> --channel <n> --dict ~/Desktop/rockyou.txt

# 5. Restaurar
sudo airmon-ng stop wlan0mon
sudo systemctl restart NetworkManager
```

---

## 📸 Capturas de pantalla (Hyprland / Wayland)

- Script de la práctica: `../capturar.sh` → guarda en `../evidencias/` y copia al portapapeles.
  - `./capturar.sh` (región) · `./capturar.sh full` · `./capturar.sh <nombre>`
- Atajos del sistema configurados en `~/.config/hypr/hyprland.conf`:
  - **Súper + Shift + S** → menú de captura (región / pantalla / ventana) — script `~/.local/bin/captura-menu.sh`
  - **Súper + Shift + V** → historial de portapapeles con GUI (CopyQ)

---

## 📁 Entregables generados

| Archivo | Qué es |
|---|---|
| `docs/Practica10_Guia.md` | Guía completa paso a paso (para compañeros) |
| `docs/resumen.md` | Este resumen |
| `Reporte_Practica10.docx` | Reporte formal (Objetivo · Desarrollo · Conclusiones · Dificultades · Bibliografía) |
| `capturar.sh` | Script de capturas |
| `evidencias/` | Carpeta para las capturas |
| Guía en HTML | https://claude.ai/artifact/QfcQvM1qjF9Gm66WHfj33c |

### Pendientes manuales
- En el `.docx`: completar **Docente**, actualizar la **tabla de contenido** (F9) y pegar capturas.
- Instalar CopyQ: `sudo apt install -y copyq` y `hyprctl reload`.

---

## ✅ Conclusión para el reporte

La inyección de paquetes es indispensable para los ataques activos de 802.11. Una tarjeta sin ese soporte (Intel AX200) solo sirve para escucha pasiva. Los routers con WPS bloqueado y firmware actualizado resisten bien; la defensa real frente al handshake WPA es una **contraseña robusta**, ya que una débil cae de inmediato ante un ataque de diccionario (caso TP-Link).
