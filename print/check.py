"""Contrôle prépresse : format, boîte de coupe, polices incorporées, résolution des images, rendus 300 dpi."""
import sys
import pymupdf

path = sys.argv[1]
doc = pymupdf.open(path)
assert len(doc) == 2, f"{len(doc)} pages (attendu 2)"
mm = lambda pt: pt / 72 * 25.4
bleed = 3 / 25.4 * 72
print(f"== {path}")
for i, page in enumerate(doc, 1):
    w, h = mm(page.rect.width), mm(page.rect.height)
    assert abs(w - 154) < 0.5 and abs(h - 216) < 0.5, f"format {w:.1f}x{h:.1f} mm"
    # TrimBox = A5 148 x 210 centré dans le fond perdu de 3 mm
    page.set_trimbox(pymupdf.Rect(bleed, bleed, page.rect.width - bleed, page.rect.height - bleed))
    fonts = {f[3] for f in page.get_fonts()}
    print(f"page {i}: {w:.1f} x {h:.1f} mm, trim 148 x 210 · polices : {', '.join(sorted(fonts))}")
    for img in page.get_images(full=True):
        xref = img[0]
        info = doc.extract_image(xref)
        for r in page.get_image_rects(xref):
            dpi = info["width"] / (mm(r.width) / 25.4)
            flag = "" if dpi >= 250 else "  <- faible (recommandé >= 250 dpi)"
            print(f"   image {info['width']}x{info['height']} px sur {mm(r.width):.0f} mm = {dpi:.0f} dpi{flag}")
    if "RVB" in path:
        page.get_pixmap(dpi=300).save(f"renders/page-{i}.png")
doc.save(path, incremental=True, encryption=pymupdf.PDF_ENCRYPT_KEEP)
