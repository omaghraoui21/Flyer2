# Paletto Studio - Flyer saison 2026-2027

Flyer A4 recto/verso, prêt pour l'impression, construit en HTML/CSS et rendu en PDF.

## Livrables
- `Paletto_Studio_Flyer_Print.pdf` : PDF 2 pages, 216 x 303 mm (A4 + 3 mm de fond perdu), RVB, polices incorporées.
- `Paletto_Studio_Flyer_Print_CMYK.pdf` : même fichier converti en CMJN (Ghostscript, profil prepress) pour l'imprimeur.
- `renders/page-1.png`, `renders/page-2.png` : aperçus 300 dpi.
- `index.html` + `styles.css` : source éditable.
- `assets/brand/` : logo vectoriel (SVG), symbole, QR WhatsApp, mini-charte graphique.
- `assets/photos/` : photo du studio + 6 vignettes disciplines.
- `assets/fonts/` : Fraunces et Work Sans (polices de la charte, variables, licence OFL).

## Regénérer
```sh
./build.sh          # nécessite Chrome/Chromium (var CHROME=...), python3 + pymupdf, ghostscript (optionnel)
```

## Choix DA (conformes à la mini-charte)
- Logo recomposé en vecteur à partir des tracés officiels (`paletto_logo_email.svg`) : net à toute taille, plus de PNG au fond crème collé.
- Typographie de la charte : Fraunces (titres, numéros, téléphone) + Work Sans (texte, légendes).
- Palette officielle uniquement : crème, terracotta, sauge profonde, sauge, ocre.
- Blocs contact recto (terracotta) et verso (sauge profonde) à fond perdu : le flyer tient les bords après coupe.
- QR code toujours isolé sur blanc pur, taille 40 mm, jamais sur photo.
- Numéro sans indicatif, réseaux Instagram @palettostudio.tn et Facebook Paletto Studio, slogan « Créer librement, briller autrement. »
- Vignettes disciplines rognées pour supprimer les angles arrondis et bords crème incrustés dans les fichiers sources ; filet fin + ombre légère pour détacher la photo du fond.
- Zone de sécurité 12 mm à l'intérieur du format fini.

## Impression
- Format de page : 216 x 303 mm, coupe A4 210 x 297 mm centrée, 3 mm de fond perdu sur les 4 côtés.
- Ne pas redimensionner ("taille réelle" / 100 %).
- Utiliser le fichier CMYK si l'imprimeur l'exige, sinon le fichier RVB avec conversion par l'imprimeur.
