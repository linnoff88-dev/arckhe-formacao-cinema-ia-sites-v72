K=~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a4; mkdir -p "$E"
node "$K/scripts/servir.mjs" "$K/site-three" > "$E/url.txt" & S=$!
until U=$(cat "$E/url.txt") && [ -n "$U" ] && curl -s -o /dev/null "$U"; do sleep 0.3; done
node "$K/scripts/three-medir.mjs" "${U}?sempre=1" | grep "^FALHA"; echo "saída: ${PIPESTATUS[0]}"
kill $S
