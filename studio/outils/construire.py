"""Construit studio/styles.json (et les vignettes manquantes) à partir de styles/*/style.json et studio/outils/fr.json.
   python3 studio/outils/construire.py      depuis la racine du repo
Un style nouveau sans nom français garde son nom anglais (ajoute-le dans fr.json)."""
import json, glob, os, sys

CATS = {"Edit & Documentary": "Montage & documentaire", "Painting & Illustration": "Peinture & illustration",
        "Sketch & Board": "Croquis & tableau", "Traditional Crafts": "Artisanats traditionnels",
        "Print & Printmaking": "Impression & gravure", "Graphic & Type": "Graphisme & typographie",
        "Line Diagrams": "Schémas au trait", "Cartoons": "Dessins animés", "Games": "Jeux vidéo",
        "Film & Tape": "Pellicule & vidéo", "Screens & Interfaces": "Écrans & interfaces",
        "Light & Lines": "Lumière & lignes", "3D & Miniature": "3D & miniature",
        "Instruments & Evidence": "Instruments & preuves", "Data & Maps": "Données & cartes"}
order = list(CATS)
fr = json.load(open('studio/outils/fr.json', encoding='utf-8'))
out, missing = [], []
for f in glob.glob('styles/*/style.json'):
    j = json.load(open(f, encoding='utf-8'))
    s = j['slug']
    if s == 'my-style' or j.get('category_en') not in CATS:
        continue
    if s not in fr:
        missing.append(s)
    name, pour = fr.get(s, [j['en'], ', '.join(j.get('uses', [])[:2])])
    out.append(dict(slug=s, fr=name, pour=pour, en=j['en'], cat=CATS[j['category_en']],
                    _o=(order.index(j['category_en']), int(j.get('num', 0) or 0)),
                    dur=round(j.get('dur', 0) or 0), img='image-generation' in j.get('needs', [])))
    thumb = f'studio/vignettes/{s}.webp'
    poster = f'styles/{s}/poster.jpg'
    if not os.path.exists(thumb) and os.path.exists(poster):
        from PIL import Image
        im = Image.open(poster).convert('RGB'); im.thumbnail((480, 480)); im.save(thumb, 'WEBP', quality=72, method=6)
out.sort(key=lambda x: x['_o'])
for o in out:
    del o['_o']
json.dump(dict(categories=list(CATS.values()), styles=out), open('studio/styles.json', 'w', encoding='utf-8'),
          ensure_ascii=False, separators=(',', ':'))
print(f'{len(out)} styles' + (f' · sans nom français : {", ".join(missing)}' if missing else ''))
sys.exit(0)
