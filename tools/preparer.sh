#!/bin/sh
# Makemymovie : prépare la machine pour faire des films (idempotent, quelques secondes si tout est déjà là).
#   sh tools/preparer.sh        depuis la racine du repo
# 1. ffmpeg 7+ (Ubuntu fournit la 6.1, trop vieille) · 2. paquets core + voix + musique · 3. lien ~/lemo-my-styles → mes-styles/
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)

ffv=$(ffmpeg -version 2>/dev/null | sed -n '1s/^ffmpeg version n\{0,1\}\([0-9][0-9]*\)\..*/\1/p')
if [ -z "$ffv" ] || [ "$ffv" -lt 7 ]; then
  echo "↓ ffmpeg 7 (build statique)"
  t=$(mktemp -d)
  curl -fsSL -o "$t/ff.tar.xz" https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
  tar -xf "$t/ff.tar.xz" -C "$t"
  bin=/usr/local/bin; [ -w "$bin" ] || bin=$HOME/.local/bin; mkdir -p "$bin"
  cp "$t"/ffmpeg-*-static/ffmpeg "$t"/ffmpeg-*-static/ffprobe "$bin"/
  rm -rf "$t"
fi
ffmpeg -version | head -1

sh "$ROOT/plugin/skills/lemo-opuscar/scripts/setup.sh" deps voice music

mkdir -p "$ROOT/mes-styles"
if [ ! -e "$HOME/lemo-my-styles" ] || [ -L "$HOME/lemo-my-styles" ]; then
  ln -sfn "$ROOT/mes-styles" "$HOME/lemo-my-styles"
fi
echo "✓ prêt : $ROOT"
