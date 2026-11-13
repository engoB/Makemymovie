@AGENTS.md

# Makemymovie : règles propres à ce repo (prioritaires sur AGENTS.md)

Ce repo est une copie personnalisée de la bibliothèque Lemo-Opuscar. Les règles ci-dessous passent avant celles d'`AGENTS.md` quand elles se contredisent.

## Langue
- Parle **toujours en français** avec l'utilisateur. Ne pose pas la question de la langue : c'est le français.
- Les films sont en français par défaut : voix off, textes à l'écran et sous-titres.
- Voix off française :
  - par défaut, **Kokoro hors ligne**, voix féminine `ff_siwis` avec `"lang": "fr-fr"` (`core/tts/tts.py`) ;
  - pour une voix d'homme, ou si l'utilisateur veut une voix plus naturelle : edge-tts en ligne (`core/tts/tts_zh.py`, voix `fr-FR-HenriNeural`, `fr-FR-DeniseNeural`…). Préviens-le qu'il s'agit d'un service en ligne de Microsoft.
- Contrôle de la voix : `core/tts/asr_check.py` en langue `fr`, avec un modèle multilingue.

## Démarrage d'une session (cloud)
1. Lance `sh tools/preparer.sh` depuis la racine du repo, en arrière-plan dès le début. Ce script installe ffmpeg 7 s'il manque, ainsi que les paquets core, voice et music. S'il ne manque rien, il ne fait presque rien.
2. Dans ce repo, **`~/lemo-my-styles/` désigne `mes-styles/`** : `preparer.sh` crée le lien. Les styles personnels sont donc versionnés dans `mes-styles/`.

## Demandes venant de l'interface « Studio »
L'utilisateur colle souvent un message généré par le Studio (GitHub Pages, `studio/`). Le message commence par `🎬 Nouvelle demande de film`. Toute option absente est à fixer avec un choix par défaut raisonnable. Si `Questions : non` y figure, ne pose aucune question et lance directement la production.

## Où vont les fichiers
- Projet du film : `films/<nom>/` (minuscules, chiffres, tirets). Le code du film est versionné ; les rendus lourds sont ignorés par `.gitignore`.
- **Film terminé** : copie la version finale dans `mes-films/<nom>.mp4`.
  - Elle doit rester **sous 45 Mo**, la limite de GitHub étant de 100 Mo. Si elle dépasse, ré-encode-la en H.264 (CRF 23 à 28, `-movflags +faststart`), et descends en 720p seulement si c'est nécessaire.
  - Ajoute aussi une affiche `mes-films/<nom>.jpg` (une image représentative, 1280 px de large).
- Ajoute ensuite une entrée **en tête** de `mes-films/films.json` :
  `{"nom": "<nom>", "titre": "...", "style": "<slug>", "duree": <secondes>, "date": "AAAA-MM-JJ", "resume": "une phrase"}`
- Puis **commit et push sur `main`**. Le site Studio se met à jour tout seul et le film apparaît dans « Mes films ». Le conteneur cloud est effacé à la fin de la session : ce qui n'est pas poussé est perdu. Pousse donc aussi le code du film en cours si la session s'arrête avant la fin.

## Ne pas modifier
`core/`, `styles/`, `styleboard/` et les guides (`AGENTS.md`, `DIRECTOR.md`, `TECHNIQUE.md`, `MY-STYLES.md`) viennent de la bibliothèque d'origine. `tools/maj-bibliotheque.sh` les remplace à chaque mise à jour, donc toute modification faite là sera perdue. Pour personnaliser, passe par `mes-styles/` ou par ce fichier.
