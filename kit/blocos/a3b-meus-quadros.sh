K=~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a3; rm -rf "$E/site"
cp -r "$K/site" "$E/site"; rm -rf "$E/site/frames"
cp -r "${TMPDIR:-/tmp}/ensaio-sites/a2/quadros" "$E/site/frames"
node "$K/scripts/servir.mjs" "$E/site" > "$E/url.txt" & S=$!
until U=$(cat "$E/url.txt") && [ -n "$U" ] && curl -s -o /dev/null "$U"; do sleep 0.3; done
node "$K/scripts/verificar.mjs" "$U"; echo "saída: $?"
kill $S
