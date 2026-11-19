K=~/projetos/formacao-cinema-ia-sites-v72/kit
P=${TMPDIR:-/tmp}/ensaio-sites/a6/site-movimento/skill/site-movimento/scripts/portao-texto.js
node "$P" "$K/site/index.html"; echo "saída: $?"
node "$P" "$K/exemplos/texto-ruim-pt.html" 2>&1 | head -5; echo "saída: ${PIPESTATUS[0]}"
