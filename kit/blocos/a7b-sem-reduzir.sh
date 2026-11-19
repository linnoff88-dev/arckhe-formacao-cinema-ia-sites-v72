K=~/projetos/formacao-cinema-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a7; mkdir -p "$E"
node "$K/scripts/servir.mjs" "$K/site" > "$E/url.txt" & S=$!
until U=$(cat "$E/url.txt") && [ -n "$U" ] && curl -s -o /dev/null "$U"; do sleep 0.3; done
node "$K/scripts/verificar.mjs" "${U}erro-sem-reduzir.html" --reduzir | tail -1; echo "saída: ${PIPESTATUS[0]}"
kill $S
