K=~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a4; rm -rf "$E"; mkdir -p "$E"
node "$K/scripts/servir.mjs" "$K/site-three" > "$E/url.txt" & S=$!
until U=$(cat "$E/url.txt") && [ -n "$U" ] && curl -s -o /dev/null "$U"; do sleep 0.3; done
node "$K/scripts/three-medir.mjs" "$U"; echo "saída: $?"
kill $S
python3 "$K/scripts/peso.py" "$K/site-three" | head -1
echo "three.js com gzip -9: $(cat "$K"/site-three/vendor/*.js | gzip -9 | wc -c) bytes"
