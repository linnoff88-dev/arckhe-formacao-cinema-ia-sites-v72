#!/usr/bin/env bash
# capturar.sh — roda cada bloco "Terminal" do curso (kit/blocos/*.sh), um por vez, e grava a saída em kit/saidas/.
# É daqui que saem as abas "Saída capturada" das aulas. Os blocos usam ${TMPDIR:-/tmp}; a captura roda com
# um TMPDIR próprio e curto (o Chromium recusa caminho de socket longo) e troca esse caminho por /tmp na saída.
# Uso: bash capturar.sh              # todos, em ordem alfabética (a1a, a1b, a2a…), menos a8b (precisa do site publicado)
#      bash capturar.sh a2b-quadros  # um bloco
# Teto: cada bloco roda com timeout de 600 s e MemoryMax=8G (systemd-run), um por vez. Nenhum bloco chama modelo nem API.
set -uo pipefail
K=$(cd "$(dirname "$0")" && pwd)
T=${CAPTURA_TMP:-$(mktemp -d /tmp/cap.XXXX)}
mkdir -p "$K/saidas" "$T"
alvos=("$@"); [ ${#alvos[@]} -eq 0 ] && alvos=($(cd "$K/blocos" && ls *.sh | grep -v '^a8b' | sed 's/\.sh$//'))
for b in "${alvos[@]}"; do
  antes=$(pgrep -c -f chrome-headless-shell || true)
  ( cd /tmp && TMPDIR="$T" timeout 600 systemd-run --user --scope -q -p MemoryMax=8G bash "$K/blocos/$b.sh" ) 2>&1 \
    | sed "s#$T#/tmp#g; s#$HOME#~#g; s#127\.0\.0\.1:[0-9]\{2,5\}#127.0.0.1:<porta>#g" > "$K/saidas/$b.txt"
  depois=$(pgrep -c -f chrome-headless-shell || true)
  echo "$b: $(wc -l < "$K/saidas/$b.txt") linhas$([ "$depois" -gt "$antes" ] && echo " · aviso: mais Chromium sem tela do que antes ($antes → $depois; pode ser de outra sessêo)")"
done
