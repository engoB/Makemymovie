#!/bin/sh
# Makemymovie : met à jour la bibliothèque Lemo-Opuscar d'origine, sans toucher à tes fichiers
# (CLAUDE.md, README.md, studio/, mes-films/, mes-styles/, films/, tools/preparer.sh, ce script).
#   sh tools/maj-bibliotheque.sh            puis vérifier « git status », commit et push
# Principe : .lemo-upstream-files liste les fichiers venus de l'original ; ils sont retirés puis remplacés par la nouvelle version.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
UP=${LEMO_OPUSCAR_REPO:-https://github.com/lemomo-ai/lemo-opuscar.git}
cd "$ROOT"
t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
git clone --quiet --depth 1 "$UP" "$t/up"
new=$(git -C "$t/up" rev-parse HEAD)
old=$(cat .lemo-upstream-version 2>/dev/null || echo aucune)
[ "$new" = "$old" ] && { echo "✓ déjà à jour ($new)"; exit 0; }

# chemins dans ce repo : README de l'original renommés, les fichiers à nous jamais écrasés
map() { case "$1" in
  README.md) echo README.lemo-opuscar.md ;;
  README.zh-CN.md) echo README.lemo-opuscar.zh-CN.md ;;
  CLAUDE.md|.gitignore|.github/workflows/pages.yml|.github/ISSUE_TEMPLATE/*) ;;
  *) echo "$1" ;;
esac; }

# 1. retirer les anciens fichiers de l'original
while IFS= read -r f; do p=$(map "$f"); [ -n "$p" ] && rm -f "$p"; done < .lemo-upstream-files
# 2. copier les nouveaux
git -C "$t/up" ls-files > "$t/list"
while IFS= read -r f; do
  p=$(map "$f"); [ -n "$p" ] || continue
  mkdir -p "$(dirname "$p")"; cp -p "$t/up/$f" "$p"
done < "$t/list"
cp "$t/list" .lemo-upstream-files
echo "$new" > .lemo-upstream-version
# 3. .gitignore = celui de l'original (films/ suivi) + notre bloc
ours=$(sed -n '/^# ---- Makemymovie ----$/,$p' .gitignore)
sed 's#^/films/$#\# (Makemymovie) les films sont suivis : voir le bloc en bas#' "$t/up/.gitignore" > .gitignore
printf '\n%s\n' "$ours" >> .gitignore
# 4. les données du Studio (noms des styles)
python3 studio/outils/construire.py || echo "! studio/outils/construire.py a échoué : un style nouveau n'a pas encore de nom français dans studio/outils/fr.json"
echo "✓ bibliothèque mise à jour : $old → $new"
echo "  vérifie « git status », puis commit et push. Lis CHANGELOG / README.lemo-opuscar.md pour les nouveautés."
