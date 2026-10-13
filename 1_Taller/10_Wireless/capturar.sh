#!/usr/bin/env bash
# capturar.sh — Capturas de pantalla para la Práctica 10 (Wireless)
# Entorno: Hyprland / Wayland  —  usa grim + slurp + wl-copy
#
# Uso:
#   ./capturar.sh            -> selecciona una región con el mouse
#   ./capturar.sh full       -> captura toda la pantalla
#   ./capturar.sh region     -> igual que sin argumentos (región)
#   ./capturar.sh <nombre>   -> región, y nombra el archivo con <nombre>
#
# Cada captura:
#   - se guarda en ./evidencias/ con fecha y hora (o el nombre que des)
#   - se copia también al portapapeles para pegarla directo en el reporte

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/evidencias"
mkdir -p "$DIR"

STAMP="$(date +%Y-%m-%d_%H-%M-%S)"
MODE="${1:-region}"

case "$MODE" in
  full)
    NAME="captura_${STAMP}.png"
    grim "$DIR/$NAME"
    ;;
  region|"")
    NAME="captura_${STAMP}.png"
    GEOM="$(slurp)" || { echo "Selección cancelada."; exit 1; }
    grim -g "$GEOM" "$DIR/$NAME"
    ;;
  *)
    # Cualquier otro texto se usa como nombre del archivo (región)
    NAME="${MODE}_${STAMP}.png"
    GEOM="$(slurp)" || { echo "Selección cancelada."; exit 1; }
    grim -g "$GEOM" "$DIR/$NAME"
    ;;
esac


# Copiar la imagen al portapapeles
wl-copy --type image/png < "$DIR/$NAME"

echo "✔ Guardada: evidencias/$NAME"
echo "✔ Copiada al portapapeles (Ctrl+V en el reporte)"
