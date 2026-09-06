#!/usr/bin/env bash
# Génère les livrables d'impression (PDF sRGB + PDF/X-3 CMJN FOGRA39 + aperçus 300 dpi).
#   ./build.sh            -> flyer A5 (index.html) et étiquette ascenseur A6 (etiquette.html)
#   ./build.sh flyer | etiquette | carree  -> un seul support
set -euo pipefail
cd "$(dirname "$0")"

CHROME="${CHROME:-$(command -v google-chrome || command -v chromium || command -v chromium-browser || ls "$HOME"/.agent-browser/browsers/chrome-*/chrome 2>/dev/null | head -1)}"
[ -x "$CHROME" ] || { echo "Chrome/Chromium introuvable (définir CHROME=...)"; exit 1; }
ICC="${ICC:-/usr/share/color/icc/ISOcoated_v2_300_eci.icc}"   # paquet Debian icc-profiles
mkdir -p renders

# build <html> <nom de base> <pages> <largeur mm> <hauteur mm>
build() {
  local html=$1 base=$2 pages=$3 w=$4 h=$5
  local rgb="${base}_RVB.pdf" cmyk="${base}_PRINT_CMJN.pdf"
  "$CHROME" --headless=new --no-sandbox --disable-gpu --run-all-compositor-stages-before-draw \
    --no-pdf-header-footer --print-to-pdf="$rgb" "file://$PWD/$html" 2>/dev/null
  python3 print/check.py "$rgb" "$pages" "$w" "$h" "renders/${base#Paletto_Studio_}"
  if command -v gs >/dev/null && [ -f "$ICC" ]; then
    gs -q -dBATCH -dNOPAUSE -dSAFER -sDEVICE=pdfwrite \
       -dPDFX --permit-file-read="$(dirname "$ICC")/" -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK \
       -sOutputICCProfile="$ICC" -dRenderIntent=1 -dBlackPtComp=1 \
       -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -dSubsetFonts=true \
       -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -dDownsampleColorImages=false \
       -sOutputFile="$cmyk" print/PDFX_def.ps "$rgb"
    python3 print/check.py "$cmyk" "$pages" "$w" "$h"
  fi
}

target="${1:-all}"
[ "$target" = all ] || [ "$target" = flyer ]     && build index.html     Paletto_Studio_Flyer_A5      2 154 216
[ "$target" = all ] || [ "$target" = etiquette ] && build etiquette.html Paletto_Studio_Etiquette_A6  1 111 154
[ "$target" = all ] || [ "$target" = carree ]    && build etiquette-carree.html Paletto_Studio_Etiquette_Carree_100 1 106 106
ls -la Paletto_Studio_*.pdf renders/
