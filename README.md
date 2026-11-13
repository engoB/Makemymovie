# Makemymovie

Mon studio de films explicatifs, réalisés **entièrement en code** par Claude : images, voix off française, musique originale et montage.
Basé sur la bibliothèque [Lemo-Opuscar](https://github.com/lemomo-ai/lemo-opuscar), qui propose 99 styles. Sa documentation d'origine est dans [README.lemo-opuscar.md](README.lemo-opuscar.md).

## Faire un film

1. Ouvrir le **Studio** : https://engob.github.io/Makemymovie/
2. Écrire le sujet, choisir un style (ou laisser Claude choisir), régler les options si besoin.
3. Cliquer sur **Copier et ouvrir Claude**. Dans Claude Code, choisir le repo `engoB/Makemymovie`, coller la demande et l'envoyer.
4. Attendre 30 à 60 minutes. Le film terminé apparaît dans l'onglet **Mes films**.

On peut aussi écrire directement dans Claude Code :

> Fais un film d'une minute dans le style Whiteboard Explainer sur le fonctionnement du GPS.

Conseil : tapez `/effort high` au début de la session pour un meilleur résultat.

## Organisation du repo

| Dossier / fichier | Rôle |
|---|---|
| `CLAUDE.md` | **Mes règles pour Claude** : français, voix, publication des films. C'est l'endroit à modifier pour personnaliser. |
| `studio/` | L'interface (GitHub Pages). Noms français des styles : `studio/outils/fr.json`. |
| `films/<nom>/` | Le code source de chaque film. |
| `mes-films/` | Les films terminés (`.mp4`, affiche) et leur liste `films.json`. |
| `mes-styles/` | Mes styles personnalisés (voir `MY-STYLES.md`). |
| `tools/preparer.sh` | Installe tout ce qu'il faut sur la machine : ffmpeg 7, voix, musique. |
| `tools/maj-bibliotheque.sh` | Récupère la dernière version de Lemo-Opuscar sans toucher à mes fichiers. |
| `core/`, `styles/`, guides en anglais | La bibliothèque d'origine. Ne pas modifier : la mise à jour les remplace. |

## Mettre à jour la bibliothèque

Demander à Claude : « Mets à jour la bibliothèque Lemo-Opuscar ». Il lance `sh tools/maj-bibliotheque.sh`, puis fait le commit et le push.

## Licence

- Le code est sous licence MIT.
- Les guides et les fichiers `STYLE.md` sont sous CC BY-NC 4.0. Ils sont autorisés pour faire mes propres films, y compris à usage commercial, mais pas pour être revendus (voir `LICENSE`).
- Les films que je réalise m'appartiennent.
- Crédit : *Lemo-Opuscar by Lemomo (LemoLab)*.
