#!/usr/bin/env bash
# Génère les livrables d'impression à partir de index.html.
#   renders/page-1.png, renders/page-2.png       : aperçus 300 dpi (RVB)
#   Paletto_Studio_Flyer_A5_RVB.pdf              : PDF 154x216 mm (A5 + 3 mm fond perdu), sRGB, polices incorporées
#   Paletto_Studio_Flyer_A5_PRINT_CMJN.pdf       : PDF/X-3 CMJN, profil ISO Coated v2 300% (FOGRA39) - fichier à envoyer à l'imprimeur
set -euo pipefail
cd "$(dirname "$0")"

CHROME="${CHROME:-$(command -v google-chrome || command -v chromium || command -v chromium-browser || ls "$HOME"/.agent-browser/browsers/chrome-*/chrome 2>/dev/null | head -1)}"
[ -x "$CHROME" ] || { echo "Chrome/Chromium introuvable (définir CHROME=...)"; exit 1; }
ICC="${ICC:-/usr/share/color/icc/ISOcoated_v2_300_eci.icc}"   # paquet Debian icc-profiles

mkdir -p renders
URL="file://$PWD/index.html"
RGB=Paletto_Studio_Flyer_A5_RVB.pdf
CMYK=Paletto_Studio_Flyer_A5_PRINT_CMJN.pdf

"$CHROME" --headless=new --no-sandbox --disable-gpu --run-all-compositor-stages-before-draw \
  --no-pdf-header-footer --print-to-pdf="$RGB" "$URL" 2>/dev/null

python3 print/check.py "$RGB"

if command -v gs >/dev/null && [ -f "$ICC" ]; then
  gs -q -dBATCH -dNOPAUSE -dSAFER -sDEVICE=pdfwrite \
     -dPDFX --permit-file-read="$(dirname "$ICC")/" -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK \
     -sOutputICCProfile="$ICC" -dRenderIntent=1 -dBlackPtComp=1 \
     -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -dSubsetFonts=true \
     -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -dDownsampleColorImages=false \
     -sOutputFile="$CMYK" print/PDFX_def.ps "$RGB"
  python3 print/check.py "$CMYK"
fi
ls -la Paletto_Studio_Flyer_A5_*.pdf renders/
