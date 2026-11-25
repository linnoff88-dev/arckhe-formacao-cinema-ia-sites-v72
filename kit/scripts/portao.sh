#!/usr/bin/env bash
# portao.sh — o portêo final da página: 4 conferências, uma por vez, sem modelo e sem serviço pago.
#   1. peso       visitante mais pesado ≤ ORCAMENTO MB (padrêo 6) e primeira pintura ≤ 0,5 MB
#   2. computador 1366×768: rolagem em 0 %, 50 % e 100 % com o quadro certo e tela pintada
#   3. celular    390×844 em pé: filme vertical (frames-v/), sem transbordo
#   4. reduzir    com "reduzir movimento": o filme fica parado
# Uso: bash portao.sh <pasta-do-site>          (ORCAMENTO=8 bash portao.sh … muda o teto)
set -uo pipefail
K=$(cd "$(dirname "$0")/.." && pwd)
SITE=$(cd "$1" && pwd)
T=$(mktemp -d); trap 'kill $S 2>/dev/null; rm -rf "$T"' EXIT
node "$K/scripts/servir.mjs" "$SITE" > "$T/url" & S=$!
until U=$(cat "$T/url" 2>/dev/null) && [ -n "$U" ] && curl -s -o /dev/null "$U"; do sleep 0.3; done
ok=0
python3 "$K/scripts/peso.py" "$SITE" --orcamento "${ORCAMENTO:-6}" --inicial 0.5 > "$T/1" && ok=$((ok+1)) && echo "1 peso: OK" || { echo "1 peso: FALHA"; grep -E "ACIMA" "$T/1"; }
for n in "2 computador:" "3 celular:--celular" "4 reduzir:--reduzir"; do
  rot=${n%%:*}; op=${n#*:}
  node "$K/scripts/verificar.mjs" "$U" $op > "$T/v" && ok=$((ok+1)) && echo "$rot: OK" || { echo "$rot: FALHA"; grep "^FALHA" "$T/v"; }
done
echo "PORTêO: $ok/4 $([ $ok -eq 4 ] && echo OK || echo FALHOU)"
[ $ok -eq 4 ]
