K=~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a3
node "$K/scripts/servir.mjs" "$K/site" > "$E/url.txt" & S=$!
until U=$(cat "$E/url.txt") && [ -n "$U" ] && curl -s -o /dev/null "$U"; do sleep 0.3; done
node "$K/scripts/verificar.mjs" "${U}erro-sem-contrato.html"; echo "saída: $?"
kill $S
