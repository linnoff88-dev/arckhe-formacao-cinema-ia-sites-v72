K=~/projetos/formacao-cinema-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a8; rm -rf "$E"; mkdir -p "$E"
# o seu site começa como cópia do modelo; troque a foto do produto pela sua (aqui: a lente deitada)
cp -r "$K/site" "$E/meu-site"; rm -f "$E/meu-site"/erro-*.html
bash "$K/scripts/clipe.sh" "$K/exemplos/lente2.jpg" "$E/h.mp4" 6 1.0 1.3
bash "$K/scripts/clipe.sh" "$K/exemplos/lente2.jpg" "$E/v.mp4" 6 1.0 1.3 1080x1920
bash "$K/scripts/quadros.sh" "$E/h.mp4" "$E/meu-site/frames" 1024 6
bash "$K/scripts/quadros.sh" "$E/v.mp4" "$E/meu-site/frames-v" 600 8
bash "$K/scripts/portao.sh" "$E/meu-site"; echo "saída: $?"
