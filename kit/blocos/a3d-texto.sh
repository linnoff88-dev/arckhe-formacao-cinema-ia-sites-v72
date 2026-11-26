K=~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
G=${TMPDIR:-/tmp}/ensaio-sites/a3/scroll-film-studio/skills/scroll-film-studio/scripts/copy-gate.js
node "$G" "$K/site/index.html"; echo "saída: $?"
node "$G" "$K/exemplos/texto-ruim.html" 2>&1 | head -5; echo "saída: ${PIPESTATUS[0]}"
