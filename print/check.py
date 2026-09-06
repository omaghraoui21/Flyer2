"""Contrôle prépresse : format, boîte de coupe, résolution des images, rendus 300 dpi.
usage : check.py <pdf> <pages> <largeur mm> <hauteur mm> [préfixe des rendus]"""
import sys
import pymupdf

path, pages, W, H = sys.argv[1], int(sys.argv[2]), float(sys.argv[3]), float(sys.argv[4])
render_prefix = sys.argv[5] if len(sys.argv) > 5 else None
doc = pymupdf.open(path)
assert len(doc) == pages, f"{len(doc)} pages (attendu {pages})"
mm = lambda pt: pt / 72 * 25.4
bleed = 3 / 25.4 * 72
print(f"== {path}")
for i, page in enumerate(doc, 1):
    w, h = mm(page.rect.width), mm(page.rect.height)
    assert abs(w - W) < 0.5 and abs(h - H) < 0.5, f"format {w:.1f}x{h:.1f} mm (attendu {W}x{H})"
    # TrimBox = format fini centré dans le fond perdu de 3 mm
    page.set_trimbox(pymupdf.Rect(bleed, bleed, page.rect.width - bleed, page.rect.height - bleed))
    print(f"page {i}: {w:.1f} x {h:.1f} mm, trim {W-6:.0f} x {H-6:.0f}")
    for img in page.get_images(full=True):
        xref = img[0]
        info = doc.extract_image(xref)
        for r in page.get_image_rects(xref):
            dpi = info["width"] / (mm(r.width) / 25.4)
            flag = "" if dpi >= 250 else "  <- faible (recommandé >= 250 dpi)"
            print(f"   image {info['width']}x{info['height']} px sur {mm(r.width):.0f} mm = {dpi:.0f} dpi{flag}")
    if render_prefix:
        page.get_pixmap(dpi=300).save(f"{render_prefix}-page-{i}.png")
doc.save(path, incremental=True, encryption=pymupdf.PDF_ENCRYPT_KEEP)
