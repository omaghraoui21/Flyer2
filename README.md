# Paletto Studio - Supports imprimés saison 2026-2027

Flyer A5 recto/verso et trois étiquettes (ascenseur A6, carrée, rectangulaire), prêts pour l'impression, construits en HTML/CSS et rendus en PDF.

## Livrables
### Flyer A5
- **`Paletto_Studio_Flyer_A5_PRINT_CMJN.pdf`** : fichier à envoyer à l'imprimeur. PDF/X-3:2002, CMJN, intention de sortie ISO Coated v2 300 % (FOGRA39, papier couché), TrimBox 148 x 210 mm, fond perdu 3 mm, texte et logo vectoriels, sans transparence.
- `Paletto_Studio_Flyer_A5_RVB.pdf` : même flyer en sRGB (écran, envoi WhatsApp/mail, impression numérique de bureau).
- `renders/Flyer_A5-page-1.png`, `renders/Flyer_A5-page-2.png` : aperçus 300 dpi.
- `index.html` + `styles.css` : source éditable.

### Étiquettes (brief marketing : `print/BRIEF_ETIQUETTES.md`)
Feuille de style commune `etiquettes.css` ; chaque support = un HTML éditable, un PDF/X-3 CMJN FOGRA39 (`_PRINT_CMJN.pdf`, TrimBox déclarée, fond perdu 3 mm, 100 % vectoriel) et un PDF sRGB (`_RVB.pdf`), aperçu 300 dpi dans `renders/`.

| Support | Fichier | Format fini | Accroche | Lieu |
|---|---|---|---|---|
| Ascenseur A6 | `etiquette.html` -> `Paletto_Studio_Etiquette_A6_*` | 105 x 148 mm, sécurité 6 mm | « Et si vous preniez le temps de créer ? » | Paroi / miroir d'ascenseur, lecture à 1-2 m |
| Carrée | `etiquette-carree.html` -> `Paletto_Studio_Etiquette_Carree_100_*` | 100 x 100 mm, sécurité 5 mm | « L'art, à deux pas d'ici. » | Caisse, porte de boutique partenaire |
| Rectangulaire | `etiquette-rect.html` -> `Paletto_Studio_Etiquette_Rect_210x74_*` | 210 x 74 mm, sécurité 5 mm | « Il y a un artiste en vous. Venez le rencontrer. » | Porte vitrée, comptoir |

- `assets/brand/qr-wa-me-21626695707.svg` : QR généré techniquement (segno, version 2, correction M, 25 modules) vers `https://wa.me/21626695707`, sans logo central, 4 modules de zone blanche sur blanc pur (35 mm en A6, 30 mm carrée, 32 mm rectangulaire). Scan vérifié par décodage OpenCV de chaque PDF CMJN rendu à 72, 150 et 300 dpi.
- Une seule action par support (scanner / WhatsApp), aucun prix ni offre.

### Commun
- `print/` : définition PDF/X (`PDFX_def.ps`) et contrôle prépresse (`check.py`).
- `assets/brand/` : logo vectoriel (SVG), symbole, QR WhatsApp, mini-charte graphique.
- `assets/photos/` : photo du studio + 5 vignettes ateliers.
- `assets/fonts/` : Fraunces et Work Sans (polices de la charte, variables, licence OFL).

## Regénérer
```sh
sudo apt-get install -y ghostscript icc-profiles   # profil ISO Coated v2 300% (ECI)
pip install pymupdf segno
./build.sh [flyer|etiquette|carree|rect]   # nécessite Chrome/Chromium (var CHROME=...)
```

## Audit prépresse (fait le 2026-09-06)
Conversion sRGB -> ISO Coated v2 300 % (relatif colorimétrique, compensation du point noir) :

| Couleur charte | HEX | CMJN obtenu | Encrage | Écart aller-retour |
|---|---|---|---|---|
| Crème | #F5EFE6 | C5 M6 J11 N0 | 22 % | ΔE 0,0 |
| Terracotta | #C4553B | C10 M73 J74 N15 | 172 % | ΔE 0,0 |
| Ocre | #D9A441 | C8 M33 J79 N11 | 131 % | ΔE 0,0 |
| Sauge | #9CAF88 | C40 M15 J49 N10 | 114 % | ΔE 1,4 |
| Sauge profonde | #5F7052 | C54 M29 J62 N39 | 184 % | ΔE 0,0 |
| Encre | #221E19 | C65 M60 J62 N81 | 268 % | ΔE 0,0 |

Toutes les couleurs sont dans le gamut offset (ΔE < 2 = invisible à l'œil) ; encrage maximal 268 % < 300 %. Aucun aplat ne sera terni à l'impression.

Autres contrôles : format 154,2 x 215,9 mm ; textes 100 % vectoriels ; plus petit corps 5,8 pt (légende QR) ; QR 32 mm sur blanc pur ; photo héro 270 dpi ; QR 1 259 dpi. Point faible connu : les 5 vignettes ateliers sont à ~155 dpi (sources ~190 px) ; remplacer par des fichiers >= 400 px de large pour atteindre 300 dpi.

## Choix DA (conformes à la mini-charte)
- Logo officiel complet (`paletto_logo_email.svg`, géométrie inchangée) réutilisé en vecteur : 70 mm au recto, 60 mm au verso.
- Typographie de la charte : Fraunces (titres, numéros, téléphone) + Work Sans (informations).
- Palette officielle uniquement : crème, terracotta, sauge profonde, sauge, ocre, encre.
- Bandeaux contact recto (terracotta) et verso (sauge profonde) : aplats rectangulaires à fond perdu, bord supérieur droit, fleur d'atelier en filigrane.
- QR code isolé sur carré blanc à coins droits, jamais sur photo.
- Slogan « Créez librement, brillez autrement. », numéro sans indicatif, Instagram @palettostudio.tn, Facebook Paletto Studio, mention « Enfants · Adolescents · Adultes ».
- Cinq ateliers (Manga & BD fusionnés) et une carte Co-Art space pour les artistes indépendants.
- Vignettes : rayon unique 1,2 mm, filet fin, aucune ombre ; bords crème incrustés rognés à la source.
- Zone de sécurité 6 mm à l'intérieur du format fini.

## Consignes imprimeur
- Fichier : `Paletto_Studio_Flyer_A5_PRINT_CMJN.pdf`, 2 pages (recto, verso), 154 x 216 mm avec TrimBox A5 148 x 210 mm centrée, fond perdu 3 mm sur les 4 côtés, sans traits de coupe (les ajouter côté imposition si nécessaire).
- Impression 100 % (ne pas redimensionner), recto/verso, papier couché 250-350 g conseillé, profil FOGRA39.
- Ne pas reconvertir les couleurs : le fichier est déjà en CMJN avec intention de sortie déclarée.
