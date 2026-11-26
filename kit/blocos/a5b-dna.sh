K=~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a5; cd "$E/filmarca"
node "$K/scripts/servir.mjs" "$K/site" > "$E/url.txt" & S=$!
until U=$(cat "$E/url.txt") && [ -n "$U" ] && curl -s -o /dev/null "$U"; do sleep 0.3; done
node bin/filmarca.mjs dna "$U" --out "$E/filme"; echo "dna: $?"
kill $S
ls "$E/filme/assets"
