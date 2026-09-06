#!/usr/bin/env bash
# Génère les livrables d'impression à partir de index.html.
#   renders/page-1.png, renders/page-2.png  : aperçus 300 dpi (RVB)
#   Paletto_Studio_Flyer_Print.pdf          : PDF 216x303 mm, RVB, polices incorporées
#   Paletto_Studio_Flyer_Print_CMYK.pdf     : même PDF converti en CMJN (Ghostscript)
set -euo pipefail
cd "$(dirname "$0")"

CHROME="${CHROME:-$(command -v google-chrome || command -v chromium || command -v chromium-browser || ls "$HOME"/.agent-browser/browsers/chrome-*/chrome 2>/dev/null | head -1)}"
[ -x "$CHROME" ] || { echo "Chrome/Chromium introuvable (définir CHROME=...)"; exit 1; }

mkdir -p renders
URL="file://$PWD/index.html"

"$CHROME" --headless=new --no-sandbox --disable-gpu --run-all-compositor-stages-before-draw \
  --no-pdf-header-footer --print-to-pdf="Paletto_Studio_Flyer_Print.pdf" "$URL" 2>/dev/null

python3 - "$@" <<'PY'
import pymupdf
doc = pymupdf.open("Paletto_Studio_Flyer_Print.pdf")
assert len(doc) == 2, f"{len(doc)} pages (attendu 2)"
for i, page in enumerate(doc, 1):
    w, h = page.rect.width / 72 * 25.4, page.rect.height / 72 * 25.4
    print(f"page {i}: {w:.1f} x {h:.1f} mm")
    page.get_pixmap(dpi=300).save(f"renders/page-{i}.png")
PY

if command -v gs >/dev/null; then
  gs -q -dBATCH -dNOPAUSE -dSAFER -sDEVICE=pdfwrite \
     -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK \
     -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -dSubsetFonts=true \
     -sOutputFile=Paletto_Studio_Flyer_Print_CMYK.pdf Paletto_Studio_Flyer_Print.pdf
  echo "CMYK: Paletto_Studio_Flyer_Print_CMYK.pdf"
fi
ls -la Paletto_Studio_Flyer_Print*.pdf renders/
